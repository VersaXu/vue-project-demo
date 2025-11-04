<template>
  <div class="model-list-container">
    <h2>添加模型</h2>

    <div class="model-table">
      <div class="model-header">
        <div class="model-name">模型名称</div>
        <div class="model-department">授权部门</div>
        <div class="model-status">状态</div>
        <div class="model-actions">操作</div>
      </div>

      <div v-for="model in models" :key="model.id" class="model-row">
        <div class="model-name">{{ model.name }}</div>
        <div class="model-department">{{ model.department }}</div>
        <div class="model-status">
          <label class="switch">
            <input type="checkbox" :checked="model.enabled" @change="toggleModelStatus(model)" />
            <span class="slider round"></span>
          </label>
        </div>
        <div class="model-actions">
          <button class="action-btn" @click="handleEdit(model.id)">编辑</button>
          <button class="action-btn" @click="handleDelete(model.id)">删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'
import { modelService } from '@/services/modelService'
import type { Model } from '@/types/model'

export default defineComponent({
  name: 'ModelList',
  setup() {
    const models = ref<Model[]>([])
    const loading = ref(false)
    const error = ref<string | null>(null)

    const fetchModels = async () => {
      try {
        loading.value = true
        models.value = await modelService.getModels()
      } catch (err) {
        error.value = 'Failed to load models'
        console.error(err)
      } finally {
        loading.value = false
      }
    }

    const handleEdit = async (modelId: number) => {
      try {
        // In a real app, you might open a modal or navigate to edit page
        console.log('Editing model:', modelId)
      } catch (err) {
        error.value = 'Failed to edit model'
        console.error(err)
      }
    }

    const handleDelete = async (modelId: number) => {
      try {
        if (confirm('Are you sure you want to delete this model?')) {
          await modelService.deleteModel(modelId)
          models.value = models.value.filter((model) => model.id !== modelId)
        }
      } catch (err) {
        error.value = 'Failed to delete model'
        console.error(err)
      }
    }

    const toggleModelStatus = async (model: Model) => {
      try {
        const updatedModel = await modelService.updateModel(model.id, {
          enabled: !model.enabled,
        })
        const index = models.value.findIndex((m) => m.id === model.id)
        if (index !== -1) {
          models.value[index] = updatedModel
        }
      } catch (err) {
        error.value = 'Failed to update model status'
        console.error(err)
        // Revert the UI change if API call fails
        model.enabled = !model.enabled
      }
    }

    onMounted(fetchModels)

    return {
      models,
      loading,
      error,
      handleEdit,
      handleDelete,
      toggleModelStatus,
    }
  },
})
</script>

<style scoped>
.model-list-container {
  padding: 20px;
  flex: 1;
}

.loading-state,
.error-state {
  padding: 20px;
  text-align: center;
  color: #666;
}

.error-state {
  color: #f56c6c;
}

h2 {
  margin-bottom: 20px;
  font-size: 18px;
  color: #333;
}

.model-table {
  width: 100%;
}

.model-header,
.model-row {
  display: flex;
  padding: 12px 0;
  border-bottom: 1px solid #eee;
}

.model-header {
  font-weight: bold;
  color: #666;
}

.model-name {
  flex: 3;
}

.model-department {
  flex: 2;
}

.model-status {
  flex: 1;
}

.model-actions {
  flex: 2;
  display: flex;
  gap: 10px;
}

.action-btn {
  padding: 4px 8px;
  background-color: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
}

/* 开关样式 */
.switch {
  position: relative;
  display: inline-block;
  width: 50px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: '';
  height: 16px;
  width: 16px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #1890ff;
}

input:checked + .slider:before {
  transform: translateX(26px);
}
</style>
