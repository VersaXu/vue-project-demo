<script setup lang="ts">
import { ref, computed, nextTick } from 'vue'
import { useTurtleSoup } from '@/services/turtleSoupService'
import { useTurtleSoupStore } from '@/stores/turtleSoupStore'

const { currentGame, chatHistory, startNewGame, askQuestion, revealAnswer, getHint, resetGame } =
  useTurtleSoup()

const gameState = ref<'start' | 'playing' | 'ended'>('start')
const currentQuestion = ref('')
const isLoading = ref(false)
const chatContainerRef = ref<HTMLDivElement>()

// 计算进度百分比
const progressPercentage = computed(() => {
  const store = useTurtleSoupStore()
  if (!store.currentSession) return 0
  
  // 基础进度基于有用问题数量
  const baseProgress = store.currentSession.usefulQuestions * 15 // 每个有用问题增加15%
  
  // 减去无关问题的影响 (每个无关问题减少5%，但不低于0)
  const penalty = store.currentSession.unrelatedQuestions * 5
  const adjustedProgress = Math.max(0, baseProgress - penalty)
  
  return Math.min(adjustedProgress, 100)
})

// 计算属性：是否显示提示按钮（至少提问3次后）
const showHintButton = computed(() => {
  const userMessages = chatHistory.value.filter((msg) => msg.role === 'user')
  return userMessages.length >= 3 && gameState.value === 'playing'
})

// 自动滚动到聊天底部
const scrollToBottom = async () => {
  await nextTick()
  if (chatContainerRef.value) {
    chatContainerRef.value.scrollTop = chatContainerRef.value.scrollHeight
  }
}

const startGame = async () => {
  isLoading.value = true
  resetGame()
  await startNewGame()
  gameState.value = 'playing'
  isLoading.value = false
  scrollToBottom()
}

const submitQuestion = async () => {
  if (!currentQuestion.value.trim()) return

  isLoading.value = true
  const answer = await askQuestion(currentQuestion.value)
  currentQuestion.value = ''
  isLoading.value = false
  scrollToBottom()

  // 检查是否是正确答案
  if (answer && answer.includes('🎉 回答正确！')) {
    // 自动切换到结束状态，就像用户点击了"查看答案"
    gameState.value = 'ended'
  }
  
  // 检查是否包含直接线索
  if (answer && answer.includes('💡 直接线索')) {
    // 确保滚动到最新消息
    await nextTick()
    scrollToBottom()
  }
}

const requestHint = () => {
  if (showHintButton.value) {
    getHint()
    scrollToBottom()
  }
}

const endGame = () => {
  revealAnswer()
  gameState.value = 'ended'
  scrollToBottom()
}

const restartGame = async () => {
  gameState.value = 'start'
  // 不清除聊天记录，只重置游戏状态
  await startNewGame(true) // true 表示保留聊天记录
  gameState.value = 'playing'
  scrollToBottom()
}

// 格式化消息内容的辅助方法
const formatMessage = (content: string) => {
  return content.replace(/\n/g, '<br>')
}

// 格式化时间戳
const formatTime = (timestamp: number) => {
  return new Date(timestamp).toLocaleTimeString('zh-CN', {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
  })
}
</script>

