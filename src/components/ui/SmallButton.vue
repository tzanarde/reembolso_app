<script setup lang="ts">
  defineProps<{
    label: string,
    type?: string,
    image: string;
  }>();

  const emit = defineEmits(["eventClick"]);
</script>

<template>
  <button
    :type="type || 'text'"
    class="small-button"
    @click="emit('eventClick')">
    <img
      :src="image || ''"
      :alt="label">
  </button>
</template>

<style>
.small-button {
  background-color: #fff;
  color: #000;
  width: 40px;
  height: 40px;
  border-radius: 5px;
  display: flex;
  justify-content: center;
  align-items: center;
  border: 1px solid #d1d1d1;
}

.small-button img {
  width: 20px;
  height: 20px;
}
</style>
