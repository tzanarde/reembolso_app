import { render, screen, fireEvent } from "@testing-library/vue";
import { describe, it, expect, vi } from "vitest";
import PageTitle from "../../../components/ui/PageTitle.vue";

describe("PageTitle.vue", () => {
  it("renders the title correctly", () => {
    render(PageTitle, { props: { label: "Page Title" } });

    expect(screen.getByRole("heading", { level: 1 })).toBeInTheDocument();
  });

  it("must have the correct CSS class", () => {
    render(PageTitle, { props: { label: "Page Title" } });

    const heading = screen.getByRole("heading", { level: 1 });
    expect(heading).toHaveClass("page-title");
  });
});
