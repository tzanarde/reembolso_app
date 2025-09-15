document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("modal");
  const backdrop = document.getElementById("modal-backdrop");

  if (modal && backdrop) {
    modal.style.display = "block";
    backdrop.style.display = "block";
  }

  document.addEventListener("click", (e) => {
    if (e.target && e.target.id === "sign_up_confirm") {
      const modal = document.getElementById("modal");
      const backdrop = document.getElementById("modal-backdrop");
      if (modal && backdrop) {
        modal.style.display = "none";
        backdrop.style.display = "none";
      }
    }
  });
});
