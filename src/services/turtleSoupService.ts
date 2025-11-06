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
  clues: string[] // 必须字段，与TurtleSoupPuzzle保持一致
  difficulty: 'easy' | 'medium' | 'hard'
  category: string
}

interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
  timestamp: number
  isLoading?: boolean
  messageId?: string
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
        clues: randomPuzzle.clues,
        difficulty: randomPuzzle.difficulty,
        category: randomPuzzle.category
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
      clues: randomPuzzle.clues,
      difficulty: randomPuzzle.difficulty,
      category: randomPuzzle.category
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
    // 立即添加用户问题到聊天历史，显示加载状态
    const userMessage = { role: 'user' as const, content: question, timestamp: Date.now() }
    chatHistory.value.push(userMessage)
    
    // 添加加载中的AI消息
    const loadingMessageId = Date.now().toString()
    const loadingMessage = {
      role: 'assistant' as const,
      content: '🤔 AI思考中...',
      timestamp: Date.now(),
      isLoading: true,
      messageId: loadingMessageId
    }
    chatHistory.value.push(loadingMessage)

    let answer: string
    if (checkApiConfig()) {
      // 使用API服务（传递更多上下文信息）
      const userMessages = chatHistory.value.filter((msg) => msg.role === 'user' && !msg.isLoading)
      const questionCount = userMessages.length

      // 检查是否需要提供直接线索（连续3次无关回答）
      let directClue = ''
      if (store.currentSession && store.currentSession.unrelatedQuestions >= 3) {
        directClue = `\n\n💡 直接线索：${store.currentGame.hint}`
        store.currentSession.unrelatedQuestions = 0 // 重置计数器
      }

      // 提取完整的聊天历史上下文（排除加载消息）
      const fullHistory = chatHistory.value
        .filter(msg => !msg.isLoading)
        .slice(-20)
        .map((msg) => `${msg.role}: ${msg.content}`)

      const apiResponse = await turtleSoupApiService.askQuestion(
        question,
        store.currentGame.question,
        store.currentGame.answer,
        fullHistory,
        questionCount,
        directClue
      )

      // 检查是否应该结束游戏
      if (apiResponse.includes('🎉 回答正确！')) {
        markAsSolved()
        answer = apiResponse
      } else {
        answer = apiResponse
      }
    } else {
      // 使用大模型API进行准确判断
      try {
        // 构建完整的对话上下文
        const conversationContext = chatHistory.value
          .filter(msg => !msg.isLoading)
          .slice(-10)
          .map(msg => `${msg.role === 'user' ? '玩家' : '系统'}: ${msg.content}`)
          .join('\n')

        // 调用大模型API进行准确判断
        const judgment = await callLargeModelForJudgment(
          store.currentGame.question,
          store.currentGame.answer,
          question,
          conversationContext
        )
        
        answer = judgment.response
        
        // 检查是否应该结束游戏
        if (judgment.shouldEndGame) {
          markAsSolved()
          return `🎉 回答正确！\n\n汤底：${store.currentGame.answer}\n\n提示：${store.currentGame.hint}`
        }
        
        // 处理线索建议和自动提示
        if (store.currentSession) {
          // 添加自动线索（基于提问次数）
          try {
            const autoHint = provideAutoHint(store.currentSession, store.currentGame as TurtleSoupGame)
            if (autoHint) {
              answer += autoHint
            }
          } catch (e) {
            console.error('提供自动提示失败:', e)
          }
          
          // 处理大模型建议的线索
          if (judgment.hintSuggestion && store.currentGame.clues && store.currentGame.clues.length > 0) {
            const hintIndex = Math.min(
              Math.floor(store.currentSession.unrelatedQuestions / 2),
              store.currentGame.clues.length - 1
            )
            answer += `\n\n💡 智能提示：${store.currentGame.clues[hintIndex]}`
          }
        }
      } catch (apiError) {
        console.warn('大模型API调用失败，使用备用逻辑:', apiError)
        // API调用失败时使用改进的本地逻辑
        answer = improvedSimulateAnswer(question, {
          id: store.currentGame.id || Date.now().toString(),
          question: store.currentGame.question,
          answer: store.currentGame.answer,
          hint: store.currentGame.hint,
          clues: store.currentGame.clues || [],
          difficulty: store.currentGame.difficulty || 'medium',
          category: store.currentGame.category || 'generated'
        } as TurtleSoupGame)
      }
    }

    // 移除加载消息
    const loadingIndex = chatHistory.value.findIndex(msg => msg.messageId === loadingMessageId)
    if (loadingIndex !== -1) {
      chatHistory.value.splice(loadingIndex, 1)
    }

    // 根据回答内容更新统计
    const cleanAnswer = typeof answer === 'string' ? answer.split('\n')[0].trim() : '不是'
    if (cleanAnswer === '是') {
      store.recordQuestion('yes')
    } else if (cleanAnswer === '没有关系') {
      store.recordQuestion('irrelevant')
    } else {
      store.recordQuestion('no')
    }

    // 添加最终回答到聊天历史
    const finalAnswer = {
      role: 'assistant' as const,
      content: answer,
      timestamp: Date.now()
    }
    chatHistory.value.push(finalAnswer)

    // 添加上下文
    gameContext.value.push(`玩家提问：${question}`, `系统回答：${answer}`)

    return answer
  } catch (error) {
    console.error('提问失败:', error)
    
    // 移除加载消息
    const loadingIndex = chatHistory.value.findIndex(msg => msg.isLoading)
    if (loadingIndex !== -1) {
      chatHistory.value.splice(loadingIndex, 1)
    }

    const errorMessage = '无法获取AI回答，请重试或开始新游戏'
    const errorAnswer = {
      role: 'assistant' as const,
      content: errorMessage,
      timestamp: Date.now()
    }
    chatHistory.value.push(errorAnswer)

    return errorMessage
  }
}

