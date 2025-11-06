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
  // 为GitHub Pages配置基本路径
  base: '/Turtle-Soup/',
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
  build: {
    // 输出目录
    outDir: 'dist',
    // 生成静态资源的存放路径
    assetsDir: 'assets',
    // 小于此阈值的导入或引用资源将内联为 base64 编码
    assetsInlineLimit: 4096,
    // 启用/禁用 CSS 代码拆分
    cssCodeSplit: true,
    // 构建后是否生成 source map 文件
    sourcemap: false,
  },
})
