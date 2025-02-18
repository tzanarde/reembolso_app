<script setup lang="ts">
  defineProps<{
    modelValue: string;
    name: string;
    type?: string;
    placeholder: string;
  }>();

  defineEmits(["update:modelValue"])
</script>

<template>
  <input
    class="default-input"
    :type="type || 'text'"
    :name="name"
    :id="name"
    :placeholder="placeholder"
    :value="modelValue"
    @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
  >
</template>

<style>
.default-input {
  text-align: center;
  height: 40px;
  border-radius: 5px;
  border: 1px solid rgb(192, 192, 192);
  width: 100%;
}
</style>
