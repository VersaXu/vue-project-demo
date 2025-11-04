import { ref } from 'vue'
import { QWEN_CONFIG } from '@/config/ernieConfig'
import {
  TURTLE_SOUP_PUZZLES,
  getRandomPuzzle,
  getPuzzlesByCategory,
} from '@/config/turtleSoupPuzzles'
import {
  TURTLE_SOUP_KNOWLEDGE_BASE,
  getRandomPuzzleFromKB,
  getAllCategories,
  getKnowledgeBaseStats,
} from '@/config/turtleSoupKnowledgeBase'
import { turtleSoupApiService } from './turtleSoupApi'
import { useTurtleSoupStore } from '@/stores/turtleSoupStore'

interface TurtleSoupGame {
  id: string
  question: string
  answer: string
  hint: string
}

interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
  timestamp: number
}

let turtleSoupStore: ReturnType<typeof useTurtleSoupStore> | null = null
const chatHistory = ref<ChatMessage[]>([])
const gameContext = ref<string[]>([]) // 存储对话上下文

/**
 * 获取turtleSoupStore实例（延迟初始化）
 */
const getTurtleSoupStore = () => {
  if (!turtleSoupStore) {
    turtleSoupStore = useTurtleSoupStore()
  }
  return turtleSoupStore
}

/**
 * 检查API配置是否有效
 */
const checkApiConfig = () => {
  return !QWEN_CONFIG.API_KEY.includes('sk-')
}

const startNewGame = async (preserveChatHistory = false, useKnowledgeBase = true) => {
  try {
    // 重置游戏状态
    gameContext.value = []
    if (!preserveChatHistory) {
      chatHistory.value = []
    }

    let puzzle: TurtleSoupGame

    if (checkApiConfig()) {
      // 使用API生成新谜题
      puzzle = await turtleSoupApiService.generatePuzzle()
    } else {
      // 使用本地谜题库 - 优先使用知识库
      console.warn('使用默认密钥，将使用本地谜题库')
      let randomPuzzle

      if (useKnowledgeBase) {
        // 从扩展知识库中随机选择
        randomPuzzle = getRandomPuzzleFromKB({ minPopularity: 3 }) // 至少3星流行度
      } else {
        // 使用原有谜题
        randomPuzzle = getRandomPuzzle()
      }

      puzzle = {
        id: Date.now().toString(),
        question: randomPuzzle.question,
        answer: randomPuzzle.answer,
        hint: randomPuzzle.hint,
      }
    }

    // 使用store管理游戏状态
    const store = getTurtleSoupStore()
    store.startNewGame({
      ...puzzle,
      difficulty: 'medium',
      category: 'generated',
    })

    // 初始化对话历史（如果保留历史则只在历史为空时添加）
    if (!preserveChatHistory || chatHistory.value.length === 0) {
      chatHistory.value = [
        {
          role: 'assistant',
          content: `谜题：${puzzle.question}\n\n游戏规则：通过提问来找出原因，我只能回答"是"、"不是"或"没有关系"。`,
          timestamp: Date.now(),
        },
      ]
    } else {
      // 保留历史，只添加新谜题信息
      chatHistory.value.push({
        role: 'assistant',
        content: `🎲 新谜题开始！\n\n谜题：${puzzle.question}`,
        timestamp: Date.now(),
      })
    }

    // 添加上下文
    gameContext.value.push(`谜题：${puzzle.question}`)

    return puzzle
  } catch (error) {
    console.error('开始新游戏失败:', error)
    // 使用本地谜题作为后备方案 - 优先使用知识库
    let randomPuzzle
    if (Math.random() > 0.5) {
      // 50%概率使用知识库
      randomPuzzle = getRandomPuzzleFromKB()
    } else {
      randomPuzzle = getRandomPuzzle()
    }

    const puzzle = {
      id: Date.now().toString(),
      question: randomPuzzle.question,
      answer: randomPuzzle.answer,
      hint: randomPuzzle.hint,
    }

    const store = getTurtleSoupStore()
    store.startNewGame({
      ...puzzle,
      difficulty: 'medium',
      category: 'generated',
    })

    if (!preserveChatHistory || chatHistory.value.length === 0) {
      chatHistory.value = [
        {
          role: 'assistant',
          content: `谜题：${randomPuzzle.question}\n\n游戏规则：通过提问来找出原因，我只能回答"是"、"不是"或"没有关系"。`,
          timestamp: Date.now(),
        },
      ]
    } else {
      chatHistory.value.push({
        role: 'assistant',
        content: `🎲 新谜题开始！\n\n谜题：${randomPuzzle.question}`,
        timestamp: Date.now(),
      })
    }

    return puzzle
  }
}

/**
 * 向AI提问
 *
 * @param question 玩家提问的问题
 * @returns AI的回答或错误信息
 */
