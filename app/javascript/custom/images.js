function initFormJS() {
  const smallReceiptNFEdit = document.getElementById("expense_receipt_nf");
  const smallReceiptNFNew = document.getElementById("receipt_nf_preview");
  const previewReceiptNF = document.getElementById("preview-image-nf");

  const smallReceiptCardEdit = document.getElementById("expense_receipt_card");
  const smallReceiptCardNew = document.getElementById("receipt_card_preview");
  const previewReceiptCard = document.getElementById("preview-image-card");

  if(smallReceiptNFEdit && previewReceiptNF) {
    smallReceiptNFEdit.addEventListener("click", () => previewReceiptNF.classList.remove("hidden"));
    previewReceiptNF.addEventListener("click", () => previewReceiptNF.classList.add("hidden"));
  }

  if(smallReceiptNFNew && previewReceiptNF) {
    smallReceiptNFNew.addEventListener("click", () => previewReceiptNF.classList.remove("hidden"));
    previewReceiptNF.addEventListener("click", () => previewReceiptNF.classList.add("hidden"));
  }

  if(smallReceiptCardEdit && previewReceiptCard) {
    smallReceiptCardEdit.addEventListener("click", () => previewReceiptCard.classList.remove("hidden"));
    previewReceiptCard.addEventListener("click", () => previewReceiptCard.classList.add("hidden"));
  }

  if(smallReceiptCardNew && previewReceiptCard) {
    smallReceiptCardNew.addEventListener("click", () => previewReceiptCard.classList.remove("hidden"));
    previewReceiptCard.addEventListener("click", () => previewReceiptCard.classList.add("hidden"));
  }
};

document.addEventListener("turbo:load", initFormJS);
document.addEventListener("turbo:render", initFormJS);
