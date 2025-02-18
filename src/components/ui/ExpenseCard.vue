<script setup lang="ts">
  defineProps<{
    user_image: string,
    user_name: string,
    date: string,
    amount: string,
    description: string,
    tags: string[]
  }>();
</script>

<template>
  <div class="expense-card">
    <div class="top-info">
      <div class="user-image">
        <img :src="user_image" alt="Imagem do Usuário">
      </div>
      <p class="employee-name">{{ user_name }}</p>
      <p class="expense-date">{{ date }}</p>
      <p class="expense-amount">{{ amount }}</p>
    </div>

    <div class="middle-info">
      <p>{{ description }}</p>
    </div>

    <div class="bottom-info">
      <div class="tags">
        <div class="tag" v-for="(tag, index) in tags" :key="index">{{ tag }}</div>
      </div>
    </div>
  </div>
</template>

<style>
.expense-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  background-color: #fff;
  padding: 10px;
  max-height: 200px;
  border-radius: 10px;
}

.top-info {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  gap: 10px;
}

.user-image {
  width: 10%;
  text-align: center;
  background-color: rgb(52, 123, 189);
  min-width: 40px;
  min-height: 40px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.user-image img {
  width: 30px;
  height: 30px;
}

.employee-name {
  width: 40%;
  text-align: start;
  font-weight: 700;
  font-size: 14px;
}

.expense-date {
  width: 20%;
  text-align: end;
  font-weight: 700;
}

.expense-amount {
  width: 35%;
  text-align: center;
  color: rgb(189, 37, 37);
  font-weight: 700;
}

.bottom-info {
  display: flex;
  flex-direction: row;
  justify-content: start;
  align-items: start;
  width: 100%;
}

.tags {
  background-color: #fff;
  height: 40px;
  display: flex;
  flex-direction: row;
  justify-content: start;
  align-items: start;
  padding: 5px;
  gap: 5px;
}

.tag {
  background-color: rgb(190, 215, 238);
  padding: 4px 8px;
  border-radius: 5px;
  font-size: 12px;
  height: 18px;
}
</style>
