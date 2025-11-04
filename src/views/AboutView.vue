<template>
  <div class="about">
    <div class="about-header">
      <h1>关于项目</h1>
      <p class="subtitle">Vue Project Demo - 现代化的 Web 应用开发演示</p>
    </div>

    <div class="about-content">
      <div class="about-item">
        <div class="icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
          </svg>
        </div>
        <div class="details">
          <h3>技术栈</h3>
          <p>基于 <strong>Vue 3</strong> + <strong>TypeScript</strong> + <strong>Vite</strong> 构建的现代化前端应用，集成了 Ant Design Vue、Pinia 状态管理、Vue Router 路由管理等主流技术。</p>
        </div>
      </div>

      <div class="about-item">
        <div class="icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0L19.2 12l-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/>
          </svg>
        </div>
        <div class="details">
          <h3>开发特性</h3>
          <p>支持热重载开发、TypeScript 类型检查、ESLint 代码规范、Prettier 代码格式化、Vitest 单元测试等完整的开发工具链。</p>
        </div>
      </div>

      <div class="about-item">
        <div class="icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
        </div>
        <div class="details">
          <h3>功能模块</h3>
          <p>包含用户认证、模型管理、航班状态查询、游戏娱乐、策略管理等多个功能模块，展示了完整的企业级应用架构。</p>
        </div>
      </div>

      <div class="about-item">
        <div class="icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
          </svg>
        </div>
        <div class="details">
          <h3>设计理念</h3>
          <p>遵循现代化 UI/UX 设计原则，支持明暗主题切换，响应式布局适配多端设备，提供优秀的用户体验。</p>
        </div>
      </div>
    </div>

    <div class="about-footer">
      <div class="version-info">
        <h3>版本信息</h3>
        <div class="version-grid">
          <div class="version-item">
            <span class="label">Vue:</span>
            <span class="value">3.5.13</span>
          </div>
          <div class="version-item">
            <span class="label">TypeScript:</span>
            <span class="value">5.6.3</span>
          </div>
          <div class="version-item">
            <span class="label">Vite:</span>
            <span class="value">6.0.5</span>
          </div>
          <div class="version-item">
            <span class="label">Ant Design Vue:</span>
            <span class="value">4.2.6</span>
          </div>
        </div>
      </div>

      <div class="contact-info">
        <h3>联系方式</h3>
        <p>如果您对本项目有任何疑问或建议，欢迎通过以下方式联系：</p>
        <div class="contact-links">
          <a href="mailto:contact@example.com" class="contact-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.89 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/>
            </svg>
            Email
          </a>
          <a href="https://github.com" target="_blank" rel="noopener" class="contact-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
            </svg>
            GitHub
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.about {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.about-header {
  text-align: center;
  margin-bottom: 3rem;
}

.about-header h1 {
  font-size: 2.5rem;
  font-weight: 600;
  color: var(--color-heading);
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.1rem;
  color: var(--color-text);
  opacity: 0.8;
}

.about-content {
  margin-bottom: 3rem;
}

.about-item {
  display: flex;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: var(--color-background-soft);
  border-radius: 12px;
  border: 1px solid var(--color-border);
  transition: all 0.3s ease;
}

.about-item:hover {
  border-color: var(--color-border-hover);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  background: hsla(160, 100%, 37%, 0.1);
  border-radius: 8px;
  color: hsla(160, 100%, 37%, 1);
  flex-shrink: 0;
  margin-right: 1rem;
}

.details {
  flex: 1;
}

.details h3 {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--color-heading);
  margin-bottom: 0.5rem;
}

.details p {
  line-height: 1.6;
  color: var(--color-text);
}

.about-footer {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  padding-top: 2rem;
  border-top: 1px solid var(--color-border);
}

.version-info h3,
.contact-info h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--color-heading);
  margin-bottom: 1rem;
}

.version-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem;
}

.version-item {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem;
  background: var(--color-background-mute);
  border-radius: 6px;
  font-size: 0.9rem;
}

.label {
  color: var(--color-text);
  opacity: 0.8;
}

.value {
  font-weight: 600;
  color: hsla(160, 100%, 37%, 1);
}

.contact-info p {
  margin-bottom: 1rem;
  color: var(--color-text);
  line-height: 1.6;
}

.contact-links {
  display: flex;
  gap: 1rem;
}

.contact-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: var(--color-background-mute);
  border-radius: 6px;
  text-decoration: none;
  color: var(--color-text);
  transition: all 0.3s ease;
  font-size: 0.9rem;
}

.contact-link:hover {
  background: hsla(160, 100%, 37%, 0.1);
  color: hsla(160, 100%, 37%, 1);
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .about {
    padding: 1rem;
  }

  .about-header h1 {
    font-size: 2rem;
  }

  .about-item {
    flex-direction: column;
    text-align: center;
  }

  .icon {
    margin: 0 auto 1rem;
  }

  .about-footer {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .version-grid {
    grid-template-columns: 1fr;
  }

  .contact-links {
    flex-direction: column;
  }
}

@media (min-width: 1024px) {
  .about {
    padding: 3rem 2rem;
  }
}
</style>
