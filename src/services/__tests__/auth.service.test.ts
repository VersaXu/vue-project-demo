import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import AuthService from '../auth.service'
import axios from 'axios';

interface LoginCredentials {
  username: string
  password: string
}

interface LoginResponse {
  access_token: string
  user: {
    id: number
    username: string
    email: string
  }
}

vi.mock('axios', () => ({
  post: vi.fn(),
}))

describe('login', () => {
  let authService: any

  beforeEach(() => {
    authService = AuthService
  })

  it('should return a mocked login response for admin user', async () => {
    const credentials = {
      username: 'admin',
      password: 'admin123',
    }

    const response = {
      access_token: 'fake-jwt-token-1234567890',
      user: {
        id: 1,
        username: 'admin',
        email: 'admin@example.com',
      },
    }

    const spy = vi.spyOn(authService, 'login')
    spy.mockImplementation(() => Promise.resolve(response))

    const result = await authService.login(credentials)

    expect(result).toEqual(response)
    expect(spy).toHaveBeenCalledWith(credentials)
  })

  it('should throw an error for invalid credentials', async () => {
    const credentials = {
      username: 'invalid',
      password: 'invalid',
    }

    const spy = vi.spyOn(authService, 'login')
    spy.mockImplementation(() => Promise.reject(new Error('Invalid credentials')))

    await expect(authService.login(credentials)).rejects.toThrow('Invalid credentials')
    expect(spy).toHaveBeenCalledWith(credentials)
  })
})


async function login(credentials: LoginCredentials): Promise<LoginResponse> {
  // 打印登录尝试的日志
  console.log('Login attempt with credentials:', credentials.username, credentials.password);
  // 模拟登录过程
  if (credentials.username === 'admin' && credentials.password === 'admin123') {
    // 生成一个伪造的JWT令牌
    const fakeToken = 'fake-jwt-token-' + Date.now();
    // 创建一个模拟的登录响应对象
    const mockResponse: LoginResponse = {
      access_token: fakeToken,
      user: {
        id: 1,
        username: 'admin',
        email: 'admin@example.com',
      },
    };

    this.setToken(fakeToken);

    console.log('Login successful for admin user', mockResponse);

    return mockResponse;
  }

  // 打印登录失败的日志
  console.log('Login failed: Invalid credentials');

  // 抛出错误
  throw new Error('Invalid credentials');
}

mockResponse: LoginResponse = {
      access_token: fakeToken,
      user: {
        id: 1,
        username: 'admin',
        email: 'admin@example.com',
      },
    }

{
      access_token: fakeToken,
      user: {
        id: 1,
        username: 'admin',
        email: 'admin@example.com',
      },
    }

describe('login', () => {
  it('should return a mock response for valid credentials', async () => {
    const credentials: LoginCredentials = {
      username: 'admin',
      password: 'admin123',
    };

    const response = await login(credentials);

    expect(response.access_token).toBe('fake-jwt-token-' + Date.now());
    expect(response.user.username).toBe('admin');
  });

  it('should throw an error for invalid credentials', async () => {
    const credentials: LoginCredentials = {
      username: 'invalid',
      password: 'invalid',
    };

    await expect(login(credentials)).rejects.toThrow('Invalid credentials');
  });
});

credentials: LoginCredentials = {
      username: 'admin',
      password: 'admin123',
    }

{
      username: 'admin',
      password: 'admin123',
    }

credentials: LoginCredentials = {
      username: 'invalid',
      password: 'invalid',
    }

{
      username: 'invalid',
      password: 'invalid',
    }