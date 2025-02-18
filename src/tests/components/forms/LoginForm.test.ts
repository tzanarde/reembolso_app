import { render, screen, fireEvent, waitFor } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import LoginForm from "../../../components/forms/LoginForm.vue";
import axios from "axios";
import { createRouter, createWebHistory } from "vue-router";

vi.mock("axios");

const router = createRouter({
  history: createWebHistory(),
  routes: [{ path: "/expenses", component: { template: "<div>Expenses</div>" } }],
});

describe("LoginForm.vue - UI", () => {
  it("renders inputs and buttons correctly", () => {
    render(LoginForm);

    expect(screen.getByPlaceholderText("e-mail")).toBeInTheDocument();
    expect(screen.getByPlaceholderText("senha")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Login" }));

  });

  it("allow user to fill email and password fields", async () => {
    render(LoginForm);

    const emailInput = screen.getByPlaceholderText("e-mail");
    const passwordInput = screen.getByPlaceholderText("senha");

    await fireEvent.update(emailInput, "teste@email.com");
    await fireEvent.update(passwordInput, "password");

    expect(emailInput).toHaveValue("teste@email.com");
    expect(passwordInput).toHaveValue("password");
  });
});

describe("LoginForm.vue - Validation", () => {
  it("shows error message when logins fails", async () => {
    (axios.post as vi.Mock).mockRejectedValueOnce(new Error("Request failed with status code 401"));

    render(LoginForm);

    await fireEvent.update(screen.getByPlaceholderText("e-mail"), "teste@email.com");
    await fireEvent.update(screen.getByPlaceholderText("senha"), "password");
    await fireEvent.click(screen.getByRole("button", { name: "Login" }));

    await waitFor(() => {
      expect(screen.getByText("Credenciais inválidas")).toBeInTheDocument();
    });
  });
});

describe("LoginForm.vue - Login and Redirect", () => {
  it("redirects to /expenses when the login is successfull", async () => {
    (axios.post as vi.Mock).mockResolvedValueOnce({
      status: 200,
      data: { token: "fake-token" },
    });

    render(LoginForm, {
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
