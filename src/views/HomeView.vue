<template>
  <div>
    <!-- 使用TheWelcome组件 -->
    <TheWelcome />
  </div>
</template>

<script lang='ts'>
// 引入TheWelcome组件
import TheWelcome from '@/components/TheWelcome.vue';

export default {
  name: 'HomeView',
  // 注册TheWelcome组件
  components: {
    TheWelcome
  }
};
</script>

<style scoped>
/* HomeView的样式 */
</style>