<template>
  <div class="turtle-soup-game">
    <!-- 开始界面 -->
    <div v-if="gameState === 'start'" class="start-screen">
      <div class="game-header">
        <h1>🐢 海龟汤游戏</h1>
        <p class="subtitle">情境猜谜推理游戏</p>
      </div>

      <div class="game-intro">
        <div class="game-illustration">
          <div class="turtle-icon">🐢</div>
          <div class="soup-icon">🍲</div>
        </div>
        <h3>什么是海龟汤？</h3>
        <p class="intro-text">
          海龟汤是一种情境推理游戏，玩家需要通过提问来解开看似不合理的情境背后的真相。
        </p>
        
        <div class="game-rules">
          <h3>游戏规则</h3>
          <div class="rules-grid">
            <div class="rule-card">
              <div class="rule-icon">❓</div>
              <p>我会给你一个荒谬或难以理解的情境</p>
            </div>
            <div class="rule-card">
              <div class="rule-icon">💭</div>
              <p>你需要通过提问来找出背后的原因</p>
            </div>
            <div class="rule-card">
              <div class="rule-icon">✅</div>
              <p>我只能回答"是"、"不是"或"没有关系"</p>
            </div>
            <div class="rule-card">
              <div class="rule-icon">💡</div>
              <p>提问3次后可以获得提示</p>
            </div>
            <div class="rule-card">
              <div class="rule-icon">🏆</div>
              <p>尽量用最少的提问找出正确答案</p>
            </div>
          </div>
        </div>
      </div>

      <button class="start-button" @click="startGame" :disabled="isLoading">
        {{ isLoading ? '加载中...' : '开始游戏' }}
      </button>
    </div>

    <!-- 游戏进行中界面 -->
    <div v-if="gameState === 'playing'" class="game-screen">
      <div class="game-header">
        <h2>🐢 海龟汤游戏进行中</h2>
        <div class="progress-container">
          <div class="progress-info">
            <span class="question-count">
              🗨️ 提问次数: {{ chatHistory.filter(m => m.role === 'user').length }}
            </span>
            <div class="progress-bar">
              <div 
                class="progress-fill"
                :style="{ width: progressPercentage + '%' }"
              ></div>
            </div>
            <span class="progress-text">
              进度: {{ progressPercentage }}%
            </span>
          </div>
          <div class="game-controls">
            <button v-if="showHintButton" class="hint-button" @click="requestHint" title="获取提示">
              💡 提示
            </button>
            <button class="end-button" @click="endGame" title="查看答案">🔍 查看答案</button>
          </div>
        </div>
      </div>

      <div ref="chatContainerRef" class="chat-container">
        <div
          v-for="(message, index) in chatHistory"
          :key="message.messageId || index"
          :class="['message', message.role, { loading: message.isLoading }]"
        >
          <div class="message-avatar">
            {{ message.role === 'user' ? '👤' : '🤖' }}
          </div>
          <div class="message-content">
            <div v-if="message.isLoading" class="loading-message">
              <div class="loading-dots">
                <span></span>
                <span></span>
                <span></span>
              </div>
              <div class="loading-text">{{ message.content }}</div>
            </div>
            <template v-else>
              <div class="message-text" v-html="formatMessage(message.content)"></div>
              <div class="message-time">{{ formatTime(message.timestamp) }}</div>
            </template>
          </div>
        </div>
      </div>

      <div class="input-area">
        <input
          v-model="currentQuestion"
          placeholder="输入你的问题（按Enter发送）..."
          @keyup.enter="submitQuestion"
          :disabled="isLoading"
        />
        <button @click="submitQuestion" :disabled="isLoading || !currentQuestion.trim()">
          {{ isLoading ? '发送中...' : '发送' }}
        </button>
      </div>
    </div>

    <!-- 游戏结束界面 -->
    <div v-if="gameState === 'ended'" class="end-screen">
      <div class="game-header">
        <h2>🎉 游戏结束</h2>
      </div>

      <div ref="chatContainerRef" class="chat-container">
        <div
          v-for="(message, index) in chatHistory"
          :key="index"
          :class="['message', message.role]"
        >
          <div class="message-avatar">
            {{ message.role === 'user' ? '👤' : '🤖' }}
          </div>
          <div class="message-content">
            <div class="message-text" v-html="formatMessage(message.content)"></div>
            <div class="message-time">{{ formatTime(message.timestamp) }}</div>
          </div>
        </div>
      </div>

      <div class="end-controls">
        <button class="restart-button" @click="restartGame">再玩一次</button>
      </div>
    </div>

    <!-- 加载遮罩 -->
    <div v-if="isLoading" class="loading-overlay">
      <div class="loading-content">
        <div class="loading-spinner"></div>
        <p>AI思考中...</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.turtle-soup-game {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.start-screen {
  text-align: center;
  padding: 40px 20px;
  background: var(--color-background-soft);
  border-radius: 15px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin: 20px auto;
  max-width: 800px;
}

.game-header h1 {
  color: var(--color-heading);
  margin-bottom: 5px;
  font-size: 2.5rem;
}

.subtitle {
  color: var(--color-text);
  opacity: 0.8;
  font-size: 1.1rem;
  margin-bottom: 30px;
}
.game-rules {
  background: var(--color-background-soft);
  border-radius: 10px;
  padding: 25px;
  margin: 30px 0;
  text-align: left;
  border: 1px solid var(--color-border);
}

.game-rules h3 {
  color: var(--color-heading);
  margin-bottom: 15px;
}

.game-rules li {
  padding: 8px 0;
  color: var(--color-text);
  position: relative;
  padding-left: 25px;
}

.game-rules li::before {
  content: '✓';
  color: #27ae60;
  font-weight: bold;
  position: absolute;
  left: 0;
}

.start-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 16px 50px;
  font-size: 1.2rem;
  border-radius: 30px;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  position: relative;
  overflow: hidden;
}

.start-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.2),
    transparent
  );
  transition: 0.5s;
}

.start-button:hover::before {
  left: 100%;
}

.start-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
}

.start-button:hover {
  transform: translateY(-2px);
}

.start-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.game-screen .game-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.game-controls {
  display: flex;
  gap: 10px;
}

.progress-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  width: 100%;
  margin-bottom: 15px;
}

