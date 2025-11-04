<template>
  <div class="snake-game-view">
    <h1>Snake Game</h1>
    <p>Use arrow keys to control the snake. Eat the red food to grow and score points!</p>
    <SnakeGameTS />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import SnakeGameTS from '@/components/SnakeGameTS.vue'

export default defineComponent({
  name: 'SnakeGameView',
  components: {
    SnakeGameTS,
  },
})
</script>

<style scoped>
.snake-game-view {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
}
h1 {
  margin-bottom: 10px;
}
p {
  margin-bottom: 20px;
  color: #666;
}
</style>
