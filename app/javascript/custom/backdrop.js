document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("modal");
  const backdrop = document.getElementById("modal-backdrop");
  const closeButton = document.getElementById("sign_up_confirm");

  if (modal && backdrop) {
    modal.style.display = "block";
    backdrop.style.display = "block";

    closeButton.addEventListener("click", () => {
      modal.style.display = "none";
      backdrop.style.display = "none";
    });
  }
});
