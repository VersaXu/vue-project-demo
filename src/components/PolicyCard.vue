<template>
  <div class="policy-container">
    <header>
      <h1>神太保单</h1>
      <div class="time">{{ currentTime }}</div>
    </header>
    <div class="search-bar">
      <input type="text" placeholder="搜索保单" />
      <button class="filter">筛选</button>
    </div>
    <nav>
      <ul>
        <li><span class="icon">📋</span> 核保单</li>
        <li><span class="icon">🔄</span> 转核保单</li>
        <li><span class="icon">✅</span> 签收回访</li>
        <li><span class="icon">⏳</span> 短险续保</li>
        <li><span class="icon">📜</span> 长险续保</li>
      </ul>
    </nav>
    <main>
      <div class="policy-info">
        <p>原保单号: P1234567890</p>
        <p>保险产品: 太保长相伴(尊享版)终身寿险等</p>
        <p>投保人: 张三</p>
        <p>被保险人: 李四</p>
        <p>续保服务止期: 2025-12-31</p>
      </div>
      <div class="buttons">
        <button class="contact">联系投保人</button>
        <button class="renew">续保</button>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const currentTime = ref('')

onMounted(() => {
  updateTime()
  setInterval(updateTime, 60000)
})

function updateTime() {
  const now = new Date()
  currentTime.value = `${now.getHours()}:${now.getMinutes().toString().padStart(2, '0')}`
}
</script>

<style scoped>
.policy-container {
  background-color: #fff;
  width: 100%;
  max-width: 1200px;
  margin: 2rem auto;
  padding: 2rem;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border-radius: 12px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell,
    sans-serif;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: #fff;
  border-bottom: 1px solid #ddd;
}

header h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #2c3e50;
}

.time {
  font-size: 1rem;
  color: #7f8c8d;
}

.search-bar {
  display: flex;
  padding: 8px 16px;
  background-color: #f5f5f5;
}

.search-bar input {
  flex-grow: 1;
  padding: 0.75rem;
  border: 1px solid #e0e0e0;
  border-radius: 6px 0 0 6px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.search-bar input:focus {
  outline: none;
  border-color: #3498db;
}

.filter {
  padding: 0.75rem 1.5rem;
  border: none;
  background-color: #3498db;
  color: #fff;
  border-radius: 0 6px 6px 0;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 500;
  transition: background-color 0.3s;
}

.filter:hover {
  background-color: #2980b9;
}

nav ul {
  display: flex;
  justify-content: space-around;
  list-style: none;
  padding: 16px;
  background-color: #fff;
  border-bottom: 1px solid #ddd;
}

nav ul li {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 1rem;
  padding: 0.5rem 1rem;
  cursor: pointer;
  transition: color 0.3s;
}

nav ul li:hover {
  color: #3498db;
}

.icon {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

main {
  padding: 16px;
}

.policy-info {
  margin: 1.5rem 0;
}

.policy-info p {
  margin-bottom: 1rem;
  font-size: 1.1rem;
  line-height: 1.6;
  color: #34495e;
}

.policy-info p:first-child {
  font-weight: 600;
  color: #2c3e50;
}

.buttons {
  display: flex;
  gap: 16px;
  margin-top: 16px;
}

.contact,
.renew {
  flex-grow: 1;
  padding: 0.75rem;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
}

.contact {
  background-color: #fff;
  border: 1px solid #3498db;
  color: #3498db;
}

.contact:hover {
  background-color: #f8f9fa;
}

.renew {
  background-color: #3498db;
  color: #fff;
}

.renew:hover {
  background-color: #2980b9;
}

@media (max-width: 768px) {
  .policy-container {
    margin: 1rem;
    padding: 1rem;
    border-radius: 8px;
  }

  .buttons {
    flex-direction: column;
  }

  nav ul {
    flex-wrap: wrap;
    justify-content: center;
  }

  nav ul li {
    padding: 0.5rem;
    font-size: 0.9rem;
  }

  .icon {
    font-size: 1.2rem;
  }
}
</style>
