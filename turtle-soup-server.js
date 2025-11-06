import express from 'express'
import axios from 'axios'
import cors from 'cors'
import dotenv from 'dotenv'

dotenv.config()

const app = express()

// 配置CORS以允许来自GitHub Pages的请求
app.use(cors({
  origin: ['https://versaxu.github.io', 'http://localhost:5173'],
  methods: ['GET', 'POST', 'OPTIONS'],
  credentials: true,
  allowedHeaders: ['Content-Type', 'Authorization']
}))

// 处理预检请求
app.options('*', cors())

app.use(express.json())

// 阿里云通义千问配置
const QWEN_CONFIG = {
  API_KEY: process.env.QWEN_API_KEY || 'sk-446fc4f4977b4584a318ccc235cf2fd1',
  BASE_URL: process.env.QWEN_BASE_URL || 'https://dashscope.aliyuncs.com/compatible-mode/v1',
  MODEL: process.env.QWEN_MODEL || 'qwen-turbo',
}

// 健康检查端点
app.get('/', (req, res) => {
  res.send('海龟汤API服务正常运行')
})

// 通义千问聊天API端点
app.post('/api/qwen/chat', async (req, res) => {
  try {
    const { prompt } = req.body

    console.log('收到聊天请求:', prompt.substring(0, 100) + '...')

    // 发送聊天请求到通义千问API
    const chatResponse = await axios.post(
      `${QWEN_CONFIG.BASE_URL}/chat/completions`,
      {
        model: QWEN_CONFIG.MODEL,
        messages: [
          {
            role: 'user',
            content: prompt,
          },
        ],
        stream: false,
      },
      {
        headers: {
          Authorization: `Bearer ${QWEN_CONFIG.API_KEY}`,
          'Content-Type': 'application/json',
        },
      },
    )

    // 通义千问的响应格式与OpenAI兼容
    const result = chatResponse.data.choices[0].message.content
    console.log('聊天响应:', result.substring(0, 100) + '...')
    res.json({ result })
  } catch (error) {
    console.error('通义千问聊天请求失败:', error.response?.data || error.message)
    res.status(500).json({ error: '通义千问聊天请求失败' })
  }
})

// 用户认证API端点 - 简化版，仅用于演示
app.post('/api/auth/login', (req, res) => {
  try {
    const { username, password } = req.body
    console.log('登录尝试:', username)
    
    // 简化的用户认证逻辑
    if (username && password) {
      const fakeToken = 'turtle-soup-token-' + Date.now()
      const loginResponse = {
        access_token: fakeToken,
        user: {
          id: 1,
          username: username,
          email: username + '@example.com',
        },
      }

      console.log('登录成功:', username)
      res.json(loginResponse)
    } else {
      console.log('登录失败: 用户名或密码为空')
      res.status(401).json({ error: '用户名或密码错误' })
    }
  } catch (error) {
    console.error('登录请求失败:', error.message)
    res.status(500).json({ error: '登录请求失败' })
  }
})

// 用户注册API端点 - 简化版
app.post('/api/auth/register', (req, res) => {
  try {
    const { username, password } = req.body
    console.log('注册尝试:', username)

    if (username && password) {
      const fakeToken = 'turtle-soup-token-' + Date.now()
      const registerResponse = {
        access_token: fakeToken,
        user: {
          id: Date.now(),
          username: username,
          email: username + '@example.com',
        },
      }

      console.log('注册成功:', username)
      res.json(registerResponse)
    } else {
      res.status(400).json({ error: '用户名和密码不能为空' })
    }
  } catch (error) {
    console.error('注册请求失败:', error.message)
    res.status(500).json({ error: '注册请求失败' })
  }
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
  console.log(`海龟汤API服务器运行在端口 ${PORT}`)
})

// 为Vercel提供导出
export default app