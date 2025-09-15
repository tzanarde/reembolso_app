document.addEventListener("DOMContentLoaded", () => {
    const roleSelect = document.getElementById("role");
    const managerField = document.getElementById("manager");

    roleSelect.addEventListener("change", () => {
        if (roleSelect.value === "M") {
            managerField.style.display = "none";
        } else {
            managerField.style.display = "block";
        }
    });
});