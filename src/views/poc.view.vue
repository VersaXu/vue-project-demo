<template>
  <div class="workbench">
    <!-- 顶部导航栏 -->
    <nav class="top-nav">
      <div class="nav-left">
        <span class="logo">首页 / 仪表盘 / 工作台</span>
      </div>
      <div class="nav-right">
        <span class="username">Serati Ma</span>
        <div class="avatar"></div>
      </div>
    </nav>

    <!-- 欢迎信息 -->
    <div class="welcome-info">
      <h2>下午好，天野远子，我猜你可能累了</h2>
      <p>前端工程师 | 蚂蚁金服 - 某某某事业群 - VUE平台</p>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <!-- 左侧项目列表 -->
      <div class="project-list">
        <div class="project-card" v-for="project in projects" :key="project.id">
          <h3>{{ project.name }}</h3>
          <p>{{ project.description }}</p>
          <span class="time">{{ project.time }}</span>
        </div>
      </div>

      <!-- 中间动态更新区域 -->
      <div class="dynamic-updates">
        <div class="update-item" v-for="update in updates" :key="update.id">
          <span class="user">@{{ update.user }}</span>
          <p>{{ update.content }}</p>
          <span class="time">{{ update.time }}</span>
        </div>
      </div>

      <!-- 右侧快捷导航和图表 -->
      <div class="quick-nav-chart">
        <div class="quick-nav">
          <button
            v-for="(action, index) in quickActions"
            :key="index"
            :class="{ active: index === activeAction }"
          >
            操作{{ index + 1 }}
          </button>
        </div>

        <div class="chart">
          <h3>XX指数</h3>
          <!-- 图表占位 -->
          <div class="radar-chart"></div>
        </div>

        <div class="team-info">
          <div v-for="team in teams" :key="team.id" class="team-item">
            <span class="team-icon"></span>
            <span>{{ team.name }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'

interface Project {
  id: number
  name: string
  description: string
  time: string
}

interface Update {
  id: number
  user: string
  content: string
  time: string
}

interface Team {
  id: number
  name: string
}

export default defineComponent({
  name: 'PocView',
  setup() {
    const projects = ref<Project[]>([
      {
        id: 1,
        name: 'Alipay',
        description: '那是一种内在的东西，他们到达不了，也无法触及的',
        time: '9小时前',
      },
      {
        id: 2,
        name: 'Angular',
        description: '希望是一个好东西，也许是最好的，好东西是不会消亡的',
        time: '1小时前',
      },
      {
        id: 3,
        name: 'Ant Design',
        description: '生命就像一盒巧克力，结果往往出人意料',
        time: '3天前',
      },
      {
        id: 4,
        name: 'Ant Design Pro',
        description: '城镇中有那么多的酒馆，她却偏偏走进了我的',
        time: '2天前',
      },
      {
        id: 5,
        name: 'Bootstrap',
        description: '那时候我只会想自己想要什么，从不想自己拥有什么',
        time: '5小时前',
      },
      {
        id: 6,
        name: 'Vue',
        description: '凛冬将至',
        time: '刚刚',
      },
    ])

    const updates = ref<Update[]>([
      {
        id: 1,
        user: 'name',
        content: '在白鹭酱油开发组更新番组计划',
        time: '2018-08-23 14:47:00',
      },
      // 可以添加更多更新
    ])

    const quickActions = ref<string[]>(['操作一', '操作二', '操作三', '操作四', '操作五', '操作六'])
    const activeAction = ref<number>(0)

    const teams = ref<Team[]>([
      { id: 1, name: '科学搬砖组' },
      { id: 2, name: '程序员日常' },
      { id: 3, name: '设计天团' },
      { id: 4, name: '中二少女团' },
      { id: 5, name: '骗你学计算机' },
    ])

    return {
      projects,
      updates,
      quickActions,
      activeAction,
      teams,
    }
  },
})
</script>

<style scoped>
.workbench {
  display: flex;
  flex-direction: column;
  height: 100vh;
  font-family: Arial, sans-serif;
}

.top-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #1e88e5;
  color: white;
  padding: 0 20px;
  height: 60px;
}

.welcome-info {
  padding: 20px;
  background-color: #f0f2f5;
}

.welcome-info h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.welcome-info p {
  margin: 8px 0 0;
  color: #666;
  font-size: 14px;
}

.nav-left .logo {
  font-size: 18px;
  font-weight: bold;
}

.nav-right {
  display: flex;
  align-items: center;
}

.username {
  margin-right: 15px;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #ccc;
}

.main-content {
  display: flex;
  flex: 1;
  padding: 20px;
  background-color: #f0f2f5;
  gap: 20px;
}

.project-list,
.dynamic-updates,
.quick-nav-chart {
  background-color: white;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  padding: 15px;
}

.project-list {
  flex: 1;
  margin-top: 20px;
}

.project-list h2 {
  font-size: 18px;
  margin-bottom: 16px;
  color: #333;
}

.dynamic-updates {
  flex: 2;
  margin-top: 20px;
}

.dynamic-updates h2 {
  font-size: 18px;
  margin-bottom: 16px;
  color: #333;
}

.quick-nav-chart {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.project-card {
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.project-card h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
}

.project-card p {
  margin: 0 0 8px 0;
  color: #666;
  font-size: 14px;
}

.project-card .time {
  color: #999;
  font-size: 12px;
}

.update-item {
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.update-item .user {
  color: #1890ff;
  font-weight: bold;
}

.update-item p {
  margin: 8px 0;
}

.update-item .time {
  color: #999;
  font-size: 12px;
}

.quick-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.quick-nav button {
  margin-bottom: 10px;
}

.quick-nav button:last-child {
  background-color: #1890ff;
  color: white;
}

.quick-nav button {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  background-color: #f0f2f5;
  cursor: pointer;
}

.quick-nav button.active {
  background-color: #1890ff;
  color: white;
}

.chart h3 {
  margin: 0 0 15px 0;
  text-align: center;
}

.radar-chart {
  width: 100%;
  height: 200px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.team-item {
  display: flex;
  align-items: center;
  padding: 8px 0;
}

.team-icon {
  display: inline-block;
  width: 24px;
  height: 24px;
  margin-right: 10px;
  background-color: #eee;
  border-radius: 50%;
}
</style>
