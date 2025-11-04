import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    proxy: {
      // 开发环境下，/api 开头的请求会被转发到这个地址
      '/api': {
        target: 'http://localhost:3000', // 替换为你的后端服务地址
        changeOrigin: true,
        rewrite: (path) => path, // 保持路径不变
      },
    },
  },
})
