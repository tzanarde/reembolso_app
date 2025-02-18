<script setup lang="ts">
  defineProps<{ label: string }>();
</script>

<template>
  <h1 class="page-title">{{ label }}</h1>
</template>

<style>
.page-title {
  width: 100%;
  text-align: start;
  font-size: 20px;
}
</style>
