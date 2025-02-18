import { createRouter, createWebHistory } from "vue-router";
import Blank from "./components/Blank.vue";

const routes = [
  { path: "/", component: Blank },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
