<script setup lang="ts">
import { RouterLink, RouterView, useRoute, useRouter } from 'vue-router'
import { useUserStore } from './stores/user'
import { ref, onMounted, onUnmounted, nextTick } from 'vue'

const userStore = useUserStore()
const route = useRoute()
const router = useRouter()

const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}

// 检查是否在登录页面
const isLoginPage = () => route.path === '/login'

// 检查是否在首页
const isHomePage = () => route.path === '/'

// 轮播图数据
const carouselImages = ref([
  {
    url: 'https://picsum.photos/1200/400?random=1',
    title: '探索无限可能',
    subtitle: '开启创新之旅，发现更多精彩',
    color: '#1890ff'
  },
  {
    url: 'https://picsum.photos/1200/400?random=2',
    title: '创新科技未来',
    subtitle: '拥抱科技变革，引领时代发展',
    color: '#52c41a'
  },
  {
    url: 'https://picsum.photos/1200/400?random=3',
    title: '智慧生活方式',
    subtitle: '让科技融入生活，享受便捷体验',
    color: '#722ed1'
  },
  {
    url: 'https://picsum.photos/1200/400?random=4',
    title: '美好生活向往',
    subtitle: '追求品质生活，创造美好未来',
    color: '#eb2f96'
  },
])

// 轮播图控制状态
const currentSlide = ref(0)
const isAutoPlaying = ref(true)
const carouselRef = ref(null)
const isHovering = ref(false)
const progressTimer = ref<number | null>(null)
const progressPercent = ref(0)
const touchStartX = ref(0)
const touchEndX = ref(0)
const isDragging = ref(false)

// 轮播图控制方法
const goToSlide = (index: number) => {
  if (index === currentSlide.value) return
  currentSlide.value = index
  resetProgress()
  if (carouselRef.value) {
    carouselRef.value.goTo(index)
  }
}

const nextSlide = () => {
  const nextIndex = (currentSlide.value + 1) % carouselImages.value.length
  goToSlide(nextIndex)
}

const prevSlide = () => {
  const prevIndex = currentSlide.value === 0 
    ? carouselImages.value.length - 1 
    : currentSlide.value - 1
  goToSlide(prevIndex)
}

const pauseAutoplay = () => {
  isAutoPlaying.value = false
  if (progressTimer.value) {
    clearInterval(progressTimer.value)
    progressTimer.value = null
  }
}

const resumeAutoplay = () => {
  if (!isHovering.value && !isDragging.value) {
    isAutoPlaying.value = true
    startProgress()
  }
}

const resetProgress = () => {
  progressPercent.value = 0
  if (progressTimer.value) {
    clearInterval(progressTimer.value)
    progressTimer.value = null
  }
}

const startProgress = () => {
  if (!isAutoPlaying.value || isHovering.value || isDragging.value) return
  
  resetProgress()
  const interval = 50 // 更新间隔 50ms
  const totalTime = 4000 // 总时间 4秒
  const increment = (interval / totalTime) * 100
  
  progressTimer.value = setInterval(() => {
    if (!isAutoPlaying.value || isHovering.value || isDragging.value) {
      if (progressTimer.value) {
        clearInterval(progressTimer.value)
        progressTimer.value = null
      }
      return
    }
    
    progressPercent.value += increment
    if (progressPercent.value >= 100) {
      progressPercent.value = 0
      nextSlide()
    }
  }, interval)
}

// 触摸事件处理
const handleTouchStart = (e: TouchEvent) => {
  touchStartX.value = e.touches[0].clientX
  isDragging.value = true
  pauseAutoplay()
}

const handleTouchMove = (e: TouchEvent) => {
  if (!isDragging.value) return
  touchEndX.value = e.touches[0].clientX
}

const handleTouchEnd = () => {
  if (!isDragging.value) return
  
  const diffX = touchStartX.value - touchEndX.value
  const threshold = 50
  
  if (Math.abs(diffX) > threshold) {
    if (diffX > 0) {
      nextSlide()
    } else {
      prevSlide()
    }
  }
  
  isDragging.value = false
  setTimeout(() => {
    resumeAutoplay()
  }, 100)
}

// 键盘导航
const handleKeydown = (e: KeyboardEvent) => {
  if (!isHomePage()) return
  
  switch (e.key) {
    case 'ArrowLeft':
      e.preventDefault()
      prevSlide()
      break
    case 'ArrowRight':
      e.preventDefault()
      nextSlide()
      break
    case ' ':
      e.preventDefault()
      isAutoPlaying.value ? pauseAutoplay() : resumeAutoplay()
      break
  }
}