/**
 * 调用大模型API进行准确判断
 */
const callLargeModelForJudgment = async (
  puzzle: string,
  answer: string,
  question: string,
  context: string
): Promise<{response: string; shouldEndGame?: boolean; hintSuggestion?: string}> => {
  // 这里应该调用实际的大模型API
  // 由于API密钥配置检查，如果配置无效则使用改进的本地逻辑
  if (!checkApiConfig()) {
    return {
      response: improvedSimulateAnswer(question, { question: puzzle, answer } as TurtleSoupGame)
    }
  }

  // 实际API调用逻辑应该在turtleSoupApiService中实现
  try {
    const response = await turtleSoupApiService.judgeWithLargeModel(
      puzzle,
      answer,
      question,
      context
    )
    return response
  } catch (error) {
    console.warn('大模型API调用失败，使用改进的本地逻辑:', error)
    return {
      response: improvedSimulateAnswer(question, { question: puzzle, answer } as TurtleSoupGame)
    }
  }
}

/**
 * 改进的模拟AI回答（当API不可用时使用）
 */
const improvedSimulateAnswer = (question: string, game: TurtleSoupGame): string => {
  const questionLower = question.toLowerCase()
  const answerLower = game.answer.toLowerCase()
  const puzzleQuestionLower = game.question.toLowerCase()
  
  // 尝试检测用户是否在提供完整解释或猜测答案
  // 不依赖特定关键词，而是检查语句长度和复杂度
  // 通常猜测答案的句子会较长，包含多个子句或推理过程
  if (questionLower.length > 20 && 
      (questionLower.includes('，') || questionLower.includes('。') || 
       questionLower.includes(',') || questionLower.includes('.') ||
       questionLower.includes('是因为') || questionLower.includes('所以'))) {
    
    // 提取答案中的核心概念
    const answerConcepts = extractCoreConcepts(answerLower);
    
    // 提取问题中的核心概念
    const questionConcepts = extractCoreConcepts(questionLower);
    
    // 计算概念重叠
    let conceptOverlap = 0;
    for (const concept of answerConcepts) {
      if (questionConcepts.some(qc => 
          qc.includes(concept) || concept.includes(qc) || 
          calculateSimilarity(concept, qc) > 0.7)) {
        conceptOverlap++;
      }
    }
    
    // 如果有足够的概念重叠，可能是正确答案
    if (conceptOverlap >= Math.max(1, Math.floor(answerConcepts.length * 0.25))) {
      return '🎉 回答正确！\n\n汤底：' + game.answer + '\n\n提示：' + game.hint;
    }
  }

  // 更精确的关键词匹配逻辑 - 用于非猜测答案的常规问题
  const positiveKeywords = [
    '朋友', '海', '肉', '按钮', '身高', '沙漠', '包裹', '敲门',
    '盲人', '牛排', '大楼', '兄弟', '父亲', '儿子', '照片', '房间',
    '水', '玻璃', '雪', '背包', '桥', '死亡', '自杀', '医院',
    '味道', '声音', '跳伞', '降落伞', '圣诞老人', '礼物', '金鱼',
    '鱼缸', '连体', '婴儿', '手术', '孕妇', '胎儿', '分娩'
  ]

  const negativeKeywords = [
    '天气', '时间', '颜色', '大小', '多少', '哪里', '什么时候',
    '为什么叫', '什么意思', '定义', '解释', '说明'
  ]

  // 从谜题和答案中提取额外关键词
  const puzzleSpecificKeywords = extractKeywords(puzzleQuestionLower);
  const answerSpecificKeywords = extractKeywords(answerLower);
  
  // 将谜题特有关键词也加入正面关键词列表
  const combinedPositiveKeywords = [...positiveKeywords, ...puzzleSpecificKeywords, ...answerSpecificKeywords];

  // 检查正面关键词匹配
  for (const keyword of combinedPositiveKeywords) {
    if (questionLower.includes(keyword) && (answerLower.includes(keyword) || puzzleQuestionLower.includes(keyword))) {
      return '是'
    }
  }

  // 检查负面关键词（通常表示无关问题）
  for (const keyword of negativeKeywords) {
    if (questionLower.includes(keyword)) {
      return '没有关系'
    }
  }

  // 基于问题长度的启发式判断
  if (questionLower.length < 4) {
    return '没有关系'
  }

  // 使用确定性算法而不是随机返回
  // 基于问题哈希值生成确定性但看似随机的回答
  const hash = questionLower.split('').reduce((acc, char) => {
    return acc + char.charCodeAt(0)
  }, 0)

  // 70%概率返回"不是"，20%概率返回"没有关系"，10%概率返回"是"
  const responses = ['不是', '不是', '不是', '不是', '不是', '不是', '不是', '没有关系', '没有关系', '是']
  return responses[hash % responses.length]
}

