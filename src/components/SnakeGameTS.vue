<template>
  <div class="snake-game">
    <canvas ref="gameCanvas" width="400" height="400"></canvas>
    <div class="score">Score: {{ score }}</div>
    <div class="controls">
      <button @click="startGame" :disabled="gameRunning">Start Game</button>
      <button @click="togglePause" :disabled="!gameRunning">
        {{ isPaused ? 'Resume' : 'Pause' }}
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onBeforeUnmount } from 'vue'

interface Position {
  x: number
  y: number
}

interface Difficulty {
  speed: number
  name: string
}

interface Difficulties {
  [key: string]: Difficulty
}

export default defineComponent({
  name: 'SnakeGameTS',
  setup() {
    const gameCanvas = ref<HTMLCanvasElement | null>(null)
    const score = ref(0)
    const snake = ref<Position[]>([])
    const food = ref<Position>({ x: 0, y: 0 })
    const direction = ref('right')
    const gameInterval = ref<number | null>(null)
    const gameRunning = ref(false)
    const isPaused = ref(false)
    const gridSize = ref(20)
    const canvasSize = ref(400)
    const highScore = ref(0)
    const difficulties = ref<Difficulties>({
      easy: { speed: 150, name: 'Easy' },
      medium: { speed: 100, name: 'Medium' },
      hard: { speed: 50, name: 'Hard' },
    })
    const difficulty = ref('medium')

    let audioContext: AudioContext | null = null
    let eatSound: OscillatorNode | null = null
    let eatSoundGain: GainNode | null = null
    let gameOverSound: OscillatorNode | null = null
    let gameOverSoundGain: GainNode | null = null

    const initAudio = () => {
      try {
        audioContext = new (window.AudioContext || (window as any).webkitAudioContext)()
        eatSound = audioContext.createOscillator()
        eatSound.type = 'sine'
        eatSound.frequency.value = 880
        eatSoundGain = audioContext.createGain()
        eatSound.connect(eatSoundGain)
        eatSoundGain.connect(audioContext.destination)
        eatSoundGain.gain.value = 0.1

        gameOverSound = audioContext.createOscillator()
        gameOverSound.type = 'sine'
        gameOverSound.frequency.value = 220
        gameOverSoundGain = audioContext.createGain()
        gameOverSound.connect(gameOverSoundGain)
        gameOverSoundGain.connect(audioContext.destination)
        gameOverSoundGain.gain.value = 0.1
      } catch (e) {
        console.warn('Web Audio API not supported', e)
      }
    }

    const resetGame = () => {
      snake.value = [{ x: 10, y: 10 }]
      food.value = generateFood()
      direction.value = 'right'
      score.value = 0
    }

    const generateFood = (): Position => {
      return {
        x: Math.floor(Math.random() * (canvasSize.value / gridSize.value)),
        y: Math.floor(Math.random() * (canvasSize.value / gridSize.value)),
      }
    }

    const checkCollision = (head: Position): boolean => {
      return (
        head.x < 0 ||
        head.x >= canvasSize.value / gridSize.value ||
        head.y < 0 ||
        head.y >= canvasSize.value / gridSize.value ||
        snake.value.some((segment) => segment.x === head.x && segment.y === head.y)
      )
    }

    const drawRoundedRect = (
      ctx: CanvasRenderingContext2D,
      x: number,
      y: number,
      width: number,
      height: number,
      radius: number,
    ) => {
      ctx.beginPath()
      ctx.moveTo(x + radius, y)
      ctx.arcTo(x + width, y, x + width, y + height, radius)
      ctx.arcTo(x + width, y + height, x, y + height, radius)
      ctx.arcTo(x, y + height, x, y, radius)
      ctx.arcTo(x, y, x + width, y, radius)
      ctx.closePath()
      ctx.fill()
    }

    const drawGame = () => {
      const canvas = gameCanvas.value
      if (!canvas) return

      const ctx = canvas.getContext('2d')
      if (!ctx) return

      ctx.clearRect(0, 0, canvas.width, canvas.height)

      // Draw grid
      ctx.strokeStyle = '#ddd'
      for (let i = 0; i <= canvasSize.value; i += gridSize.value) {
        ctx.beginPath()
        ctx.moveTo(i, 0)
        ctx.lineTo(i, canvasSize.value)
        ctx.stroke()
        ctx.beginPath()
        ctx.moveTo(0, i)
        ctx.lineTo(canvasSize.value, i)
        ctx.stroke()
      }

      // Draw snake
      snake.value.forEach((segment, index) => {
        ctx.fillStyle = index === 0 ? '#4CAF50' : '#8BC34A'
        drawRoundedRect(
          ctx,
          segment.x * gridSize.value,
          segment.y * gridSize.value,
          gridSize.value,
          gridSize.value,
          5,
        )
      })

      // Draw eyes for the snake head
      const head = snake.value[0]
      ctx.fillStyle = 'white'
      ctx.beginPath()
      ctx.arc(head.x * gridSize.value + 5, head.y * gridSize.value + 5, 3, 0, Math.PI * 2)
      ctx.arc(head.x * gridSize.value + 15, head.y * gridSize.value + 5, 3, 0, Math.PI * 2)
      ctx.fill()

      // Draw food (apple)
      ctx.fillStyle = '#FF5252'
      drawRoundedRect(
        ctx,
        food.value.x * gridSize.value,
        food.value.y * gridSize.value,
        gridSize.value,
        gridSize.value,
        5,
      )
      // Draw apple stem
      ctx.fillStyle = '#795548'
      ctx.fillRect(food.value.x * gridSize.value + 8, food.value.y * gridSize.value - 3, 4, 6)
    }

    const gameLoop = () => {
      const head = { ...snake.value[0] }
      switch (direction.value) {
        case 'up':
          head.y--
          break
        case 'down':
          head.y++
          break
        case 'left':
          head.x--
          break
        case 'right':
          head.x++
          break
      }

      if (checkCollision(head)) {
        endGame()
        return
      }

      snake.value.unshift(head)

      if (head.x === food.value.x && head.y === food.value.y) {
        score.value++
        playEatSound()
        food.value = generateFood()
      } else {
        snake.value.pop()
      }

      drawGame()
    }

    const playEatSound = () => {
      if (!eatSound || !eatSoundGain) return
      eatSound.start()
      eatSound.stop(audioContext?.currentTime ?? 0 + 0.1)
    }

    const playGameOverSound = () => {
      if (!gameOverSound || !gameOverSoundGain) return
      gameOverSound.start()
      gameOverSound.stop(audioContext?.currentTime ?? 0 + 0.5)
    }

    const endGame = () => {
      if (gameInterval.value) {
        clearInterval(gameInterval.value)
        gameInterval.value = null
      }
      gameRunning.value = false
      playGameOverSound()

      if (score.value > highScore.value) {
        highScore.value = score.value
      }

      alert(`Game Over!\nYour score: ${score.value}\nHigh score: ${highScore.value}`)
    }

    const startGame = () => {
      initAudio()
      resetGame()
      gameRunning.value = true
      gameInterval.value = setInterval(gameLoop, difficulties.value[difficulty.value].speed)
    }

    const togglePause = () => {
      if (isPaused.value) {
        gameInterval.value = setInterval(gameLoop, 100)
        isPaused.value = false
      } else {
        if (gameInterval.value) {
          clearInterval(gameInterval.value)
          gameInterval.value = null
        }
        isPaused.value = true
      }
    }

    const handleKeyDown = (e: KeyboardEvent) => {
      e.preventDefault()
      switch (e.key) {
        case 'ArrowUp':
          if (direction.value !== 'down') direction.value = 'up'
          break
        case 'ArrowDown':
          if (direction.value !== 'up') direction.value = 'down'
          break
        case 'ArrowLeft':
          if (direction.value !== 'right') direction.value = 'left'
          break
        case 'ArrowRight':
          if (direction.value !== 'left') direction.value = 'right'
          break
        case ' ':
          togglePause()
          break
      }
    }

    let touchStartX = 0
    let touchStartY = 0

    const handleTouchStart = (e: TouchEvent) => {
      touchStartX = e.touches[0].clientX
      touchStartY = e.touches[0].clientY
    }

    const handleTouchMove = (e: TouchEvent) => {
      e.preventDefault()
      const touchEndX = e.touches[0].clientX
      const touchEndY = e.touches[0].clientY

      const dx = touchEndX - touchStartX
      const dy = touchEndY - touchStartY

      if (Math.abs(dx) > Math.abs(dy)) {
        // Horizontal swipe
        if (dx > 0 && direction.value !== 'left') {
          direction.value = 'right'
        } else if (dx < 0 && direction.value !== 'right') {
          direction.value = 'left'
        }
      } else {
        // Vertical swipe
        if (dy > 0 && direction.value !== 'up') {
          direction.value = 'down'
        } else if (dy < 0 && direction.value !== 'down') {
          direction.value = 'up'
        }
      }

      touchStartX = touchEndX
      touchStartY = touchEndY
    }

    const setupTouchControls = () => {
      const canvas = gameCanvas.value
      if (!canvas) return

      canvas.addEventListener('touchstart', handleTouchStart)
      canvas.addEventListener('touchmove', handleTouchMove, { passive: false })
    }

    onMounted(() => {
      window.addEventListener('keydown', handleKeyDown)
      setupTouchControls()
    })

    onBeforeUnmount(() => {
      window.removeEventListener('keydown', handleKeyDown)
      const canvas = gameCanvas.value
      if (canvas) {
        canvas.removeEventListener('touchstart', handleTouchStart)
        canvas.removeEventListener('touchmove', handleTouchMove)
      }
      if (gameInterval.value) {
        clearInterval(gameInterval.value)
      }
    })

    return {
      gameCanvas,
      score,
      gameRunning,
      isPaused,
      startGame,
      togglePause,
    }
  },
})
</script>

<style scoped>
.snake-game {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  touch-action: none;
}
canvas {
  border: 2px solid #333;
  border-radius: 5px;
  margin-bottom: 15px;
}
.score {
  font-size: 24px;
  font-weight: bold;
  color: #333;
  margin-bottom: 15px;
}
button {
  padding: 10px 20px;
  font-size: 18px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}
button:hover {
  background-color: #45a049;
}
button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.game-info {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 10px;
}

.controls {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 10px;
  width: 100%;
}

.difficulty-selector {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 5px;
}

.difficulty-selector select {
  padding: 5px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.controls button {
  flex: 1;
  padding: 10px;
}
</style>
