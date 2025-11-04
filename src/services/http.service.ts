import axios from 'axios'
import authService from './auth.service'
import router from '@/router'

// 创建 axios 实例
const http = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  },
})

// 请求拦截器
http.interceptors.request.use(
  (config) => {
    const token = authService.getToken()
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  },
)

// 响应拦截器
http.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      if (!router.currentRoute.value.path.startsWith('/login')) {
        authService.logout()
        router.push({
          path: '/login',
          query: { redirect: router.currentRoute.value.fullPath },
        })
      }
    }

    // 统一错误格式
    if (axios.isAxiosError(error)) {
      return Promise.reject({
        message: error.response?.data?.message || error.message,
        status: error.response?.status,
        code: error.code,
      })
    }
    return Promise.reject(error)
  },
)

export default http