/**
 * 提取文本中的关键词
 */
function extractKeywords(text: string): string[] {
  return text
    .split(/\s+|，|。|！|？|,|\.|!|\?/)
    .filter(word => word.length > 1)
    .map(word => word.trim())
    .filter(Boolean);
}

/**
 * 提取文本中的核心概念（更复杂的处理）
 */
function extractCoreConcepts(text: string): string[] {
  // 分割成句子
  const sentences = text.split(/。|！|？|\.|!|\?/).filter(Boolean);
  
  // 从每个句子中提取名词短语和动词短语
  const concepts: string[] = [];
  
  for (const sentence of sentences) {
    // 分割成短语（通过逗号或分号）
    const phrases = sentence.split(/，|,|；|;/).filter(Boolean);
    
    for (const phrase of phrases) {
      // 清理并添加短语
      const cleanPhrase = phrase.trim();
      if (cleanPhrase.length > 1) {
        concepts.push(cleanPhrase);
      }
      
      // 提取2-3个字的词组（可能是核心名词或动词）
      const words = cleanPhrase.match(/[\u4e00-\u9fa5]{2,3}/g) || [];
      concepts.push(...words);
    }
  }
  
  // 去重
  return [...new Set(concepts)];
}

/**
 * 计算两个字符串的相似度（简化版）
 */
function calculateSimilarity(str1: string, str2: string): number {
  if (!str1 || !str2) return 0;
  
  // 对于非常短的字符串，直接检查包含关系
  if (str1.length <= 2 || str2.length <= 2) {
    return str1.includes(str2) || str2.includes(str1) ? 1.0 : 0.0;
  }
  
  // 计算重叠字符数
  let overlap = 0;
  for (const char of str1) {
    if (str2.includes(char)) {
      overlap++;
    }
  }
  
  // 返回相对于较短字符串长度的重叠比例
  return overlap / Math.min(str1.length, str2.length);
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

  // 获取当前游戏会话
  const session = store.currentSession
  if (!session) return null

  // 基于提问次数和无关问题数量计算线索级别
  const totalQuestions = session.usefulQuestions + session.unrelatedQuestions
  const hintLevel = Math.min(
    Math.floor(totalQuestions / 2), // 每2个问题提升一级线索
    store.currentGame.clues?.length || 1
  )

  // 获取对应的线索内容
  let hintContent = ''
  if (store.currentGame.clues && store.currentGame.clues.length > 0) {
    hintContent = `💡 线索提示 (${hintLevel + 1}/${store.currentGame.clues.length + 1}):\n`
    // 总是显示基础提示
    hintContent += `- ${store.currentGame.hint}\n`
    // 显示已解锁的线索
    for (let i = 0; i <= hintLevel && i < store.currentGame.clues.length; i++) {
      hintContent += `- ${store.currentGame.clues[i]}\n`
    }
  } else {
    hintContent = `💡 提示：${store.currentGame.hint}`
  }

  chatHistory.value.push({
    role: 'assistant',
    content: hintContent,
    timestamp: Date.now(),
  })

  return hintContent
}

/**
 * 自动提供线索（在多次无关提问后）
 */
const provideAutoHint = (session: any, game: TurtleSoupGame): string => {
  const totalQuestions = session.usefulQuestions + session.unrelatedQuestions
  
  // 在特定提问次数后自动提供线索
  const hintTriggers = [3, 6, 9, 12] // 在第3、6、9、12个问题后提供线索
  const triggerIndex = hintTriggers.findIndex(trigger => totalQuestions === trigger)
  
  if (triggerIndex !== -1 && game.clues && game.clues.length > triggerIndex) {
    return `\n\n💡 自动线索：${game.clues[triggerIndex]}`
  }
  
  return ''
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
    // 导出新的改进方法用于测试
    improvedSimulateAnswer,
  }
}
