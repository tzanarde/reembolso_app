<script setup lang="ts">
import { computed, ref } from 'vue';

  const props = defineProps<{
    user_image: string,
    user_name: string,
    date: string,
    amount: string,
    description: string,
    tags: string[],
    status: string
  }>();

  const statusClass = computed(() => {
    return props.status === "P"
      ? "pending-status"
      : props.status === "A"
      ? "approved-status"
      : props.status === "D"
      ? "declined-status"
      : "ERROR";
  });

  const statusDescription = computed(() => {
    return props.status === "P"
      ? "Pendente"
      : props.status === "A"
      ? "Aprovado"
      : props.status === "D"
      ? "Negado"
      : "ERROR";
  });
</script>

<template>
  <div class="expense-card">
    <div class="top-info">
      <div class="top-info-left">
        <div class="user-image">
          <img :src="user_image" alt="Imagem do Usuário">
        </div>
        <p class="employee-name">{{ user_name }}</p>
      </div>
      <div class="top-info-right">
        <p class="expense-amount">{{ amount }}</p>
        <p class="expense-date">{{ date }}</p>
      </div>
    </div>

    <div class="middle-info">
      <p>{{ description }}</p>
    </div>

    <div class="bottom-info">
      <div class="tags">
        <div class="tag" v-for="(tag, index) in tags" :key="index">{{ tag }}</div>
      </div>
      <p class="status" :class=statusClass>{{ statusDescription }}</p>
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

.top-info-left {
  display: flex;
  flex-direction: row;
  gap: 10px;
}

.user-image {
  width: 50px;
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
  /* width: 40%; */
  text-align: start;
  font-weight: 700;
  font-size: 16px;
}

.top-info-right {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.expense-date {
  text-align: end;
  font-weight: 700;
  padding: 0;
  margin: 0;
}

.expense-amount {
  text-align: center;
  color: rgb(189, 37, 37);
  font-weight: 700;
  padding: 0;
  margin: 0;
  /* margin-top: 10px; */
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
  width: 70%;
  display: flex;
  flex-direction: row;
  justify-content: start;
  align-items: end;
  gap: 5px;
}

.tag {
  background-color: rgb(190, 215, 238);
  padding: 4px 8px;
  border-radius: 5px;
  font-size: 12px;
  height: 18px;
}

.status {
  width: 30%;
  text-align: end;
}

.pending-status {
  color: #ffbb00;
}

.approved-status {
  color: #43a561;
}

.declined-status {
  color: #ac3535;
}
</style>
