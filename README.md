# 💰 App Financeiro (Backend)

Backend de uma aplicação de controle financeiro pessoal, desenvolvido para fins educativos. O objetivo é gerenciar receitas, despesas e categorias, permitindo ao usuário um controle claro da sua vida financeira.

## 🚀 Tecnologias Utilizadas

* **Linguagem:** Java 21 (LTS)
* **Framework:** Spring Boot 3
* **Banco de Dados:** H2 Database (Memória) / PostgreSQL (Futuro)
* **Gerenciador de Dependências:** Maven
* **Frontend (Planejado):** Flutter

## 📂 Estrutura do Projeto

O projeto segue a arquitetura padrão do Spring Boot:

* `src/main/java/.../model`: Entidades do Banco de Dados (Usuario, Transacao, Categoria).
* `src/main/java/.../repository`: Comunicação com o Banco de Dados.
* `src/main/java/.../controller`: Endpoints da API REST.

## 🛠️ Como rodar o projeto

### Pré-requisitos
* Java 21 instalado.

### Passos
1.  Clone o repositório:
    ```bash
    git clone [https://github.com/Lucas-Bobato/app-financeiro.git](https://github.com/Lucas-Bobato/app-financeiro.git)
    ```
2.  Entre na pasta do projeto e execute via terminal:
    * **Windows:**
        ```cmd
        ./mvnw spring-boot:run
        ```
    * **Linux/Mac:**
        ```bash
        ./mvnw spring-boot:run
        ```

## 📝 Funcionalidades (MVP)

- [ ] Cadastro de Usuários (Free/Premium)
- [ ] Cadastro de Categorias (Padrão e Personalizadas)
- [ ] Lançamento de Receitas e Despesas
- [ ] Listagem de Extrato

---
Desenvolvido como projeto de estudo de Java + Spring Boot.