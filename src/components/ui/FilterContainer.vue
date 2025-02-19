<script setup lang="ts">
    import { ref } from 'vue';
    import SmallButton from './SmallButton.vue';
    import DefaultInput from './DefaultInput.vue';

    const emit = defineEmits(["search-click"]);

    const filterText = ref("");

    const applyFilter = () => {
        emit("search-click", filterText.value);
    };
</script>

<template>
    <div class="filter-container">
        <SmallButton :label="'filter'" :type="'text'" :image="'/filter.png'" />
        <div class="search-container">
            <DefaultInput v-model="filterText" name="filter" type="text" placeholder="Digite sua busca..."/>
            <SmallButton @eventClick="applyFilter" :label="'search'" :type="'text'" :image="'/search.svg'" />
        </div>
    </div>
</template>

<style>
.filter-container {
    display: flex;
    flex-direction: row;
    width: 100%;
    gap: 10px;
}

.default-input {
    text-align: center;
    height: 40px;
    border-radius: 5px;
    border: 1px solid rgb(192, 192, 192);
    width: 100%;
}

.search-container {
    display: flex;
    flex-direction: row;
    gap: 2px;
    width: 100%;
}
</style>
