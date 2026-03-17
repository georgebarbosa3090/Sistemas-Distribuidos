const nomeInput = document.querySelector("#nome");
const btnMensagem = document.querySelector("#btnMensagem");
const mensagem = document.querySelector("#mensagem");
const btnTema = document.querySelector("#btnTema");

let temaEscuro = false;

// Mostrar mensagem personalizada
btnMensagem.addEventListener("click", () => {
    const nome = nomeInput.value.trim();

    if (nome === "") {
        mensagem.textContent = "Digite seu nome para continuar.";
    } else {
        mensagem.textContent = `Bem-vindo(a), ${nome}, ao IFMA! 🎓`;
    }
});

// Alternar tema
btnTema.addEventListener("click", () => {
    temaEscuro = !temaEscuro;
    document.body.classList.toggle("dark", temaEscuro);
});
