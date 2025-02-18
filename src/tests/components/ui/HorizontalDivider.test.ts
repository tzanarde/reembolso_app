import { render } from "@testing-library/vue";
import { describe, it, expect } from "vitest";
import HorizontalDivider from "../../../components/ui/HorizontalDivider.vue";

describe("HorizontalDivider.vue", () => {
  it("renders the button with the correct label", () => {
    render(HorizontalDivider);

    const {container} = render(HorizontalDivider);
    expect(container.querySelector(".horizontal-divider")).toBeInTheDocument();
  });

  it("must have the correct CSS class", () => {
    render(HorizontalDivider);

    const {container} = render(HorizontalDivider);
    expect(container.querySelector("div")).toHaveClass("horizontal-divider");
  });
});
