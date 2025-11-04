import axios from 'axios'

const API_URL = '/api'

export interface LoginResponse {
  access_token: string
  user: {
    id: number
    username: string
    email: string
  }
}

export interface LoginCredentials {
  username: string
  password: string
}

export interface UserPayload {
  id: number
  username: string
  email: string
}

class AuthService {
  // 存储 token
  setToken(token: string) {
    localStorage.setItem('jwt_token', token)
  }

  // 获取 token
  getToken(): string | null {
    return localStorage.getItem('jwt_token')
  }

  // 移除 token
  removeToken() {
    localStorage.removeItem('jwt_token')
  }

  // 生成一个register用户注册函数，包含Credentials输入，必须包含异常处理
  /**
   * 注册用户
   *
   * @param credentials 注册信息对象，包含用户名和密码
   * @returns 返回注册结果的 Promise 对象，解析为 LoginResponse 类型
   */
  async register(credentials: LoginCredentials): Promise<LoginResponse> {
    try {
      const response = await axios.post(`${API_URL}/auth/register`, credentials)
      this.setToken(response.data.access_token)
      return response.data
    } catch (error) {
      if (axios.isAxiosError(error)) {
        throw new Error(error.response?.data?.message || 'Registration failed')
      }
      throw error
    }
  }

  /**
   * 异步登录函数
   *
   * @param credentials 登录凭证对象，包含用户名和密码
   * @returns 返回一个 Promise，解析为 LoginResponse 对象
   * @throws 如果凭证无效，则抛出错误
   */
  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    try {
      const response = await axios.post(`${API_URL}/auth/login`, credentials)
      this.setToken(response.data.access_token)
      return response.data
    } catch (error) {
      if (axios.isAxiosError(error)) {
        throw new Error(error.response?.data?.message || 'Login failed')
      }
      throw error
    }
  }

  // 登出方法
  logout() {
    this.removeToken()
  }

  getCurrentUser(): UserPayload | null {
    const token = this.getToken()
    if (!token) return null

    try {
      const payload = token.split('.')[1]
      const decoded = atob(payload.replace(/-/g, '+').replace(/_/g, '/'))
      return JSON.parse(decoded) as UserPayload
    } catch (error) {
      console.error('Failed to parse token:', error)
      return null
    }
  }

  // 检查是否已认证
  isAuthenticated(): boolean {
    const token = this.getToken()
    return !!token
  }
}

export default new AuthService()