// 鼠标悬停处理
const handleMouseEnter = () => {
  isHovering.value = true
  pauseAutoplay()
}

const handleMouseLeave = () => {
  isHovering.value = false
  resumeAutoplay()
}

// 生命周期
onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
  nextTick(() => {
    startProgress()
  })
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
  if (progressTimer.value) {
    clearInterval(progressTimer.value)
  }
})
</script>

<template>
  <div>
    <header v-if="!isLoginPage()">
      <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" />
      <div class="wrapper" v-if="userStore.isAuthenticated">
        <HelloWorld msg="You did it!" />

        <nav>
          <RouterLink to="/login" v-if="!userStore.isAuthenticated" class="login-link"
            >Login</RouterLink
          >
          <RouterLink to="/">Home</RouterLink>
          <RouterLink to="/about">About</RouterLink>
          <RouterLink to="/comate-prod">Baidu Comate</RouterLink>
          <RouterLink to="/user-data">User DashBoard</RouterLink>
          <RouterLink to="/snake-game">Snake Game</RouterLink>
          <RouterLink to="/flight-status">Flight Status</RouterLink>
          <RouterLink to="/turtle-soup">Turtle Soup Game</RouterLink>
          <RouterLink to="/policy">Policy</RouterLink>
        </nav>
        <div class="user-info">
          <span v-if="userStore.user">Welcome, {{ userStore.user.username }}! &nbsp; </span>
          <a-button type="primary" @click="handleLogout">登出</a-button>
        </div>
      </div>
      <div class="wrapper" v-else>
        <RouterLink to="/login" class="login-link">Login</RouterLink>
      </div>
    </header>

    <!-- 轮播图组件 -->
    <div 
      class="carousel-container" 
      v-if="isHomePage()"
      @mouseenter="handleMouseEnter"
      @mouseleave="handleMouseLeave"
      @touchstart="handleTouchStart"
      @touchmove="handleTouchMove"
      @touchend="handleTouchEnd"
    >
      <a-carousel 
        ref="carouselRef"
        effect="scrollx" 
        :autoplay="false"
        :dots="false"
        :fade="false"
        :infinite="true"
        :speed="600"
        :easing="'cubic-bezier(0.25, 0.46, 0.45, 0.94)'"
        @afterChange="(current: number) => { currentSlide = current; startProgress() }"
        @beforeChange="resetProgress"
        class="carousel-wrapper"
      >
        <div v-for="(image, index) in carouselImages" :key="index" class="carousel-slide">
          <div class="carousel-content">
            <div class="image-container">
              <img 
                :src="image.url" 
                :alt="image.title"
                :style="{ filter: `hue-rotate(${index * 30}deg)` }"
                loading="lazy"
              />
              <div 
                class="image-overlay"
                :style="{ background: `linear-gradient(135deg, ${image.color}20 0%, transparent 50%, ${image.color}40 100%)` }"
              ></div>
              <div class="parallax-layer"></div>
            </div>
            <div class="carousel-text-content">
              <div class="carousel-title" :style="{ color: image.color }">
                {{ image.title }}
              </div>
              <div class="carousel-subtitle">
                {{ image.subtitle }}
              </div>
              <div class="carousel-action">
                <button class="cta-button" :style="{ backgroundColor: image.color }">
                  了解更多
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path d="M6 3L11 8L6 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </a-carousel>
      
      <!-- 进度条指示器 -->
      <div class="progress-dots">
        <div 
          v-for="(image, index) in carouselImages" 
          :key="index"
          :class="['progress-dot', { active: currentSlide === index }]"
          @click="goToSlide(index)"
          :style="{ '--dot-color': image.color }"
        >
          <div class="dot-background"></div>
          <div 
            class="dot-progress" 
            :style="{ 
              width: currentSlide === index ? `${progressPercent}%` : '0%',
              backgroundColor: image.color 
            }"
          ></div>
          <span class="dot-label">{{ image.title.slice(0, 2) }}</span>
        </div>
      </div>
      
      <!-- 导航箭头 -->
      <button 
        class="carousel-nav prev" 
        @click="prevSlide"
        :disabled="isDragging"
        aria-label="上一张"
      >
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <button 
        class="carousel-nav next" 
        @click="nextSlide"
        :disabled="isDragging"
        aria-label="下一张"
      >
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      
      <!-- 播放控制按钮 -->
      <button 
        class="play-control" 
        @click="isAutoPlaying ? pauseAutoplay() : resumeAutoplay()"
        :aria-label="isAutoPlaying ? '暂停自动播放' : '开始自动播放'"
      >
        <svg v-if="isAutoPlaying" width="20" height="20" viewBox="0 0 20 20" fill="none">
          <rect x="6" y="4" width="2" height="12" fill="currentColor"/>
          <rect x="12" y="4" width="2" height="12" fill="currentColor"/>
        </svg>
        <svg v-else width="20" height="20" viewBox="0 0 20 20" fill="none">
          <path d="M6 4L16 10L6 16V4Z" fill="currentColor"/>
        </svg>
      </button>
      
      <!-- 滑动提示 -->
      <div class="swipe-hint" v-if="!isHovering && currentSlide === 0">
        <div class="hint-text">← 滑动查看更多 →</div>
        <div class="hint-animation"></div>
      </div>
    </div>

    <section class="main-content">
      <RouterView />
    </section>
  </div>
