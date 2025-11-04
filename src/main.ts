import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from '@/App.vue'
import router from './router'
import Antd from 'ant-design-vue'
// import 'ant-design-vue/dist/antd.css'

const app = createApp(App)

app.use(createPinia())
app.use(Antd)
app.use(router)

// 初始化用户状态
import { useUserStore } from './stores/user'

const initApp = async () => {
  const userStore = useUserStore()
  await userStore.initialize()
  app.mount('#app')
}
initApp()
