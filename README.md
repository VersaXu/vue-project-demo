# 🐢 海龟汤问答游戏

![海龟汤游戏](https://img.shields.io/badge/海龟汤-问答游戏-brightgreen)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D)
![TypeScript](https://img.shields.io/badge/TypeScript-4.x-3178C6)

## 项目介绍

海龟汤是一种流行的情境猜谜推理游戏，玩家需要通过提问来解开看似不合理的情境背后的真相。本项目是一个基于Vue 3和TypeScript的海龟汤问答游戏前端实现。

### 在线体验

[点击这里体验海龟汤游戏](https://versaxu.github.io/Turtle-Soup/)

## 游戏规则

1. 游戏开始时，系统会给出一个荒谬或难以理解的情境
2. 玩家通过提问来找出背后的原因
3. 系统只能回答"是"、"不是"或"没有关系"
4. 提问3次后可以获得提示
5. 玩家需要尽量用最少的提问找出正确答案

## 技术架构

- **前端框架**：Vue 3 + TypeScript
- **状态管理**：Pinia
- **UI组件**：自定义组件
- **API通信**：Axios
- **部署**：GitHub Pages
- **后端服务**：Express.js + Vercel

## 功能特点

- 丰富的谜题库，包含多种类型和难度的海龟汤谜题
- 智能问答系统，能够理解和回答玩家的问题
- 进度跟踪系统，显示玩家解谜进度
- 提示系统，帮助玩家解决困难谜题
- 响应式设计，适配各种设备

## 本地开发

### 前置条件

- Node.js 14.x 或更高版本
- npm 或 yarn

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/VersaXu/Turtle-Soup.git
cd Turtle-Soup
```

2. 安装依赖
```bash
npm install
# 或
yarn install
```

3. 启动开发服务器
```bash
npm run dev
# 或
yarn dev
```

4. 构建生产版本
```bash
npm run build
# 或
yarn build
```

## 谜题库

游戏包含多种类型的谜题：

- 经典类
- 文字游戏类
- 生死抉择类
- 日常生活类
- 恐怖悬疑类
- 科幻奇幻类
- 情感心理类

每个谜题都有对应的难度级别（简单、中等、困难）和提示系统。

## 项目结构

```
src/
├── assets/          # 静态资源
├── components/      # 组件
│   └── TurtleSoupGame.vue  # 主游戏组件
├── config/          # 配置文件
│   ├── apiConfig.ts         # API配置
│   └── turtleSoupKnowledgeBase.ts  # 谜题库
├── services/        # 服务
│   ├── http.service.ts      # HTTP服务
│   ├── turtleSoupApi.ts     # 海龟汤API服务
│   └── turtleSoupService.ts # 海龟汤游戏服务
├── stores/          # 状态管理
│   └── turtleSoupStore.ts   # 海龟汤状态存储
└── views/           # 视图
    └── TurtleSoupGameView.vue  # 游戏视图
```

## 部署

项目使用GitHub Actions自动部署到GitHub Pages。当代码推送到main分支时，会自动构建并部署到gh-pages分支。

## 后端服务

游戏的后端服务部署在Vercel上，提供API支持：
- 谜题生成
- 问答处理
- 用户认证

后端仓库：[Turtle-Soup-Backend](https://github.com/VersaXu/turtle-soup-backend)

## 贡献指南

欢迎为项目做出贡献！您可以通过以下方式参与：

1. 提交问题或建议
2. 提交代码改进
3. 添加新的谜题

## 许可证

[MIT](LICENSE)

## 鸣谢

- 所有海龟汤谜题的原创作者
- Vue.js社区
- 项目贡献者