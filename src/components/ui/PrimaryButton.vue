<script setup lang="ts">
  defineProps<{
    label: string,
    type?: string;
  }>();
</script>

<template>
  <button
    :type="type || 'text'"
    class="primary-button">
    {{ label }}
  </button>
</template>

<style>
.primary-button {
background-color: rgb(51, 167, 212);
text-align: center;
width: 100%;
height: 40px;
border-radius: 5px;
border-radius: 5px;
border: 0px;
cursor: pointer;
font-size: 18px;
color: #fff;
}
</style>
