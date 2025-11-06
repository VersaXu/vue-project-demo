import axios from 'axios';
import API_ENDPOINTS from '@/config/apiConfig';

// 创建HTTP服务实例
const httpService = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api'
});

// 请求拦截器
httpService.interceptors.request.use(
  config => {
    // 从localStorage获取token
    const token = localStorage.getItem('jwt_token');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
httpService.interceptors.response.use(
  response => {
    return response;
  },
  error => {
    // 处理401错误（未授权）
    if (error.response && error.response.status === 401) {
      // 清除token并重定向到登录页
      localStorage.removeItem('jwt_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export { httpService };

// 基础请求方法
export default {
  get: httpService.get,
  post: httpService.post,
  put: httpService.put,
  delete: httpService.delete,
  patch: httpService.patch
};