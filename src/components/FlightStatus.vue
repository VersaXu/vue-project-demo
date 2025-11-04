<template>
  <div class="flight-status">
    <div class="header">
      <h2>航班动态</h2>
    </div>

    <div class="search-card">
      <div class="tabs">
        <div class="tab active">航班号</div>
        <div class="tab">起降地</div>
      </div>

      <div class="search-input">
        <input type="text" placeholder="请输入航班号，如MU5126或5126" />
      </div>

      <div class="date-selector">
        <div class="date">4月11日 今天</div>
        <div class="date-hint">请选择出发地当地日期</div>
      </div>

      <button class="search-button">
        <i class="search-icon"></i>
        搜索
      </button>
    </div>

    <div class="common-services">
      <h3>常用服务</h3>
      <div class="services-grid">
        <div class="service-item" v-for="service in services" :key="service.name">
          <div class="service-icon" :class="service.icon"></div>
          <div class="service-content">
            <div class="service-title">{{ service.name }}</div>
            <div class="service-desc">{{ service.description }}</div>
          </div>
        </div>
      </div>
    </div>

    <div class="bottom-nav">
      <div class="nav-item">
        <i class="nav-icon home"></i>
        <span>首页</span>
      </div>
      <div class="nav-item">
        <i class="nav-icon trip"></i>
        <span>行程</span>
      </div>
      <div class="nav-item active">
        <i class="nav-icon flight"></i>
        <span>航班动态</span>
      </div>
      <div class="nav-item">
        <i class="nav-icon profile"></i>
        <span>我的</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const services = ref([
  {
    name: '选座值机',
    description: '提前订座不排队',
    icon: 'seat',
  },
  {
    name: '空中Wi-Fi',
    description: '空中照样上网冲浪',
    icon: 'wifi',
  },
  {
    name: '全球酒店',
    description: '想住哪里任挑选',
    icon: 'hotel',
  },
  {
    name: '行李管家',
    description: '一站式行李服务',
    icon: 'luggage',
  },
  {
    name: '高铁联订',
    description: '一站式行李服务',
    icon: 'train',
  },
])
</script>

<style scoped>
.flight-status {
  background-color: #f0f2ff;
  min-height: 100vh;
  padding: 20px 0;
}

.header {
  text-align: center;
  margin-bottom: 20px;
}

.header h2 {
  margin: 0;
  font-size: 18px;
}

.search-card {
  background: white;
  margin: 0 16px;
  border-radius: 12px;
  padding: 20px;
}

.tabs {
  display: flex;
  margin-bottom: 20px;
}

.tab {
  padding: 8px 16px;
  font-size: 16px;
  color: #666;
}

.tab.active {
  color: #000;
  position: relative;
}

.tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 16px;
  right: 16px;
  height: 2px;
  background-color: #000;
}

.search-input input {
  width: 100%;
  padding: 12px;
  border: 1px solid #eee;
  border-radius: 8px;
  font-size: 14px;
  color: #333;
}

.date-selector {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 20px 0;
}

.date {
  font-size: 16px;
  font-weight: bold;
}

.date-hint {
  color: #999;
  font-size: 12px;
}

.search-button {
  width: 100%;
  padding: 14px;
  background-color: #e4394c;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.common-services {
  margin: 20px 16px;
}

.common-services h3 {
  font-size: 16px;
  margin-bottom: 16px;
}

.services-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.service-item {
  background: white;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.service-icon {
  width: 24px;
  height: 24px;
  background-size: contain;
  background-repeat: no-repeat;
}

.service-title {
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 4px;
}

.service-desc {
  font-size: 12px;
  color: #999;
}

.bottom-nav {
  position: relative;
  margin: 20px 16px 0;
  background: white;
  display: flex;
  justify-content: space-around;
  padding: 12px 0;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.nav-icon {
  width: 24px;
  height: 24px;
  background-size: contain;
  background-repeat: no-repeat;
}

.nav-item span {
  font-size: 12px;
  color: #666;
}

.nav-item.active span {
  color: #e4394c;
}

/* 图标样式 */
.seat {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M7 13v-2h12v2H7M7 5h12v2H7V5M4 17h16v2H4v-2Z"/></svg>');
}

.wifi {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M12 21L15.6 16.2C14.6 15.45 13.35 15 12 15S9.4 15.45 8.4 16.2L12 21M12 3C7.95 3 4.21 4.34 1.2 6.6L3 9C5.5 7.12 8.62 6 12 6S18.5 7.12 21 9L22.8 6.6C19.79 4.34 16.05 3 12 3"/></svg>');
}

.hotel {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M19 7h-8v7H3V5H1v15h2v-3h18v3h2v-9a4 4 0 0 0-4-4M7 13a3 3 0 1 0-3-3a3 3 0 0 0 3 3Z"/></svg>');
}

.luggage {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M17.03 6C18.11 6 19 6.88 19 8v11c0 1.13-.89 2-1.97 2c0 .58-.47 1-1.03 1c-.5 0-1-.42-1-1H9c0 .58-.5 1-1 1c-.56 0-1.03-.42-1.03-1C5.89 21 5 20.13 5 19V8c0-1.12.89-2 1.97-2H9V3c0-.58.46-1 1-1h4c.54 0 1 .42 1 1v3h2.03M13.5 6V3.5h-3V6h3Z"/></svg>');
}

.train {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M12 2c-4 0-8 .5-8 4v9.5C4 17.43 5.57 19 7.5 19L6 20.5v.5h2l2-2h4l2 2h2v-.5L16.5 19c1.93 0 3.5-1.57 3.5-3.5V6c0-3.5-4-4-8-4M7.5 17c-.83 0-1.5-.67-1.5-1.5S6.67 14 7.5 14s1.5.67 1.5 1.5S8.33 17 7.5 17m3.5-7H6V6h5v4m5.5 7c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m1.5-7h-5V6h5v4Z"/></svg>');
}

.nav-icon.home {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M10 20v-6h4v6h5v-8h3L12 3L2 12h3v8h5Z"/></svg>');
}

.nav-icon.trip {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M14 11h-4v2h4v-2M9 7h6v2H9V7m12-4h-4.18C16.4 1.84 15.3 1 14 1c-1.3 0-2.4.84-2.82 2H7c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2m-7 0c.55 0 1 .45 1 1s-.45 1-1 1s-1-.45-1-1s.45-1 1-1M7 19V5h14v14H7Z"/></svg>');
}

.nav-icon.flight {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23e4394c" d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1l3.5 1v-1.5L13 19v-5.5l8 2.5Z"/></svg>');
}

.nav-icon.profile {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="%23666" d="M12 4a4 4 0 0 1 4 4a4 4 0 0 1-4 4a4 4 0 0 1-4-4a4 4 0 0 1 4-4m0 10c4.42 0 8 1.79 8 4v2H4v-2c0-2.21 3.58-4 8-4Z"/></svg>');
}
</style>