const askQuestion = async (question: string) => {
  const store = getTurtleSoupStore()
  if (!store.currentGame) return null

  try {
    // 记录提问
    store.recordQuestion()

    let answer: string

    if (checkApiConfig()) {
      // 使用API服务（传递更多上下文信息）
      const userMessages = chatHistory.value.filter((msg) => msg.role === 'user')
      const questionCount = userMessages.length + 1 // 当前是第几个问题

      // 提取最近的用户提问作为聊天历史上下文
      const recentHistory = chatHistory.value.slice(-10).map((msg) => `${msg.role}: ${msg.content}`)

      answer = await turtleSoupApiService.askQuestion(
        question,
        store.currentGame.question,
        store.currentGame.answer,
        recentHistory,
        questionCount,
      )

      // 检查是否回答正确（包含"回答正确"关键词）
      if (answer.includes('回答正确')) {
        // 标记游戏为已解决
        markAsSolved()
        // 添加正确答案到聊天记录
        chatHistory.value.push({
          role: 'assistant',
          content: answer,
          timestamp: Date.now(),
        })
        // 返回特殊标记，让前端知道这是正确答案
        return `CORRECT_ANSWER:${answer}`
      }
    } else {
      // 使用本地逻辑（简化版）
      answer = simulateAnswer(question, store.currentGame)
    }

    // 检查是否是正确答案标记
    if (answer.startsWith('CORRECT_ANSWER:')) {
      const actualAnswer = answer.replace('CORRECT_ANSWER:', '')
      // 添加上下文
      gameContext.value.push(`玩家提问：${question}`, `系统回答：${actualAnswer}`)

      // 更新对话历史
      chatHistory.value.push(
        { role: 'user', content: question, timestamp: Date.now() },
        { role: 'assistant', content: actualAnswer, timestamp: Date.now() },
      )

      return actualAnswer
    }

    // 添加上下文
    gameContext.value.push(`玩家提问：${question}`, `系统回答：${answer}`)

    // 更新对话历史
    chatHistory.value.push(
      { role: 'user', content: question, timestamp: Date.now() },
      { role: 'assistant', content: answer, timestamp: Date.now() },
    )

    return answer
  } catch (error) {
    console.error('提问失败:', error)
    const errorMessage = '无法获取AI回答，请重试或开始新游戏'

    chatHistory.value.push(
      { role: 'user', content: question, timestamp: Date.now() },
      { role: 'assistant', content: errorMessage, timestamp: Date.now() },
    )

    return errorMessage
  }
}

/**
 * 模拟AI回答（当API不可用时使用）
 */
const simulateAnswer = (question: string, game: TurtleSoupGame): string => {
  const questionLower = question.toLowerCase()
  const answerLower = game.answer.toLowerCase()

  // 扩展的关键词匹配逻辑
  const keywords = [
    '朋友',
    '海',
    '肉',
    '按钮',
    '身高',
    '沙漠',
    '包裹',
    '敲门',
    '盲人',
    '牛排',
    '大楼',
    '兄弟',
    '父亲',
    '儿子',
    '照片',
    '房间',
    '水',
    '玻璃',
    '雪',
    '背包',
    '桥',
    '死亡',
    '自杀',
    '医院',
    '味道',
    '声音',
    '跳伞',
    '降落伞',
  ]

  for (const keyword of keywords) {
    if (questionLower.includes(keyword) && answerLower.includes(keyword)) {
      return '是'
    }
  }

  // 随机返回结果作为后备
  const responses = ['是', '不是', '没有关系']
  return responses[Math.floor(Math.random() * responses.length)]
}

const revealAnswer = () => {
  const store = getTurtleSoupStore()
  if (!store.currentGame) return null

  // 先保存答案信息
  const answer = store.currentGame.answer
  const hint = store.currentGame.hint
  const answerContent = `🎉 游戏结束！\n\n汤底：${answer}\n\n提示：${hint}`

  chatHistory.value.push({
    role: 'assistant',
    content: answerContent,
    timestamp: Date.now(),
  })

  // 记录游戏结束（未解决状态）
  store.endGame(false)

  return answer
}

/**
 * 获取游戏提示
 */
const getHint = () => {
  const store = getTurtleSoupStore()
  if (!store.currentGame) return null

  const hintContent = `💡 提示：${store.currentGame.hint}`

  chatHistory.value.push({
    role: 'assistant',
    content: hintContent,
    timestamp: Date.now(),
  })

  return store.currentGame.hint
}

/**
 * 标记游戏为已解决
 */
const markAsSolved = () => {
  const store = getTurtleSoupStore()
  if (store.currentSession) {
    store.endGame(true)
  }
}

/**
 * 重置游戏
 */
const resetGame = () => {
  const store = getTurtleSoupStore()
  if (store.currentSession) {
    store.endGame(false)
  }
  chatHistory.value = []
  gameContext.value = []
}

/**
 * 获取游戏统计信息
 */
const getGameStats = () => {
  const store = getTurtleSoupStore()
  return {
    stats: store.gameStats,
    averageQuestions: store.getAverageQuestionsPerGame(),
    successRate: store.getSuccessRate(),
  }
}

export const useTurtleSoup = () => {
  const store = getTurtleSoupStore()
  return {
    currentGame: store.currentGame,
    chatHistory,
    gameContext,
    startNewGame,
    askQuestion,
    revealAnswer,
    getHint,
    markAsSolved,
    resetGame,
    getGameStats,
    gameStats: store.gameStats,
  }
}
