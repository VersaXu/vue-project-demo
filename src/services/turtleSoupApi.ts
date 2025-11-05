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
   * 检查用户输入是否直接匹配答案
   * 这个函数用于识别直接复制汤底的情况
   */
  private isDirectAnswerMatch(question: string, answer: string): boolean {
    // 如果问题包含答案的大部分内容
    if (question.includes(answer) || answer.includes(question)) {
      return true;
    }
    
    // 计算问题和答案的相似度
    // 1. 去除标点符号和空格
    const cleanQuestion = question.replace(/[.,，。、？！?!\s]/g, '');
    const cleanAnswer = answer.replace(/[.,，。、？！?!\s]/g, '');
    
    // 2. 如果清理后的文本一样，直接返回匹配
    if (cleanQuestion === cleanAnswer) {
      return true;
    }
    
    // 3. 如果问题包含答案的80%以上的字符，认为是匹配
    let matchCount = 0;
    for (const char of cleanAnswer) {
      if (cleanQuestion.includes(char)) {
        matchCount++;
      }
    }
    
    const similarityRatio = matchCount / cleanAnswer.length;
    return similarityRatio > 0.8;
  }

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
    directClue: string = ''
  ): Promise<string> {
    try {
      // 首先，直接检查用户输入是否包含完整答案或高度相似
      // 这是一个快速预检查，避免直接复制汤底只得到"是"的回答
      const questionLower = question.toLowerCase().trim();
      const answerLower = puzzleAnswer.toLowerCase().trim();
      
      // 如果用户输入直接包含答案的大部分内容，或者高度相似
      if (this.isDirectAnswerMatch(questionLower, answerLower)) {
        return `🎉 回答正确！\n\n汤底：${puzzleAnswer}\n\n提示：游戏结束，恭喜你猜对了！`;
      }
      
      let prompt = `关于这个海龟汤谜题："${puzzleQuestion}"，玩家提问："${question}"。
谜底答案："${puzzleAnswer}"

请严格按照以下规则回答：`

      // 添加直接线索（如果有）
      if (directClue) {
        prompt += `\n\n额外线索：${directClue}`
      }

      // 基础回答规则
      prompt += `
1. 首先检查玩家的提问是否与谜底答案高度匹配（80%以上相似度）
   - 如果匹配，回答：'?? 回答正确！\n\n汤底：${puzzleAnswer}\n\n提示：游戏结束，恭喜你猜对了！'
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
      
      // 检查是否回答正确
      if (result.includes('🎉 回答正确！')) {
        return result
      }
      
      // 二次检查：如果回答是"是"，但问题实际上非常接近答案，则返回正确答案
      // 这解决了复制汤底但只得到"是"的问题
      const cleanResult = result.trim()
      if (cleanResult === '是' || cleanResult.startsWith('是。')) {
        // 再次检查问题是否直接包含答案的主要部分
        if (this.isDirectAnswerMatch(questionLower, answerLower)) {
          return `🎉 回答正确！\n\n汤底：${puzzleAnswer}\n\n提示：游戏结束，恭喜你猜对了！`;
        }
      }

      // 确保返回的是标准回答格式
      if (cleanResult === '是' || cleanResult === '不是' || cleanResult === '没有关系') {
        return cleanResult
      }

      // 如果包含状态反馈，提取基础回答
      if (cleanResult.includes('。')) {
        const baseAnswer = cleanResult.split('。')[0]
        if (baseAnswer === '是' || baseAnswer === '不是' || baseAnswer === '没有关系') {
          return baseAnswer
        }
      }

      // 默认返回"不是"
      return '不是'
    } catch (error) {
      console.error('提问失败:', error)
      throw new Error('无法获取AI回答')
    }
  }

  /**
   * 使用大模型API进行准确判断
   */
  async judgeWithLargeModel(
    puzzle: string,
    answer: string,
    question: string,
    context: string
  ): Promise<{response: string; shouldEndGame?: boolean; hintSuggestion?: string}> {
    try {
      // 分析问题的语义结构，检查是否在尝试提供解释或猜测
      // 不再依赖特定关键词，而是分析句子结构和长度
      const isLongQuestion = question.length > 20;
      const hasExplanationStructure = 
        question.includes('，') || 
        question.includes('。') || 
        question.includes(',') || 
        question.includes('.') ||
        question.includes('是因为') || 
        question.includes('所以') ||
        question.includes('我觉得') ||
        question.includes('应该');
      
      // 较长且有解释性结构的问题可能是在猜测答案
      if (isLongQuestion && hasExplanationStructure) {
        // 这里不再做简单的关键词匹配，而是让大模型直接判断语义
        const guessCheckPrompt = `
海龟汤游戏答案判断：

谜题：${puzzle}
正确答案：${answer}
玩家猜测：${question}

请判断玩家的猜测是否在语义上与正确答案相符（不要求完全一致的表述，但核心概念和因果关系应大致相同）。
判断标准：
1. 核心概念一致性 - 关键人物、物品、场景、事件是否一致
2. 因果关系一致性 - 事件发生的原因和结果是否一致
3. 逻辑解释一致性 - 整体解释是否符合谜底逻辑

请直接回答：
- 如果猜测本质上与答案相符（即使表述不同），回答"正确"
- 如果猜测与答案不符或差距较大，回答"不正确"
- 如果猜测部分正确但缺少关键信息，回答"部分正确"
`;

        // 检查玩家猜测是否正确
        const guessResult = await this.sendChatMessage(guessCheckPrompt);
        const cleanGuessResult = guessResult.trim().toLowerCase();
        
        if (cleanGuessResult.includes('正确') && !cleanGuessResult.includes('不正确') && !cleanGuessResult.includes('部分正确')) {
          // 玩家猜对了
          return {
            response: '🎉 回答正确！\n\n汤底：' + answer + '\n\n提示：谜题已解开，恭喜你猜对了！',
            shouldEndGame: true
          };
        } else if (cleanGuessResult.includes('部分正确')) {
          // 部分正确，给予鼓励
          return {
            response: '你的猜测部分正确，但还缺少一些关键信息。继续思考！',
            shouldEndGame: false,
            hintSuggestion: true
          };
        }
        // 如果猜测不正确，继续下面的常规问题判断
      }
      
      // 对于非猜测性问题，使用更强的语义理解提示词
      const prompt = `【海龟汤游戏语义判断】
谜题：${puzzle}
谜底：${answer}
玩家提问：${question}

对话上下文：
${context}

请执行以下判断任务：

1. 语义理解判断：
   - 分析玩家提问的语义内容，不要只看关键词
   - 判断提问是否在尝试猜测完整答案或提供解释
   - 如果是猜测答案，评估其与谜底的语义相似度（不要求字面相似）

2. 相关性判断：
   - 如果问题直接或间接触及谜底核心概念，回答"是"
   - 如果问题与谜底无关或方向错误，回答"不是"
   - 如果问题模糊不清或无法判断，回答"没有关系"

3. 进度评估：
   - 根据对话历史，评估玩家接近答案的程度
   - 考虑是否需要提供线索帮助玩家

请返回JSON格式响应：
{
  "response": "是|不是|没有关系|🎉 回答正确！",
  "shouldEndGame": boolean,
  "hintSuggestion": boolean,
  "progressAssessment": "远离答案|接近答案|非常接近",
  "reasoning": "简要解释判断理由"
}`

      const result = await this.sendChatMessage(prompt)
      
      try {
        const parsed = JSON.parse(result)
        // 增加对进度评估的处理
        let response = parsed.response || '不是';
        
        // 如果模型判断玩家已经非常接近答案，可以给予额外提示
        if (parsed.progressAssessment === "非常接近" && !response.includes("回答正确")) {
          response += "\n\n你已经非常接近答案了，再仔细思考一下！";
        }
        
        return {
          response: response,
          shouldEndGame: parsed.shouldEndGame || false,
          hintSuggestion: parsed.hintSuggestion || false
        }
      } catch {
        // 解析失败时进行基础文本分析
        const cleanResult = result.trim()
        
        // 检查是否包含正确答案的标志
        if (cleanResult.includes('🎉') || 
            cleanResult.includes('回答正确') || 
            cleanResult.includes('猜对了')) {
          return {response: '🎉 回答正确！\n\n汤底：' + answer, shouldEndGame: true}
        }
        
        // 基础回答判断
        if (cleanResult === '是' || cleanResult === '不是' || cleanResult === '没有关系') {
          return {response: cleanResult}
        }
        
        // 包含基础回答的复杂响应
        if (cleanResult.startsWith('是') || cleanResult.startsWith('不是') || cleanResult.startsWith('没有关系')) {
          return {response: cleanResult.split(/[,.。，]/)[0].trim()}
        }
        
        // 默认回答
        return {response: '不是'}
      }
    } catch (error) {
      console.error('大模型判断失败:', error)
      return {response: '不是'}
    }
  }
}

export const turtleSoupApiService = new TurtleSoupApiService()