.progress-info {
  display: flex;
  align-items: center;
  gap: 15px;
  width: 100%;
}

.question-count {
  font-size: 0.9rem;
  color: var(--color-text);
  white-space: nowrap;
}

.progress-bar {
  flex-grow: 1;
  height: 10px;
  background: var(--color-background-soft);
  border-radius: 5px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #667eea, #8e44ad);
  border-radius: 5px;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 0.9rem;
  color: var(--color-text);
  white-space: nowrap;
}

.hint-button,
.end-button {
  padding: 8px 16px;
  border: 1px solid var(--color-border);
  border-radius: 20px;
  background: var(--color-background);
  color: var(--color-text);
  cursor: pointer;
  transition: all 0.2s;
}

.progress-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  width: 100%;
  margin-bottom: 15px;
}

.progress-info {
  display: flex;
  align-items: center;
  gap: 15px;
  width: 100%;
}

.question-count {
  font-size: 0.9rem;
  color: var(--color-text);
  white-space: nowrap;
}

.progress-bar {
  flex-grow: 1;
  height: 10px;
  background: var(--color-background-soft);
  border-radius: 5px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #667eea, #8e44ad);
  border-radius: 5px;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 0.9rem;
  color: var(--color-text);
  white-space: nowrap;
}

.hint-button:hover {
  background: var(--color-background-soft);
  border-color: var(--color-border-hover);
}

.end-button:hover {
  background: var(--color-background-soft);
  border-color: var(--color-border-hover);
}

.chat-container {
  height: 500px;
  overflow-y: auto;
  border: 1px solid var(--color-border);
  border-radius: 15px;
  padding: 20px;
  margin-bottom: 20px;
  background: var(--color-background-soft);
}

.message {
  display: flex;
  margin-bottom: 20px;
  animation: fadeIn 0.3s ease-in;
}

.message.user {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  margin: 0 10px;
  flex-shrink: 0;
}

.user .message-avatar {
  background: #667eea;
  color: white;
}

.assistant .message-avatar {
  background: var(--color-border);
  color: var(--color-text);
}

.message-content {
  max-width: 70%;
  background: var(--color-background);
  padding: 12px 16px;
  border-radius: 18px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}

.user .message-content {
  background: #667eea;
  color: white;
}

.assistant .message-content {
  background: var(--color-background-soft);
  color: var(--color-text);
}

.message.loading .message-content {
  background: rgba(102, 126, 234, 0.1);
  border: 1px dashed #667eea;
}

.loading-message {
  display: flex;
  align-items: center;
  gap: 10px;
}

.loading-dots {
  display: flex;
  gap: 4px;
}

.loading-dots span {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background-color: #667eea;
  animation: loadingDots 1.4s infinite ease-in-out both;
}

.loading-dots span:nth-child(1) {
  animation-delay: -0.32s;
}

.loading-dots span:nth-child(2) {
  animation-delay: -0.16s;
}

.loading-dots span:nth-child(3) {
  animation-delay: 0s;
}

@keyframes loadingDots {
  0%, 80%, 100% {
    transform: scale(0.8);
    opacity: 0.5;
  }
  40% {
    transform: scale(1.2);
    opacity: 1;
  }
}

.loading-text {
  color: #667eea;
  font-style: italic;
}

.message-text {
  line-height: 1.5;
  white-space: pre-wrap;
  color: inherit;
}

.message-time {
  font-size: 0.8rem;
  opacity: 0.7;
  margin-top: 5px;
}

.input-area {
  display: flex;
  gap: 10px;
}

.input-area input {
  flex-grow: 1;
  padding: 12px 16px;
  border: 2px solid var(--color-border);
  border-radius: 25px;
  font-size: 1rem;
  transition: border-color 0.2s;
  background: var(--color-background);
  color: var(--color-text);
}

.input-area input:focus {
  outline: none;
  border-color: #667eea;
}

.input-area button {
  padding: 12px 24px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  transition: background 0.2s;
}

.input-area button:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

.input-area button:hover:not(:disabled) {
  background: #5a6fd8;
}

.end-screen .end-controls {
  text-align: center;
  margin-top: 20px;
}

.restart-button {
  background: #27ae60;
  color: white;
  border: none;
  padding: 12px 30px;
  font-size: 1rem;
  border-radius: 25px;
  cursor: pointer;
  transition: background 0.2s;
}

.restart-button:hover {
  background: #219a52;
}

.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.loading-content {
  text-align: center;
}

.loading-spinner {
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid #667eea;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
  margin: 0 auto 15px;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .turtle-soup-game {
    padding: 10px;
  }

  .game-screen .game-header {
    flex-direction: column;
    gap: 15px;
  }

  .message-content {
    max-width: 85%;
  }
}
</style>