</template>

<style scoped>
/* 轮播图样式 */
.carousel-container {
  width: 100%;
  max-width: 1200px;
  margin: 20px auto;
  padding: 0 20px;
  position: relative;
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

.carousel-wrapper {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  position: relative;
}

.carousel-wrapper:hover {
  box-shadow: 0 25px 80px rgba(0, 0, 0, 0.2);
  transform: translateY(-4px);
}

.carousel-slide {
  height: 480px;
  overflow: hidden;
  position: relative;
  cursor: grab;
}

.carousel-slide:active {
  cursor: grabbing;
}

.carousel-content {
  height: 100%;
  position: relative;
}

.image-container {
  height: 100%;
  position: relative;
  overflow: hidden;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  will-change: transform;
}

.carousel-slide:hover .image-container img {
  transform: scale(1.08);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  transition: all 0.4s ease;
  z-index: 1;
}

.parallax-layer {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    135deg,
    rgba(0, 0, 0, 0.1) 0%,
    transparent 40%,
    rgba(0, 0, 0, 0.3) 100%
  );
  transition: opacity 0.4s ease;
  z-index: 2;
}

.carousel-text-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 50px;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  transform: translateY(30px);
  opacity: 0;
  animation: slideInUp 1s cubic-bezier(0.25, 0.46, 0.45, 0.94) 0.2s forwards;
  z-index: 3;
}

@keyframes slideInUp {
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.carousel-title {
  font-size: 36px;
  font-weight: 800;
  line-height: 1.2;
  margin-bottom: 12px;
  text-shadow: 0 3px 12px rgba(0, 0, 0, 0.4);
  letter-spacing: -0.8px;
  transition: color 0.3s ease;
  background: linear-gradient(135deg, currentColor 0%, rgba(255, 255, 255, 0.9) 100%);
  -webkit-background-clip: text;
  background-clip: text;
}

.carousel-subtitle {
  color: rgba(255, 255, 255, 0.95);
  font-size: 18px;
  font-weight: 400;
  line-height: 1.6;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
  max-width: 600px;
  margin-bottom: 24px;
}

.carousel-action {
  margin-top: 20px;
}

.cta-button {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  border: none;
  border-radius: 50px;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  position: relative;
  overflow: hidden;
}

.cta-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.cta-button:hover::before {
  left: 100%;
}

.cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
}

.cta-button:active {
  transform: translateY(0);
}

/* 进度条指示器 */
.progress-dots {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 30px;
  padding: 0 20px;
}

.progress-dot {
  position: relative;
  width: 60px;
  height: 8px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.2);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.progress-dot:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.progress-dot.active {
  background: rgba(255, 255, 255, 0.4);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.dot-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.dot-progress {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  border-radius: 4px;
  transition: width 0.1s linear;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.dot-label {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.progress-dot:hover .dot-label,
.progress-dot.active .dot-label {
  opacity: 1;
}

/* 导航箭头 */
.carousel-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 56px;
  height: 56px;
  border: none;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.95);
  color: #333;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  backdrop-filter: blur(20px);
  z-index: 4;
  opacity: 0;
  visibility: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.carousel-container:hover .carousel-nav {
  opacity: 1;
  visibility: visible;
}

.carousel-nav:hover {
  background: white;
  transform: translateY(-50%) scale(1.15);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
}

.carousel-nav:active {
  transform: translateY(-50%) scale(1.05);
}

.carousel-nav:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.carousel-nav.prev {
  left: 24px;
}

.carousel-nav.next {
  right: 24px;
}

/* 播放控制按钮 */
.play-control {
  position: absolute;
  top: 24px;
  right: 24px;
  width: 48px;
  height: 48px;
  border: none;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.6);
  color: white;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  backdrop-filter: blur(20px);
  z-index: 4;
  opacity: 0;
  visibility: hidden;
}

.carousel-container:hover .play-control {
  opacity: 1;
  visibility: visible;
}

.play-control:hover {
  background: rgba(0, 0, 0, 0.8);
  transform: scale(1.1);
}

/* 滑动提示 */
.swipe-hint {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 4;
  animation: fadeInOut 3s ease-in-out infinite;
}

.hint-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  margin-bottom: 8px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.hint-animation {
  width: 60px;
  height: 2px;
  background: rgba(255, 255, 255, 0.5);
  margin: 0 auto;
  border-radius: 1px;
  position: relative;
  overflow: hidden;
}

.hint-animation::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.9);
  animation: slideHint 2s ease-in-out infinite;
}

