import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import PrimaryButton from "../../../components/ui/PrimaryButton.vue";

describe("PrimaryButton.vue", () => {
  it("renders the button with the correct label", () => {
    render(PrimaryButton, { props: { label: "Botão" } });

    expect(screen.getByRole("button", { name: /Botão/i })).toBeInTheDocument();
  });

  it("fires click event correctly", async () => {
    const onClick = vi.fn();
    render(PrimaryButton, { props: { label: "Botão" }, attrs: { onClick } });

    const button = screen.getByRole("button", { name: /Botão/i });
    await fireEvent.click(button);

    expect(onClick).toHaveBeenCalled();
  });

  it("must have the correct CSS class", () => {
    render(PrimaryButton, { props: { label: "Botão" } });

    const button = screen.getByRole("button", { name: /Botão/i });
    expect(button).toHaveClass("primary-button");
  });
});
