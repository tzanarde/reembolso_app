<script setup lang="ts">
  import { computed, ref } from 'vue';
  import DefaultInput from '../ui/DefaultInput.vue';
  import HorizontalDivider from '../ui/HorizontalDivider.vue';
  import PrimaryButton from '../ui/PrimaryButton.vue';
  import { useRouter } from 'vue-router';
  import axios, { AxiosError } from 'axios';

  const email = ref<string>("");
  const password = ref<string>("");
  const router = useRouter();
  const errorMessage = ref<string | null>(null)

  const login = async (): Promise<void> => {
    errorMessage.value = "";
    try {
      const response = await axios.post<{ token: string }>("http://localhost:3000/users/sign_in",
      { user:
        { email: email.value,
          password: password.value }
      },
      { headers: { "Content-Type": "application/json" } }
    );

    if (response.status === 200) {
      router.push("/expenses")
    }

    } catch (error) {
      const axiosError = error as AxiosError;
      errorMessage.value = axiosError.message
    }
  }

  const invalidCredentials = computed(() => {
    console.log(errorMessage.value);
    return errorMessage.value == "Request failed with status code 401"
  });

</script>

<template>
  <section class="main-section">
      <h1 id="app-title">Sistema de Solicitações de Reembolsos</h1>
      <div class="main-container">
          <div class="login-container">
            <form @submit.prevent="login">
              <div class="inputs-container">
                  <DefaultInput v-model="email" name="email" type="email" placeholder="e-mail"/>
                  <DefaultInput v-model="password" name="password" type="password" placeholder="senha"/>
              </div>
              <p v-if="invalidCredentials">Credenciais inválidas</p>
              <PrimaryButton label="Login" type="submit"/>
            </form>
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
