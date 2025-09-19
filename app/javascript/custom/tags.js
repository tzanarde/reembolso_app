function initFormJS() {
  const addTagButton = document.getElementById("add-tag");
  const tagInput = document.getElementById("tag_input");
  const tagsBox = document.getElementById("tags-box");
  const hiddenInput = document.getElementById("tags_list");
  const existentTags = tagsBox.querySelectorAll("span");
   
  let tags = [];
  existentTags.forEach(existentTag => {
    tags.push(existentTag.textContent);
  });

  addTagButton.addEventListener("click", addTag);

  tagInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      addTag();
    }
  });

  tagsBox.addEventListener("click", (e) => {
    if (e.target.classList.contains("tag")) {
      const tagToRemove = e.target.textContent;
      tags = tags.filter(t => t !== tagToRemove);
      updateTags();
    }
  });

  function addTag() {
      const tag = tagInput.value.trim();
      if (tag && !tags.includes(tag)) {
        tags.push(tag);
        updateTags();
      }
      tagInput.value = "";
      tagInput.focus();
    }

  function updateTags() {
    tagsBox.innerHTML = "";

    tags.forEach((tag, index) => {
      const span = document.createElement("span");
      span.className = "tag";
      span.textContent = tag;
      span.id = "tag_" + (index + 1);
      tagsBox.appendChild(span);
    });

    document.querySelectorAll("#tags-list input[type=hidden]").forEach(el => el.remove());

    tags.forEach((tagId, index) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "expense[tag_names][]";
      input.value = tagId;
      input.id = "expense_tag_names_" + (index + 1);
      document.getElementById("tags-list").appendChild(input);
    });
  }
}

document.addEventListener("turbo:load", initFormJS);
document.addEventListener("turbo:render", initFormJS);
