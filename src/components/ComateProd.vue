<template>
  <div class="ant-card-div">
    <a-row :gutter="24" style="width: 96%">
      <a-col :span="6">
        <a-card title="Comate SaaS版本" :bordered="false">
          <div class="icon-container">
            <CloudServerOutlined />
          </div>
          <a-list class="feature-list">
            <a-list-item class="feature-item">
              <span class="feature-text">直接调用公有云大模型通用能力</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">大模型服务托管在百度云服务上</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">服务效果随模型升级提升</span>
            </a-list-item>
          </a-list>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card title="混合云" :bordered="false">
          <div class="icon-container">
            <ClusterOutlined />
          </div>
          <a-list class="feature-list">
            <a-list-item class="feature-item">
              <span class="feature-text">模型服务托管在百度云服务上</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">应用和RAG部署在本地</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">数据本地存储</span>
            </a-list-item>
          </a-list>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card title="私有化" :bordered="false">
          <div class="icon-container">
            <DeploymentUnitOutlined />
          </div>
          <a-list class="feature-list">
            <a-list-item class="feature-item">
              <span class="feature-text">应用和模型部署在本地部署客户机房</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">数据本地存储，安全运维保障</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">应用功能API开放</span>
            </a-list-item>
          </a-list>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card title="VPC企业专属云" :bordered="false">
          <div class="icon-container">
            <CloudOutlined />
          </div>
          <a-list class="feature-list">
            <a-list-item class="feature-item">
              <span class="feature-text">企业专属网络环境隔离</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">定制化资源配置与扩展</span>
            </a-list-item>
            <a-list-item class="feature-item">
              <span class="feature-text">企业级安全合规与访问控制</span>
            </a-list-item>
          </a-list>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import {
  CloudServerOutlined,
  ClusterOutlined,
  DeploymentUnitOutlined,
  CloudOutlined,
} from '@ant-design/icons-vue'

export default defineComponent({
  name: 'ComateProd',
  components: {
    CloudServerOutlined,
    ClusterOutlined,
    DeploymentUnitOutlined,
    CloudOutlined,
  },
})
</script>

<style scoped>
.ant-card-div {
  background-color: #1f1f1f;
  height: auto;
  width: 80vw;
  padding: 20px;
  margin: 20px auto;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap; /* 允许换行 */
}

/* 媒体查询，确保在大屏幕尺寸下卡片列表仍然居中 */
@media (min-width: 1200px) {
  .ant-card-div {
    justify-content: center; /* 确保在大屏幕下居中 */
  }
}

.ant-card {
  background-color: #2d2d2d;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  transition: all 0.3s ease;
  transform-origin: center;
}

.ant-card-div:hover .ant-card {
  transform: scale(0.9) translateX(15px);
  opacity: 0.7;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.ant-card-div:hover .ant-card:hover {
  transform: scale(1.1) translateY(-8px);
  opacity: 1;
  z-index: 2;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
  border: 2px solid #1890ff;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

:deep(.ant-card-head) {
  border-bottom: 1px solid #3a3a3a;
}

:deep(.ant-card-head-title) {
  color: #1890ff;
  font-size: 18px;
  font-weight: 600;
}

.description {
  color: #d9d9d9;
  margin: 16px 0;
}

.feature-list {
  margin-top: 16px;
}

.feature-item {
  padding: 8px 0;
  border-bottom: 1px solid #3a3a3a;
}

.feature-text {
  color: #8c8c8c;
  line-height: 1.5;
  font-size: 14px;
  word-break: break-word;
}

:deep(.ant-list-item) {
  border-bottom: 1px solid #3a3a3a !important;
}

:deep(.ant-list-item:last-child) {
  border-bottom: none !important;
}

img {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
  margin-bottom: 16px;
}

.icon-container {
  text-align: center;
  margin-bottom: 24px;
  font-size: 48px;
  color: #1890ff;
}
</style>
