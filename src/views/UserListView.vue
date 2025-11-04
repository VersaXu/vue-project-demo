<script setup lang="ts">
import { ref, onMounted } from 'vue'

// 格式化日期的函数 （暴力方式）
function formatDate(dateString: string) {
  const date = new Date(dateString)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

import { supabase } from '../lib/supabaseClient'

const users = ref([])

async function getAllUsers() {
  let { data, error } = await supabase.from('Users').select('*')

  console.log(data)

  if (error) {
    console.error('Error fetching users:', error)
    return
  }

  // 处理日期格式
  users.value = data.map((user) => ({
    ...user,
    created_at: formatDate(user.created_at),
  }))
  // console.log(Users)
}

// 定义列配置
const columns = [
  {
    title: 'Name',
    dataIndex: 'name',
    key: 'name',
    scopedSlots: { customRender: 'name' },
  },
  {
    title: 'Email',
    dataIndex: 'email',
    key: 'email',
    scopedSlots: { customRender: 'email' },
  },
  {
    title: 'License',
    dataIndex: 'license',
    key: 'license',
    scopedSlots: { customRender: 'license' },
  },
  {
    title: 'Created Time',
    dataIndex: 'created_at',
    key: 'created_at',
    scopedSlots: { customRender: 'created_at' },
  },
]

onMounted(() => {
  getAllUsers()
})
</script>

<template>
  <div class="table-container">
    <a-table
      :columns="columns"
      :data-source="users"
      row-key="id"
      :pagination="false"
      style="width: 100%"
    >
      <template #name="{ record }">
        <Tooltip :title="record.name">
          {{ record.name }}
        </Tooltip>
      </template>
      <template #email="{ record }">
        <Tooltip :title="record.email">
          {{ record.email }}
        </Tooltip>
      </template>
      <template #license="{ record }">
        <Tooltip :title="record.license">
          {{ record.license }}
        </Tooltip>
      </template>
      <template #created_at="{ record }">
        <Tooltip :title="record.created_at">
          {{ record.created_at }}
        </Tooltip>
      </template>
    </a-table>
  </div>
</template>

<style scoped>
/* 确保黑色主题 */
:root {
  --ant-primary-color: #1890ff; /* 蓝色主题 */
  --ant-primary-color-hover: #40a9ff; /* 蓝色主题 */
  --ant-primary-color-active: #096dd9; /* 蓝色主题 */
  --ant-primary-color-outline: rgba(24, 144, 255, 0.2); /* 蓝色主题 */
}

/* 自定义表格样式 */
.table-container {
  padding: 30px;
  width: 130vh;
}

/* 使用/deep/或::v-deep来穿透scoped样式 */
.ant-table {
  border-radius: 20px; /* 圆角 */
  overflow: hidden; /* 隐藏超出部分 */
}

.ant-table {
  background-color: #3f3737; /* 深色背景 */
  color: #7d97b4; /* 白色文字 */
}

.ant-table-thead > tr > th,
.ant-table-tbody > tr > td {
  border-color: #333; /* 深色边框 */
}

/* 工具提示样式 */
.ant-tooltip {
  background-color: #333; /* 深色背景 */
  color: #ffffff; /* 白色文字 */
}

/* 响应式设计 */
@media (max-width: 768px) {
  .ant-table-thead > tr > th,
  .ant-table-tbody > tr > td {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}
</style>
