document.addEventListener("click", (event) => {
  if (event.target.closest("#filter-button")) {
    event.preventDefault();
    const filterDiv = document.getElementById("modal-filter");
    const filterBackdrop = document.getElementById("modal-backdrop");
    if (filterDiv) filterDiv.classList.toggle("hidden");
    if (filterBackdrop) filterBackdrop.classList.toggle("hidden");
  }

  if (event.target.closest("#classify-button")) {
    event.preventDefault();
    const classifyDiv = document.getElementById("container-classify");
    if (classifyDiv) classifyDiv.classList.toggle("hidden");
  }
});
