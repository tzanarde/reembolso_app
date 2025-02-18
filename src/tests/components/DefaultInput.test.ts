import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect } from "vitest";
import DefaultInput from "../../components/ui/DefaultInput.vue";

describe("DefaultInput.vue", () => {
  it("renders the input correctly", () => {
    render(DefaultInput, { props: { modelValue: "input_value", name: "input", type: "text", placeholder: "input_value" } });

    const input = screen.getByPlaceholderText("input_value")
    expect(input).toBeInTheDocument();
  });

  it("accepts typing and updates the value", async () => {
    const { emitted } = render(DefaultInput, { props: { modelValue: "input_value", name: "input", type: "text", placeholder: "input_value" } });

    const input = screen.getByPlaceholderText("input_value")
    await fireEvent.update(input, "New value");

    expect(emitted()["update:modelValue"]).toBeTruthy();
    expect(emitted()["update:modelValue"][0]).toEqual(["New value"]);
  });

  it("must have the correct type", () => {
    render(DefaultInput, { props: { modelValue: "input_value", name: "input", type: "text", placeholder: "input_value" } });

    const input = screen.getByPlaceholderText("input_value")
    expect(input).toHaveAttribute("type", "text");
  });
});
