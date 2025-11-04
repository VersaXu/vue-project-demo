<template>
  <div class="policy-detail">
    <a-card class="policy-detail-card">
      <div class="header">
        <h1 class="title">神太保单</h1>
        <span class="time">{{ currentTime }}</span>
      </div>

      <div class="search-section">
        <a-input-search
          v-model:value="searchText"
          placeholder="搜索保单"
          class="search-input"
          @search="onSearch"
        />
        <a-button type="primary" @click="onFilter">筛选</a-button>
      </div>

      <div class="action-buttons">
        <a-space>
          <a-button
            v-for="action in actions"
            :key="action.key"
            type="text"
            @click="handleAction(action.key)"
          >
            <template #icon>
              <component :is="action.icon" />
            </template>
            {{ action.text }}
          </a-button>
        </a-space>
      </div>

      <a-descriptions :column="1" class="policy-info" bordered size="middle">
        <a-descriptions-item label="原保单号">
          {{ policyData.policyNumber }}
        </a-descriptions-item>
        <a-descriptions-item label="保险产品">
          {{ policyData.productName }}
        </a-descriptions-item>
        <a-descriptions-item label="投保人">
          {{ policyData.policyholder }}
        </a-descriptions-item>
        <a-descriptions-item label="被保险人">
          {{ policyData.insured }}
        </a-descriptions-item>
        <a-descriptions-item label="续保服务止期">
          {{ policyData.expiryDate }}
        </a-descriptions-item>
      </a-descriptions>

      <div class="footer-buttons">
        <a-button class="contact-btn" @click="handleContact"> 联系投保人 </a-button>
        <a-button type="primary" class="renew-btn" @click="handleRenew"> 续保 </a-button>
      </div>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import type { Ref } from 'vue'
import {
  FileProtectOutlined,
  SwapOutlined,
  CheckCircleOutlined,
  FieldTimeOutlined,
  FileTextOutlined,
} from '@ant-design/icons-vue'
import { message } from 'ant-design-vue'

interface PolicyData {
  policyNumber: string
  productName: string
  policyholder: string
  insured: string
  expiryDate: string
}

const searchText: Ref<string> = ref('')
const currentTime: Ref<string> = ref('')

const actions = [
  { key: 'verify', icon: FileProtectOutlined, text: '核保单' },
  { key: 'transfer', icon: SwapOutlined, text: '转核保单' },
  { key: 'visit', icon: CheckCircleOutlined, text: '签收回访' },
  { key: 'shortTerm', icon: FieldTimeOutlined, text: '短险续保' },
  { key: 'longTerm', icon: FileTextOutlined, text: '长险续保' },
]

const policyData: PolicyData = {
  policyNumber: 'P1234567890',
  productName: '太保长相伴(尊享版)终身寿险等',
  policyholder: '张三',
  insured: '李四',
  expiryDate: '2025-12-31',
}

// 事件处理函数
const onSearch = (value: string) => {
  message.info(`搜索关键词: ${value}`)
}

const onFilter = () => {
  message.info('点击了筛选按钮')
}

const handleAction = (key: string) => {
  const actionMap: Record<string, string> = {
    verify: '核保单',
    transfer: '转核保单',
    visit: '签收回访',
    shortTerm: '短险续保',
    longTerm: '长险续保',
  }
  message.info(`点击了${actionMap[key]}按钮`)
}

const handleContact = () => {
  message.info(`正在联系投保人: ${policyData.policyholder}`)
}

const handleRenew = () => {
  message.info('正在处理续保请求')
}

onMounted(() => {
  updateTime()
  const timer = setInterval(updateTime, 60000)

  // 组件卸载时清除定时器
  onUnmounted(() => {
    clearInterval(timer)
  })
})

function updateTime() {
  const now = new Date()
  const hours = now.getHours().toString().padStart(2, '0')
  const minutes = now.getMinutes().toString().padStart(2, '0')
  currentTime.value = `${hours}:${minutes}`
}
</script>

<style scoped>
.policy-detail {
  padding: 24px;
  background: #f0f2f5;
  min-height: 100vh;
}

.policy-detail-card {
  max-width: 800px;
  margin: 0 auto;
  border-radius: 8px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #1f1f1f;
}

.time {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.45);
}

.search-section {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
}

.search-input {
  flex: 1;
}

.action-buttons {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 24px;
}

.policy-info {
  margin-bottom: 24px;
}

.footer-buttons {
  display: flex;
  gap: 16px;
  justify-content: space-between;
  margin-top: 32px;
}

.contact-btn,
.renew-btn {
  flex: 1;
  height: 40px;
  font-size: 16px;
}

/* 响应式布局 */
@media (max-width: 576px) {
  .policy-detail {
    padding: 12px;
  }

  .policy-detail-card {
    border-radius: 0;
  }

  .action-buttons {
    overflow-x: auto;
    justify-content: flex-start;
    padding-bottom: 16px;
  }

  .action-buttons :deep(.ant-space) {
    flex-wrap: nowrap;
    padding: 0 8px;
  }

  .footer-buttons {
    flex-direction: column;
    margin-top: 24px;
  }

  .contact-btn,
  .renew-btn {
    width: 100%;
  }
}
</style>
