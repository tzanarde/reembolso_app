<script setup lang="ts">
  defineProps<{
    label: string,
    type?: string,
    image: string;
  }>();
</script>

<template>
  <button
    :type="type || 'text'"
    class="small-button">
    <img :src="image" :alt="label">
  </button>
</template>

<style>
.small-button {
  background-color: #fff;
  color: #000;
  width: 30px;
  height: 30px;
  border-radius: 5px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.small-button img {
  width: 20px;
  height: 20px;
}
</style>
