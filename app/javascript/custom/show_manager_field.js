function initFormJS() {
    const roleSelect = document.getElementById("role");
    const managerField = document.getElementById("manager");

    roleSelect.addEventListener("change", () => {
        if (roleSelect.value === "E") {
            managerField.style.display = "block";
        } else {
            managerField.style.display = "none";
        }

        managerField.selectedIndex = 0;
    });
};

document.addEventListener("turbo:load", initFormJS);
document.addEventListener("turbo:render", initFormJS);