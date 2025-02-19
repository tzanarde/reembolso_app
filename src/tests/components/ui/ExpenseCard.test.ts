import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import ExpenseCard from "../../../components/ui/ExpenseCard.vue";

describe("ExpenseCard.vue", () => {
  it("renders the card with the correct elements", () => {
    const { container } = render(ExpenseCard, {
      props: {
        user_image: "image.png",
        user_name: "User Name",
        date: "12/fev",
        amount: "R$ 100,00",
        description: "Expense Description Text",
        tags: ["tag 1", "tag 2"],
        status: "P"
      }
    });

    const top_info_container = container.querySelector(".top-info");
    const middle_info_container = container.querySelector(".middle-info");
    const bottom_info_container = container.querySelector(".bottom-info");

    expect(top_info_container).toBeInTheDocument();
    expect(middle_info_container).toBeInTheDocument();
    expect(bottom_info_container).toBeInTheDocument();

    const top_info_left_container = top_info_container!.querySelector(".top-info-left");
    expect(top_info_left_container?.querySelector(".user-image")).toBeInTheDocument();
    expect(top_info_left_container?.querySelector(".employee-name")).toBeInTheDocument();
    const top_info_right_container = top_info_container!.querySelector(".top-info-right");
    expect(top_info_right_container?.querySelector(".expense-date")).toBeInTheDocument();
    expect(top_info_right_container?.querySelector(".expense-amount")).toBeInTheDocument();

    expect(middle_info_container?.querySelector("p")).toBeInTheDocument();

    expect(bottom_info_container).not.toBeNull();
    expect(bottom_info_container!.querySelector(".tags")).toBeInTheDocument();
    const tags = bottom_info_container!.querySelectorAll(".tags .tag");
    expect(tags.length).toBe(2);
    tags.forEach(tag => { expect(tag).toBeInTheDocument() });
    expect(bottom_info_container!.querySelector(".pending-status")).toBeInTheDocument();
  });
});
