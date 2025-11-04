import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import authService, { type LoginCredentials, type LoginResponse } from '@/services/auth.service'
import http from '@/services/http.service'
import antDesignVue from 'ant-design-vue'

interface User {
  id: number
  username: string
  email: string
  role?: string
}

export const useUserStore = defineStore('user', () => {
  const { notification } = antDesignVue
  const user = ref<User | null>(null)
  const isAuthenticated = computed(() => authService.isAuthenticated())

  async function login(credentials: LoginCredentials) {
    try {
      const response = await authService.login(credentials)
      user.value = response.user
      return response
    } catch (error) {
      notification.error({
        message: '登录失败',
        description: error instanceof Error ? error.message : '未知错误',
      })
      throw error
    }
  }

  function logout() {
    authService.logout()
    user.value = null
  }

  async function fetchUserProfile() {
    try {
      const response = await http.get('/users/profile')
      user.value = response.data
    } catch (error) {
      notification.error({
        message: '获取用户信息失败',
        description: error instanceof Error ? error.message : '未知错误',
      })
      throw error
    }
  }

  async function initialize() {
    if (authService.isAuthenticated()) {
      try {
        await fetchUserProfile()
      } catch {
        logout()
      }
    }
  }

  return {
    user,
    isAuthenticated,
    login,
    logout,
    initialize,
    fetchUserProfile,
  }
})
