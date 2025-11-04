import axios from 'axios'

interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
}

interface TurtleSoupGame {
  id: string
  question: string
  answer: string
  hint: string
}

interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}

class TurtleSoupApiService {
  private baseURL = '/api'

  /**
   * 发送聊天消息到通义千问
   */
  async sendChatMessage(prompt: string): Promise<string> {
    try {
      const response = await axios.post(`${this.baseURL}/qwen/chat`, { prompt })
      return response.data.result
    } catch (error) {
      console.error('发送聊天消息失败:', error)
      throw new Error('通义千问聊天请求失败')
    }
  }

  /**
   * 生成新的海龟汤谜题
   */
  async generatePuzzle(): Promise<TurtleSoupGame> {
    try {
      const prompt = `请给我一个海龟汤谜题，包含问题、答案和提示。格式要求：
问题：描述一个荒谬或难以理解的情境
答案：解释情境背后的真实原因
提示：给玩家一个思考方向的提示

请确保谜题有趣且具有一定挑战性。`

      const result = await this.sendChatMessage(prompt)

      // 解析响应内容
      const questionMatch = result.match(/问题：(.*?)(?:\n|$)/)
      const answerMatch = result.match(/答案：(.*?)(?:\n|$)/)
      const hintMatch = result.match(/提示：(.*?)(?:\n|$)/)

      const puzzle: TurtleSoupGame = {
        id: Date.now().toString(),
        question: questionMatch?.[1]?.trim() || '未知问题，请重新生成',
        answer: answerMatch?.[1]?.trim() || '未知答案',
        hint: hintMatch?.[1]?.trim() || '无提示',
      }

      return puzzle
    } catch (error) {
      console.error('生成谜题失败:', error)
      throw new Error('无法生成新的海龟汤谜题')
    }
  }

  /**
   * 向AI提问关于当前谜题的问题
   */
  async askQuestion(
    question: string,
    puzzleQuestion: string,
    puzzleAnswer: string,
    chatHistory: string[],
    questionCount: number,
  ): Promise<string> {
    try {
      let prompt = `关于这个海龟汤谜题："${puzzleQuestion}"，玩家提问："${question}"。
谜底答案："${puzzleAnswer}"

请按照以下规则回答：`

      // 基础回答规则
      prompt += `
1. 首先检查玩家的提问是否与谜底答案高度匹配（90%以上相似度）
   - 如果匹配，回答：'🎉 回答正确！\n\n汤底：${puzzleAnswer}\n\n提示：游戏结束，恭喜你猜对了！'
   - 否则继续下面的规则`

      // 标准回答规则
      prompt += `
2. 标准回答规则：
   - 如果问题直接或间接与谜底相关，回答"是"
   - 如果问题与谜底无关，回答"不是"  
   - 如果问题模糊不清或无法判断，回答"没有关系"`

      // 游戏状态反馈（提问3次以上）
      if (questionCount >= 3) {
        prompt += `
3. 游戏状态反馈（提问${questionCount}次后）：
   - 分析玩家当前的理解进度，在标准回答后添加状态反馈
   - 状态反馈选项（选择一个最合适的）：
     * 还差的很远 - 玩家理解与谜底完全不符
     * 方向完全错了 - 玩家思路与谜底相反
     * 进度一半左右 - 玩家部分正确，但还有关键信息缺失
     * 基本框架对了 - 玩家理解了核心框架，但细节有误
     * 基本猜出来了 - 玩家接近答案，只差最后一步

示例回答格式：
是。基本框架对了
不是。方向完全错了
没有关系。还差的很远`

        // 添加聊天历史上下文
        if (chatHistory.length > 0) {
          prompt += `\n\n聊天历史（供参考玩家思路）：\n${chatHistory.slice(-5).join('\n')}`
        }
      }

      prompt += `\n\n请严格按照上述规则回答，不要提供额外解释。`

      const result = await this.sendChatMessage(prompt)
      // 检查是否匹配答案
      const answerLower = puzzleAnswer.toLowerCase()
      const questionLower = question.toLowerCase()

      // 简单的相似度检测（实际应用中可以使用更复杂的算法）
      const similarityThreshold = 0.9
      let similarity = 0

      // 计算关键词匹配度
      const answerWords = answerLower.split(/[，。！？、\s]+/).filter((word) => word.length > 1)
      const questionWords = questionLower.split(/[，。！？、\s]+/).filter((word) => word.length > 1)

      if (answerWords.length > 0) {
        const matchedWords = questionWords.filter((qWord) =>
          answerWords.some((aWord) => aWord.includes(qWord) || qWord.includes(aWord)),
        )
        similarity = matchedWords.length / Math.max(answerWords.length, questionWords.length)
      }

      // 如果相似度超过阈值，直接返回完整的正确答案（与查看答案一致）
      if (similarity >= similarityThreshold) {
        return `🎉 回答正确！\n\n汤底：${puzzleAnswer}\n\n提示：${'游戏结束，恭喜你猜对了！'}`
      }

      return result
    } catch (error) {
      console.error('提问失败:', error)
      throw new Error('无法获取AI回答')
    }
  }
}

export const turtleSoupApiService = new TurtleSoupApiService()
