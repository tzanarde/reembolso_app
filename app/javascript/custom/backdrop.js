document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("modal");
  const backdrop = document.getElementById("modal-backdrop");

  if (modal && backdrop) {
    modal.style.display = "flex";
    backdrop.style.display = "flex";
  }

  document.addEventListener("click", (e) => {
    if (e.target && e.target.id === "confirm_button") {
      const modal = document.getElementById("modal");
      const backdrop = document.getElementById("modal-backdrop");
      if (modal && backdrop) {
        modal.style.display = "none";
        backdrop.style.display = "none";
      }
    }
  });
});
