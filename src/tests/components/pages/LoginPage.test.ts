import { render, screen, fireEvent, waitFor } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import LoginPage from "../../../components/pages/LoginPage.vue";
import axios from "axios";
import { createRouter, createWebHistory } from "vue-router";

vi.mock("axios");

const router = createRouter({
  history: createWebHistory(),
  routes: [{ path: "/expenses", component: { template: "<div>Expenses</div>" } }],
});

describe("LoginPage.vue - UI", () => {
  it("renders inputs and buttons correctly", () => {
    render(LoginPage);

    expect(screen.getByPlaceholderText("e-mail")).toBeInTheDocument();
    expect(screen.getByPlaceholderText("senha")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Login" }));

  });

  it("allow user to fill email and password fields", async () => {
    render(LoginPage);

    const emailInput = screen.getByPlaceholderText("e-mail");
    const passwordInput = screen.getByPlaceholderText("senha");

    await fireEvent.update(emailInput, "teste@email.com");
    await fireEvent.update(passwordInput, "password");

    expect(emailInput).toHaveValue("teste@email.com");
    expect(passwordInput).toHaveValue("password");
  });
});

describe("LoginPage.vue - Validation", () => {
  it("shows error message when logins fails", async () => {
    (axios.post as vi.Mock).mockRejectedValueOnce(new Error("Request failed with status code 401"));

    render(LoginPage);

    await fireEvent.update(screen.getByPlaceholderText("e-mail"), "teste@email.com");
    await fireEvent.update(screen.getByPlaceholderText("senha"), "password");
    await fireEvent.click(screen.getByRole("button", { name: "Login" }));

    await waitFor(() => {
      expect(screen.getByText("Credenciais inválidas")).toBeInTheDocument();
    });
  });
});

describe("LoginPage.vue - Login and Redirect", () => {
  it("redirects to /expenses when the login is successfull", async () => {
    (axios.post as vi.Mock).mockResolvedValueOnce({
      status: 200,
      data: { token: "fake-token" },
    });

    render(LoginPage, {
      global: {
        plugins: [router],
        stubs: { RouterLink: true },
      },
    });

    await fireEvent.update(screen.getByPlaceholderText("e-mail"), "teste@email.com");
    await fireEvent.update(screen.getByPlaceholderText("senha"), "password");
    await fireEvent.click(screen.getByRole("button", { name: "Login" }));

    await waitFor(() => {
      expect(router.currentRoute.value.path).toBe("/expenses");
    });
  });
});
