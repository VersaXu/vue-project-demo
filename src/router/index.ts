import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import ComateProdView from '@/views/ComateProdView.vue'
import UserListView from '@/views/UserListView.vue'
import SnakeGameView from '@/views/SnakeGameView.vue'
import FlightStatusView from '@/views/FlightStatusView.vue'
import QaView from '@/views/QaView.vue'
import PolicyView from '@/views/PolicyView.vue'
import PolicyDetailView from '@/views/PolicyDetailView.vue'
import TurtleSoupGameView from '@/views/TurtleSoupGameView.vue'
import { useUserStore } from '@/stores/user'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      meta: { requiresAuth: true },
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('@/views/AboutView.vue'), // 确保路径和文件名正确
    },
    {
      path: '/comate-prod',
      name: 'comateProd',
      component: ComateProdView,
      meta: { requiresAuth: true },
    },
    {
      path: '/user-data',
      name: 'user data',
      meta: { requiresAuth: true },
      component: () => UserListView, // 确保路径正确
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/snake-game',
      name: 'snakeGame',
      component: SnakeGameView,
      meta: { requiresAuth: true },
    },
    {
      path: '/flight-status',
      name: 'flightStatus',
      component: FlightStatusView,
      meta: { requiresAuth: true },
    },
    {
      path: '/qa',
      name: 'qa',
      component: QaView,
      meta: { requiresAuth: true },
    },
    {
      path: '/policy',
      name: 'policy',
      component: PolicyView,
      meta: { requiresAuth: true },
    },
    {
      path: '/policy-detail',
      name: 'policyDetail',
      component: PolicyDetailView,
      meta: { requiresAuth: true },
    },
    {
      path: '/model-management',
      name: 'modelManagement',
      component: () => import('@/views/ModelManagementView.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/poc',
      name: 'poc',
      component: () => import('@/views/poc.view.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/turtle-soup',
      name: 'turtleSoup',
      component: TurtleSoupGameView,
      meta: { requiresAuth: true },
    },
  ],
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  if (to.matched.some((record) => record.meta.requiresAuth)) {
    if (!userStore.isAuthenticated) {
      next({
        path: '/login',
        query: { redirect: to.fullPath },
      })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
