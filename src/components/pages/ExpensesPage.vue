<script setup lang="ts">
    import { onMounted, ref } from 'vue';
    import ExpenseCard from '../ui/ExpenseCard.vue';
    import FilterContainer from '../ui/FilterContainer.vue';
    import axios, { AxiosError } from 'axios';
    import router from '../../router';

    const errorMessage = ref<string | null>(null)

    const token = sessionStorage.getItem("token");

    const expenses = ref<Expense[]>([]);

    const textFilter = ref<string>("");

    if (!token) {
        router.push("/");
    }

    interface Expense {
        id: number
        description: string;
        date: string;
        amount: string;
        location: string;
        status: string;
        manager: string;
        employee: string;
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000);

    const getExpenses = async (): Promise<void> => {
        errorMessage.value = "";
        try {
            const response = await axios.get<{ expenses: Expense[] }>("http://localhost:3000/expenses",
            { headers: { "Content-Type": "application/json",
                        "ACCEPT": "application/json",
                        "Authorization": `Bearer ${token}` } }
            );

            clearTimeout(timeoutId);
            expenses.value = response.data.expenses;

        } catch (error) {
            const axiosError = error as AxiosError;
            errorMessage.value = axiosError.message
        }
    }

    const getExpensesFiltered = async (filterValue: string): Promise<void> => {
        textFilter.value = filterValue;
        errorMessage.value = "";
        console.log(textFilter.value);
        try {
            const response = await axios.get<{ expenses: Expense[] }>("http://localhost:3000/expenses",
            { headers: { "Content-Type": "application/json",
                        "ACCEPT": "application/json",
                        "Authorization": `Bearer ${token}` },
              params: { text_filter: textFilter.value }
            }
            );

            expenses.value = response.data.expenses;

        } catch (error) {
            const axiosError = error as AxiosError;
            errorMessage.value = axiosError.message
        }
    }

    onMounted(() => {
        getExpenses();
    });
</script>

<template>
    <div class="page-container">
        <section class="top-section">
            <h1 class="screen-title">Minhas Solicitações Pendentes</h1>
            <div class="user-button">
                <img src="/user.png" alt="Imagem do Usuário">
            </div>
        </section>

        <section class="filter-section">
            <FilterContainer @search-click="getExpensesFiltered" />
        </section>

        <section class="cards-section">
            <div class="main-container">
                <ExpenseCard
                    v-for="(expense, index) in expenses"
                    :key="index"
                    :user_image="expense.user_image"
                    :user_name="expense.user_name"
                    :date="expense.date"
                    :amount="expense.amount"
                    :description="expense.description"
                    :status="expense.status"
                    :tags="expense.tags"
                />
            </div>
        </section>
    </div>
</template>

<style>
.page-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.cards-section {
    display: flex;
    flex-direction: column;
    justify-content: start;
    align-items: start;
}

.main-container {
    background-color: rgb(218, 218, 218);
    width: 100%;
    height: 100%;
    border-radius: 15px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 5px;
}
</style>
