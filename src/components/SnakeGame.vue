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

<script>
export default {
  name: 'SnakeGame',
  data() {
    return {
      score: 0,
      snake: [],
      food: {},
      direction: 'right',
      gameInterval: null,
      gameRunning: false,
      isPaused: false,
      gridSize: 20,
      canvasSize: 400,
      audioContext: null,
      eatSound: null,
      gameOverSound: null,
      difficulty: 'medium',
      highScore: 0,
      difficulties: {
        easy: { speed: 150, name: 'Easy' },
        medium: { speed: 100, name: 'Medium' },
        hard: { speed: 50, name: 'Hard' },
      },
    }
  },
  methods: {
    startGame() {
      this.initAudio()
      this.resetGame()
      this.gameRunning = true
      this.gameInterval = setInterval(this.gameLoop, this.difficulties[this.difficulty].speed)
    },
    resetGame() {
      this.snake = [{ x: 10, y: 10 }]
      this.food = this.generateFood()
      this.direction = 'right'
      this.score = 0
    },
    generateFood() {
      return {
        x: Math.floor(Math.random() * (this.canvasSize / this.gridSize)),
        y: Math.floor(Math.random() * (this.canvasSize / this.gridSize)),
      }
    },
    gameLoop() {
      const head = { ...this.snake[0] }
      switch (this.direction) {
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

      if (this.checkCollision(head)) {
        this.endGame()
        return
      }

      this.snake.unshift(head)

      if (head.x === this.food.x && head.y === this.food.y) {
        this.score++
        this.playEatSound()
        this.food = this.generateFood()
      } else {
        this.snake.pop()
      }

      this.drawGame()
    },
    checkCollision(head) {
      return (
        head.x < 0 ||
        head.x >= this.canvasSize / this.gridSize ||
        head.y < 0 ||
        head.y >= this.canvasSize / this.gridSize ||
        this.snake.some((segment) => segment.x === head.x && segment.y === head.y)
      )
    },
    drawGame() {
      const canvas = this.$refs.gameCanvas
      const ctx = canvas.getContext('2d')
      ctx.clearRect(0, 0, canvas.width, canvas.height)

      // Draw grid
      ctx.strokeStyle = '#ddd'
      for (let i = 0; i <= this.canvasSize; i += this.gridSize) {
        ctx.beginPath()
        ctx.moveTo(i, 0)
        ctx.lineTo(i, this.canvasSize)
        ctx.stroke()
        ctx.beginPath()
        ctx.moveTo(0, i)
        ctx.lineTo(this.canvasSize, i)
        ctx.stroke()
      }

      // Draw snake
      this.snake.forEach((segment, index) => {
        ctx.fillStyle = index === 0 ? '#4CAF50' : '#8BC34A'
        this.drawRoundedRect(
          ctx,
          segment.x * this.gridSize,
          segment.y * this.gridSize,
          this.gridSize,
          this.gridSize,
          5,
        )
      })

      // Draw eyes for the snake head
      const head = this.snake[0]
      ctx.fillStyle = 'white'
      ctx.beginPath()
      ctx.arc(head.x * this.gridSize + 5, head.y * this.gridSize + 5, 3, 0, Math.PI * 2)
      ctx.arc(head.x * this.gridSize + 15, head.y * this.gridSize + 5, 3, 0, Math.PI * 2)
      ctx.fill()

      // Draw food (apple)
      ctx.fillStyle = '#FF5252'
      this.drawRoundedRect(
        ctx,
        this.food.x * this.gridSize,
        this.food.y * this.gridSize,
        this.gridSize,
        this.gridSize,
        5,
      )
      // Draw apple stem
      ctx.fillStyle = '#795548'
      ctx.fillRect(this.food.x * this.gridSize + 8, this.food.y * this.gridSize - 3, 4, 6)
    },
    drawRoundedRect(ctx, x, y, width, height, radius) {
      ctx.beginPath()
      ctx.moveTo(x + radius, y)
      ctx.arcTo(x + width, y, x + width, y + height, radius)
      ctx.arcTo(x + width, y + height, x, y + height, radius)
      ctx.arcTo(x, y + height, x, y, radius)
      ctx.arcTo(x, y, x + width, y, radius)
      ctx.closePath()
      ctx.fill()
    },
    initAudio() {
      try {
        this.audioContext = new (window.AudioContext || window.webkitAudioContext)()
        this.eatSound = this.audioContext.createOscillator()
        this.eatSound.type = 'sine'
        this.eatSound.frequency.value = 880
        this.eatSoundGain = this.audioContext.createGain()
        this.eatSound.connect(this.eatSoundGain)
        this.eatSoundGain.connect(this.audioContext.destination)
        this.eatSoundGain.gain.value = 0.1

        this.gameOverSound = this.audioContext.createOscillator()
        this.gameOverSound.type = 'sine'
        this.gameOverSound.frequency.value = 220
        this.gameOverSoundGain = this.audioContext.createGain()
        this.gameOverSound.connect(this.gameOverSoundGain)
        this.gameOverSoundGain.connect(this.audioContext.destination)
        this.gameOverSoundGain.gain.value = 0.1
      } catch (e) {
        console.warn('Web Audio API not supported', e)
      }
    },

    playEatSound() {
      if (!this.eatSound) return
      this.eatSound.start()
      this.eatSound.stop(this.audioContext.currentTime + 0.1)
    },

    playGameOverSound() {
      if (!this.gameOverSound) return
      this.gameOverSound.start()
      this.gameOverSound.stop(this.audioContext.currentTime + 0.5)
    },

    endGame() {
      clearInterval(this.gameInterval)
      this.gameRunning = false
      this.playGameOverSound()

      if (this.score > this.highScore) {
        this.highScore = this.score
      }

      alert(`Game Over!\nYour score: ${this.score}\nHigh score: ${this.highScore}`)
    },
    togglePause() {
      if (this.isPaused) {
        this.gameInterval = setInterval(this.gameLoop, 100)
        this.isPaused = false
      } else {
        clearInterval(this.gameInterval)
        this.isPaused = true
      }
    },

    handleKeyDown(e) {
      e.preventDefault() // Prevent default scrolling behavior
      switch (e.key) {
        case 'ArrowUp':
          if (this.direction !== 'down') this.direction = 'up'
          break
        case 'ArrowDown':
          if (this.direction !== 'up') this.direction = 'down'
          break
        case 'ArrowLeft':
          if (this.direction !== 'right') this.direction = 'left'
          break
        case 'ArrowRight':
          if (this.direction !== 'left') this.direction = 'right'
          break
        case ' ':
          this.togglePause()
          break
      }
    },

    setupTouchControls() {
      const canvas = this.$refs.gameCanvas
      if (!canvas) return

      let touchStartX = 0
      let touchStartY = 0

      this.handleTouchStart = (e) => {
        touchStartX = e.touches[0].clientX
        touchStartY = e.touches[0].clientY
      }

      this.handleTouchMove = (e) => {
        e.preventDefault()
        const touchEndX = e.touches[0].clientX
        const touchEndY = e.touches[0].clientY

        const dx = touchEndX - touchStartX
        const dy = touchEndY - touchStartY

        if (Math.abs(dx) > Math.abs(dy)) {
          // Horizontal swipe
          if (dx > 0 && this.direction !== 'left') {
            this.direction = 'right'
          } else if (dx < 0 && this.direction !== 'right') {
            this.direction = 'left'
          }
        } else {
          // Vertical swipe
          if (dy > 0 && this.direction !== 'up') {
            this.direction = 'down'
          } else if (dy < 0 && this.direction !== 'down') {
            this.direction = 'up'
          }
        }

        touchStartX = touchEndX
        touchStartY = touchEndY
      }

      canvas.addEventListener('touchstart', this.handleTouchStart)
      canvas.addEventListener('touchmove', this.handleTouchMove, { passive: false })
    },
  },
  mounted() {
    window.addEventListener('keydown', this.handleKeyDown)
    this.setupTouchControls()
  },
  beforeUnmount() {
    window.removeEventListener('keydown', this.handleKeyDown)
    const canvas = this.$refs.gameCanvas
    if (canvas) {
      canvas.removeEventListener('touchstart', this.handleTouchStart)
      canvas.removeEventListener('touchmove', this.handleTouchMove)
    }
  },
}
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
