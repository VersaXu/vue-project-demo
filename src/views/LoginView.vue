<template>
  <div class="login-container">
    <a-card title="用户登录" :bordered="false" class="login-card">
      <a-form
        :model="formState"
        name="basic"
        :label-col="{ span: 0 }"
        :wrapper-col="{ span: 24 }"
        autocomplete="off"
        @finish="onFinish"
        @finishFailed="onFinishFailed"
      >
        <a-form-item
          label="用户名"
          name="username"
          :rules="[{ required: true, message: '请输入用户名!' }]"
        >
          <a-input v-model:value="formState.username" />
        </a-form-item>

        <a-form-item
          :wrapper-col="{ span: 23, offset: 1 }"
          label="密码"
          name="password"
          :rules="[{ required: true, message: '请输入密码!' }]"
        >
          <a-input-password v-model:value="formState.password" />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 20, offset: 2 }">
          <a-button type="primary" html-type="submit" class="login-button"> 登录 </a-button>
        </a-form-item>
      </a-form>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { message } from 'ant-design-vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
// const userStore = useUserStore()

interface FormState {
  username: string
  password: string
}

const formState = reactive<FormState>({
  username: '',
  password: '',
})

const userStore = useUserStore()

// 这里需要传一个对象，包含用户名和密码；而不是最开始的分开传递
// 这里用的是async await，所以需要返回一个promise
const onFinish = async (values: FormState) => {
  try {
    await userStore.login(values)
    message.success('登录成功')
    const redirect = router.currentRoute.value.query.redirect
    router.push(redirect ? redirect.toString() : '/')
  } catch (error: any) {
    message.error(error.message || '登录失败')
  }
}

const onFinishFailed = (errorInfo: any) => {
  console.log('Failed:', errorInfo)
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  width: 100%;
  background: linear-gradient(135deg, #1890ff11 0%, #1890ff05 100%);
  position: fixed;
  top: 0;
  left: 0;
}

.login-card {
  width: 400px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
}

.login-card :deep(.ant-card-head) {
  border-bottom: none;
  padding: 24px 24px 0;
}

.login-card :deep(.ant-card-head-title) {
  font-size: 24px;
  font-weight: 600;
  text-align: center;
  color: #125f05;
}

.login-card :deep(.ant-form-item-label) {
  padding-bottom: 8px;
}

.login-card :deep(.ant-form-item) {
  margin-bottom: 24px;
  padding: 0 24px;
}

.login-card :deep(.ant-form-item-label > label) {
  font-size: 14px;
  color: rgba(0, 0, 0, 0.85);
  height: 32px;
  margin-bottom: 4px;
}

.login-button {
  width: 100%;
  height: 40px;
  font-size: 16px;
}
</style>
