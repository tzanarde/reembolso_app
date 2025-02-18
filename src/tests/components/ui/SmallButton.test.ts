import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import SmallButton from "../../../components/ui/SmallButton.vue";

describe("SmallButton.vue", () => {
  it("renders the button correctly", () => {
    render(SmallButton, { props: { image: "image.svg" } });

    expect(screen.getByRole("button")).toBeInTheDocument();
  });

  it("fires click event correctly", async () => {
    const onClick = vi.fn();
    render(SmallButton, { props: { image: "image.svg" }, attrs: { onClick } });

    const button = screen.getByRole("button");
    await fireEvent.click(button);

    expect(onClick).toHaveBeenCalled();
  });

  it("must have the correct CSS class", () => {
    render(SmallButton, { props: { image: "image.svg" } });

    const button = screen.getByRole("button");
    expect(button).toHaveClass("small-button");
  });
});
