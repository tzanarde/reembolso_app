document.addEventListener("DOMContentLoaded", () => {
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
});