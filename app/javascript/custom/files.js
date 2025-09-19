function initFormJS() {
  function previewFile(input, imgElement) {
    const file = input.files[0];
    const reader = new FileReader();

    reader.onloadend = function () {
      imgElement.src = reader.result;
      imgElement.style.display = "block";
    }

    if (file) {
      reader.readAsDataURL(file);
    } else {
      imgElement.src = "";
      imgElement.style.display = "none";
    }
  }

  const nfInput = document.getElementById("receipt_nf_input");
  const nfPreview = document.getElementById("receipt_nf_preview");
  if (nfInput && nfPreview) {
    nfInput.addEventListener("change", () => {
      previewFile(nfInput, nfPreview);
    });
  }

  const cardInput = document.getElementById("receipt_card_input");
  const cardPreview = document.getElementById("receipt_card_preview");
  if (cardInput && cardPreview) {
    cardInput.addEventListener("change", () => {
      previewFile(cardInput, cardPreview);
    });
  }
};

document.addEventListener("turbo:load", initFormJS);
document.addEventListener("turbo:render", initFormJS);
