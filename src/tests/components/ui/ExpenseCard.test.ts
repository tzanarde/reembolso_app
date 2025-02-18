import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import ExpenseCard from "../../../components/ui/ExpenseCard.vue";

describe("ExpenseCard.vue", () => {
  it("renders the card with the correct elements", () => {
    render(ExpenseCard, {
      props: {
        user_image: "image.png",
        user_name: "User Name",
        date: "12/fev",
        amount: "R$ 100,00",
        description: "Expense Description Text",
        tags: ["tag 1", "tag 2"]
      }
    });

    const { container } = render(ExpenseCard);
    expect(container.querySelector(".top-info")).toBeInTheDocument();
    expect(container.querySelector(".middle-info")).toBeInTheDocument();
    expect(container.querySelector(".bottom-info")).toBeInTheDocument();

    const top_info_container = container.querySelector(".top-info");
    expect(top_info_container?.querySelector(".expense-date")).toBeInTheDocument();
    expect(top_info_container?.querySelector(".expense-amount")).toBeInTheDocument();

    const middle_info_container = container.querySelector(".middle-info");
    expect(middle_info_container?.querySelector("p")).toBeInTheDocument();

    const bottom_info_container = container.querySelector(".bottom-info");
    expect(bottom_info_container?.querySelector(".tags")).toBeInTheDocument();

    const tags_container = container.querySelectorAll(".tags > div");
    expect(tags_container.length).toBe(2);
  });

  it("must have the correct CSS classes", () => {
    render(ExpenseCard, {
      props: {
        user_image: "image.png",
        user_name: "User Name",
        date: "12/fev",
        amount: "R$ 100,00",
        description: "Expense Description Text",
        tags: ["tag 1", "tag 2"]
      }
    });

    const { container } = render(ExpenseCard);
    expect(container).toHaveClass("expense-card");

    const top_info_container = container.querySelector(".top-info");
    expect(top_info_container).toHaveClass("top-info");

    const middle_info_container = container.querySelector(".middle-info");
    expect(middle_info_container).toHaveClass("middle-info");

    const bottom_info_container = container.querySelector(".bottom-info");
    expect(bottom_info_container).toHaveClass("bottom-info");

    const top_info_p = container.querySelectorAll(".top-info p");
    expect(top_info_p[0]).toHaveClass("expense-date");
    expect(top_info_p[1]).toHaveClass("expense-amount");

    const bottom_info_div = container.querySelectorAll(".bottom-info div");
    expect(bottom_info_div).toHaveClass("tags");

    const bottom_info_div_divs = container.querySelectorAll(".bottom-info div div");
    expect(bottom_info_div_divs[0]).toHaveClass("tag");
    expect(bottom_info_div_divs[1]).toHaveClass("tag");
  });
});
