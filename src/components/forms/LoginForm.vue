<script setup lang="ts">
  import { ref } from 'vue';
  import DefaultInput from '../ui/DefaultInput.vue';
  import HorizontalDivider from '../ui/HorizontalDivider.vue';
  import PrimaryButton from '../ui/PrimaryButton.vue';

  const email = ref("");
  const password = ref("");
</script>

<template>
  <section class="main-section">
      <h1 id="app-title">Sistema de Solicitações de Reembolsos</h1>
      <div class="main-container">
          <div class="login-container">
              <div class="inputs-container">
                  <DefaultInput v-model="email" name="email" type="email" placeholder="e-mail"/>
                  <DefaultInput v-model="password" name="password" type="password" placeholder="senha"/>
              </div>
              <PrimaryButton label="Login"/>
          </div>
          <HorizontalDivider />
          <div class="signup-container">
              <p class="default-text">Não tem usuário?</p>
              <PrimaryButton label="Cadastrar"/>
          </div>
      </div>
  </section>
</template>

<style>
#main-section {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin: 0;
  gap: 60px
}

#app-title {
  width: 300px;
  text-align: center;
  color: rgb(5, 111, 153);
  font-size: 25px;
}

.login-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 100%;
}

.signup-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
}

.inputs-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.main-container {
  background-color: rgb(218, 218, 218);
  padding: 50px 20px;
  width: 250px;
  border-radius: 15px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  justify-content: center;
  align-items: center;
}
</style>
