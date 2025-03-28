let aux = 0;

/* Função que faz o sino alterar quando clicado */
document.getElementById('sino').addEventListener('click', (event) => {
    /* Evita que a página atualize */
    event.preventDefault();

    const link = document.getElementById('sino');
    link.innerHTML = '';

    const img = document.createElement('img');

    if (aux == 0) {
        img.src = 'assets/sino-selecionado.png';
        img.alt = 'Sino de notificações selecionado';
        aux = 1;
    } else {
        img.src = 'assets/sino.png';
        img.alt = 'Sino de notificações';
        aux = 0;
    }

    img.id = 'sinoImg';

    link.append(img);
});

document.getElementById('criar').addEventListener('click', (event) => {
    event.preventDefault();

    const modal = document.getElementById("meuModal");
    const openModal = document.getElementById("criarProjeto");
    const closeModal = document.getElementById("fecharModal");

    // Abre o modal
    openModal.onclick = () => {
        modal.style.display = "block";
    }

    // Fecha o modal
    closeModal.onclick = () => {
        modal.style.display = "none";
    }

    // Fecha o modal ao clicar fora do conteúdo
    window.onclick = (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
});
