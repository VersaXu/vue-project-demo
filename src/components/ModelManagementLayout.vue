<template>
  <div class="model-management-container">
    <!-- 左侧导航栏 -->
    <div class="sidebar">
      <nav>
        <ul>
          <li v-for="item in navItems" :key="item.name" 
              :class="{ active: activeNav === item.name }"
              @click="activeNav = item.name">
            {{ item.label }}
          </li>
        </ul>
      </nav>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 顶部导航栏 -->
      <header class="top-nav">
        <div class="search-container">
          <input type="text" placeholder="输入模型或部门名称搜索">
          <button class="download-btn">下载安装</button>
        </div>
      </header>

      <!-- 模型管理内容 -->
      <ModelList />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import ModelList from './ModelList.vue';

export default defineComponent({
  name: 'ModelManagementLayout',
  components: {
    ModelList
  },
  setup() {
    const activeNav = ref('custom-model');
    const navItems = [
      { name: 'home', label: '主页' },
      { name: 'license', label: 'License' },
      { name: 'user-management', label: '用户管理' },
      { name: 'organization', label: '组织架构' },
      { name: 'knowledge', label: '知识管理' },
      { name: 'data', label: '数据管理' },
      { name: 'open-center', label: '开放中心' },
      { name: 'custom-model', label: '自定义模型' },
      { name: 'custom-command', label: '自定义指令' },
      { name: 'settings', label: '配置中心' }
    ];

    return {
      activeNav,
      navItems
    };
  }
});
</script>

<style scoped>
.model-management-container {
  display: flex;
  height: 100vh;
}

.sidebar {
  width: 200px;
  background-color: #f5f5f5;
  padding: 20px 0;
}

.sidebar nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar nav ul li {
  padding: 10px 20px;
  cursor: pointer;
  color: #333;
}

.sidebar nav ul li.active {
  background-color: white;
  color: #1890ff;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.top-nav {
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: flex-end;
}

.search-container {
  display: flex;
  align-items: center;
}

.search-container input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  margin-right: 10px;
}

.download-btn {
  background-color: #1890ff;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}
</style>