@keyframes fadeInOut {
  0%, 100% { opacity: 0; }
  50% { opacity: 1; }
}

@keyframes slideHint {
  0% { left: -100%; }
  100% { left: 100%; }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .carousel-container {
    margin: 15px auto;
    padding: 0 15px;
  }
  
  .carousel-slide {
    height: 350px;
  }
  
  .carousel-text-content {
    padding: 30px 25px;
  }
  
  .carousel-title {
    font-size: 28px;
    margin-bottom: 8px;
  }
  
  .carousel-subtitle {
    font-size: 16px;
    margin-bottom: 16px;
  }
  
  .cta-button {
    padding: 10px 20px;
    font-size: 14px;
  }
  
  .carousel-nav {
    width: 44px;
    height: 44px;
  }
  
  .carousel-nav.prev {
    left: 16px;
  }
  
  .carousel-nav.next {
    right: 16px;
  }
  
  .play-control {
    width: 40px;
    height: 40px;
    top: 16px;
    right: 16px;
  }
  
  .progress-dots {
    gap: 12px;
    margin-top: 20px;
  }
  
  .progress-dot {
    width: 50px;
    height: 6px;
  }
}

@media (max-width: 480px) {
  .carousel-container {
    margin: 10px auto;
    padding: 0 10px;
  }
  
  .carousel-slide {
    height: 280px;
  }
  
  .carousel-text-content {
    padding: 20px;
  }
  
  .carousel-title {
    font-size: 24px;
    margin-bottom: 6px;
  }
  
  .carousel-subtitle {
    font-size: 14px;
    margin-bottom: 12px;
    line-height: 1.4;
  }
  
  .cta-button {
    padding: 8px 16px;
    font-size: 13px;
  }
  
  .carousel-nav {
    width: 36px;
    height: 36px;
  }
  
  .carousel-nav.prev {
    left: 12px;
  }
  
  .carousel-nav.next {
    right: 12px;
  }
  
  .play-control {
    width: 36px;
    height: 36px;
    top: 12px;
    right: 12px;
  }
  
  .progress-dots {
    gap: 8px;
    margin-top: 15px;
  }
  
  .progress-dot {
    width: 40px;
    height: 5px;
  }
  
  .swipe-hint {
    bottom: 15px;
  }
  
  .hint-text {
    font-size: 12px;
  }
}

/* 动画性能优化 */
@media (prefers-reduced-motion: reduce) {
  .carousel-wrapper,
  .carousel-nav,
  .progress-dot,
  .cta-button,
  .image-container img {
    transition: none;
    animation: none;
  }
  
  .carousel-text-content {
    transform: none;
    opacity: 1;
    animation: none;
  }
}

/* 高对比度模式支持 */
@media (prefers-contrast: high) {
  .carousel-nav {
    background: white;
    border: 2px solid black;
  }
  
  .progress-dot {
    border: 1px solid white;
  }
  
  .cta-button {
    border: 2px solid white;
  }
}

/* 暗色主题支持 */
@media (prefers-color-scheme: dark) {
  .carousel-nav {
    background: rgba(40, 40, 40, 0.95);
    color: white;
  }
  
  .play-control {
    background: rgba(255, 255, 255, 0.2);
  }
  
  .progress-dot {
    background: rgba(255, 255, 255, 0.1);
  }
}

header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}
/* 主内容区域样式 */
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  min-height: calc(100vh - 200px);
}

@media (min-width: 1024px) {
  body {
    display: flex;
    place-items: center;
  }

  #app {
    display: grid;
    grid-template-columns: 1fr;
    padding: 0 2rem;
    width: 100%;
  }

  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
    margin: 0 auto;
    max-width: 1200px;
    width: 100%;
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;
    padding: 1rem 0;
    margin-top: 1rem;
  }
  
  .main-content {
    padding: 2rem;
    justify-content: center;
  }
}

/* 响应式调整 */
@media (max-width: 768px) {
  .main-content {
    padding: 1rem;
    max-width: 100%;
  }
}
</style>
