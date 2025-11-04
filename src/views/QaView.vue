
<template>
  <div class="qa-container">
    <h1>常见问题解答</h1>
    <div class="qa-list">
      <div v-for="(item, index) in qaItems" :key="index" class="qa-item">
        <h3 class="question">{{ item.question }}</h3>
        <p class="answer">{{ item.answer }}</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'QaView',
  setup() {
    const qaItems = ref([
      {
        question: '如何登录系统？',
        answer: '使用管理员账号admin/admin123进行登录'
      },
      {
        question: '系统支持哪些浏览器？',
        answer: '支持Chrome、Firefox、Edge等现代浏览器'
      },
      {
        question: '如何联系技术支持？',
        answer: '请发送邮件至support@example.com'
      }
    ])

    return {
      qaItems
    }
  }
})
</script>

<style scoped>
.qa-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
}

h1 {
  color: var(--color-heading);
  margin-bottom: 2rem;
}

.qa-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.qa-item {
  background: var(--color-background-soft);
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.question {
  color: var(--color-heading);
  margin-bottom: 0.5rem;
}

.answer {
  color: var(--color-text);
  line-height: 1.6;
}
</style>
