const profilLogo = document.querySelectorAll(".profil-logo");
const roleAdd = document.querySelectorAll(".role-add");
const input = document.querySelectorAll(".message input");
const modal = document.querySelector(".modal-container");
const helpBtn = document.querySelector(".help-btn");
const feedbackInput = document.querySelector("#feedback-input");

const randomHexColor = () => {
  return "#" + Math.floor(Math.random() * 16777215).toString(16);
};

const ramdomWord = () => {
  const words = [
    "I use Arch btw",
    "How to exit Vim?",
    "\"JavaScript sucks\" - Sun Tzu, probably",
    "42"
  ];
  return words[Math.floor(Math.random() * words.length)];
};

const addRole = (card) => {
  const role = document.createElement("div");
  const roleColor = document.createElement("div");
  const roleText = document.createElement("p");
  role.classList.add("role");
  roleColor.classList.add("role-color");
  roleColor.style.backgroundColor = randomHexColor();
  roleText.innerText = ramdomWord();
  role.append(roleColor, roleText);
  card.parentElement.append(role, card);
  removeRole();
};

const removeRole = () => {
  const roles = document.querySelectorAll(".role-color");
  roles.forEach((role) => {
    role.addEventListener("click", (e) => {
      e.target.parentElement.remove();
    });
  });
};

const toggleModal = () => {
  modal.classList.toggle("active");
};

profilLogo.forEach((logo) => {
  logo.addEventListener("click", toggleModal);
});

roleAdd.forEach((add) => {
  add.addEventListener("click", () => {
    addRole(add);
  });
});

input.forEach((input) => {
  input.addEventListener("keyup", (e) => {
    if (e.key === "Enter") {
      input.value = "";
      input.blur();
      toggleModal();
    }
  });
});


removeRole();
