import { createRouter, createWebHistory } from "vue-router";
import LoginView from "./views/LoginView.vue";
import ExpensesView from "./views/ExpensesView.vue";

const routes = [
  { path: "/", component: LoginView },
  { path: "/expenses", component: ExpensesView },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
