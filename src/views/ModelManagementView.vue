<template>
  <ModelManagementLayout />
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ModelManagementLayout from '@/components/ModelManagementLayout.vue';

export default defineComponent({
  name: 'ModelManagementView',
  components: {
    ModelManagementLayout
  }
});
</script>