<script setup lang="ts">
import { ref, computed, nextTick } from 'vue'
import { useTurtleSoup } from '@/services/turtleSoupService'

const { currentGame, chatHistory, startNewGame, askQuestion, revealAnswer, getHint, resetGame } =
  useTurtleSoup()

const gameState = ref<'start' | 'playing' | 'ended'>('start')
const currentQuestion = ref('')
const isLoading = ref(false)
const chatContainerRef = ref<HTMLDivElement>()

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

      <div class="game-rules">
        <h3>游戏规则</h3>
        <ul>
          <li>我会给你一个荒谬或难以理解的情境</li>
          <li>你需要通过提问来找出背后的原因</li>
          <li>我只能回答"是"、"不是"或"没有关系"</li>
          <li>提问3次后可以获得提示</li>
          <li>尽量用最少的提问找出正确答案</li>
        </ul>
      </div>

      <button class="start-button" @click="startGame" :disabled="isLoading">
        {{ isLoading ? '加载中...' : '开始游戏' }}
      </button>
    </div>

    <!-- 游戏进行中界面 -->
    <div v-if="gameState === 'playing'" class="game-screen">
      <div class="game-header">
        <h2>🐢 海龟汤游戏进行中</h2>
        <div class="game-controls">
          <button v-if="showHintButton" class="hint-button" @click="requestHint" title="获取提示">
            💡 提示
          </button>
          <button class="end-button" @click="endGame" title="查看答案">🔍 查看答案</button>
        </div>
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
  padding: 12px 40px;
  font-size: 1.1rem;
  border-radius: 25px;
  cursor: pointer;
  transition: transform 0.2s;
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
