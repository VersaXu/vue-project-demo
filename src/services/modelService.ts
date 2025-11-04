import { httpService } from './http.service';
import type { Model } from '@/types/model';

export const modelService = {
  async getModels(): Promise<Model[]> {
    return httpService.get('/api/models');
  },

  async updateModel(modelId: number, data: Partial<Model>): Promise<Model> {
    return httpService.patch(`/api/models/${modelId}`, data);
  },

  async deleteModel(modelId: number): Promise<void> {
    return httpService.delete(`/api/models/${modelId}`);
  }
};