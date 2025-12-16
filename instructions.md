# 📘 Instruções do Projeto: App Financeiro (MVP V2)

Este documento define o escopo, arquitetura, padrões de código e regras de negócio para o desenvolvimento do App Financeiro.

## 1. Visão Geral
Aplicação de controle financeiro pessoal. O objetivo é registrar receitas e despesas, gerenciar categorias personalizadas e autenticar usuários.
* **Backend:** Lógica de negócios, cálculos e persistência.
* **Frontend:** Interface mobile para gestão financeira.

---

## 2. Tech Stack

### Backend (API)
* **Linguagem:** Java 21 (LTS).
* **Framework:** Spring Boot 3.x.
* **Banco de Dados:** H2 Database (Arquivo: `jdbc:h2:file:./dados_financeiros`).
* **Segurança:** Autenticação simples via Banco de Dados (Sem Spring Security/JWT para o MVP).

### Frontend (Mobile)
* **Framework:** Flutter (Dart).
* **HTTP:** Pacote `http`.
* **Armazenamento Local:** Pacote `shared_preferences` (Para salvar o ID do usuário logado e manter a sessão).
* **Design:** Baseado no "Finzo UI Kit".

---

## 3. Estrutura de Pastas

### Backend
* `/controller`:
    * `UsuarioController`: Login e Registro.
    * `CategoriaController`: Gestão de categorias.
    * `TransacaoController`: Extrato e Dashboard.

### Frontend
* `/screens`:
    * `/auth`: `LoginScreen`, `RegisterScreen`.
    * `/home`: `DashboardScreen`, `AddTransacaoScreen`.
    * `/settings`: `CategoriasScreen`, `AddCategoriaScreen`.

---

## 4. Fluxo de Autenticação (Regra de Negócio)

Para este MVP, não usaremos tokens complexos (JWT). O fluxo será:
1.  **Login:** O App envia Email/Senha -> Backend verifica -> Retorna o Objeto `Usuario` com o ID.
2.  **Sessão:** O Flutter salva esse `id` no celular (SharedPreferences).
3.  **Uso:** Todas as chamadas subsequentes (Dashboard, Criar Transação) leem esse `id` da memória e enviam para a API.

---

## 5. Contrato da API (Novos Endpoints)

Base URL: `http://10.0.2.2:8080`

### Usuários (Auth)
* **POST** `/usuarios/login`
    * Body: `{ "email": "a@a.com", "senha": "123" }`
    * Retorna: JSON do Usuário (com ID) ou Erro 401.
* **POST** `/usuarios/registrar`
    * Body: `{ "nome": "Lucas", "email": "...", "senha": "...", "tipoPlano": "FREE" }`

### Categorias
* **GET** `/categorias` (Lista todas ou filtra por usuário).
* **POST** `/categorias`
    * Body: `{ "nome": "Lazer", "usuario": { "id": 1 } }`
    * *Nota:* Se o `usuario` for nulo, é uma categoria padrão do sistema.

### Transações (Ajuste)
* **GET/POST** `/transacoes...`
    * *Importante:* O Frontend deve parar de enviar o ID `1` fixo e passar a enviar o ID recuperado do Login.

---

## 6. UI/UX & Design System (Adições)

* **Tela de Login:** Fundo escuro, Logo centralizada, Inputs com ícones (✉️, 🔒), Botão "Entrar" verde neon.
* **Tela de Categorias:** Lista simples com botão flutuante (+) para adicionar nova.

---

## 7. Status Atual & Roadmap - {Confira e marque o progresso aqui}
* [x] **Backend:** Configuração Inicial, H2, CORS.
* [x] **Backend:** CRUD Transações e Dashboard.
* [x] **Frontend:** Dashboard com Saldo Real e Lista.
* [x] **Frontend:** Cadastro de Transações (Receita/Despesa).
* [x] **Backend:** Implementar endpoint de Login (`findByEmailAndSenha`).
* [x] **Frontend:** Criar Tela de Login e Registro.
* [x] **Frontend:** Configurar `SharedPreferences` (Lógica de "Lembrar de mim").
* [x] **Backend/Frontend:** Implementar CRUD de Categorias.
* [x] **Geral:** Substituir ID fixo (`1`) pelo ID do usuário logado em todo o app.

## 📝 Funcionalidades (MVP) - {Marque progresso aqui também}

- [x] Cadastro de Usuários (Free/Premium)
- [x] Cadastro de Categorias (Padrão e Personalizadas)
- [x] Lançamento de Receitas e Despesas
- [x] Listagem de Extrato


## 📝 Vantagens do Premium em relação ao Free

### 🆓 Plano FREE (Limitações)
- ❌ **Categorias:** Limitado às categorias padrão do sistema + apenas 1 categoria personalizada
- ❌ **Histórico:** Acesso apenas aos últimos 90 dias de transações
- ❌ **Relatórios:** Apenas um ou dois gráficos
- ❌ **Exportação:** Não pode exportar dados (PDF/Excel)
- ❌ **Metas:** Pode criar apenas uma meta financeira
- ❌ **Alertas:** Sem notificações personalizadas
- ❌ **Contas:** Gerencia apenas 1 conta bancária/carteira
- ❌ **Backup:** Sem backup automático na nuvem

### 💎 Plano PREMIUM (Recursos Exclusivos)

#### 📊 Análises e Relatórios
- ✅ **Gráficos Avançados:** Pizza, barras e linha por categoria, período e comparativos
- ✅ **Insights de IA:** Análise inteligente de gastos com sugestões personalizadas
  - "Você gastou 30% a mais com alimentação este mês"
  - "Baseado no seu padrão, economize R$ 500 reduzindo gastos em lazer"
  - Previsão de gastos futuros baseado em histórico
- ✅ **Relatórios Mensais/Anuais:** Fechamentos automáticos com análise completa

#### 🗂️ Organização
- ✅ **Categorias Ilimitadas:** Crie quantas categorias personalizadas precisar
- ✅ **Subcategorias:** Organize melhor (ex: Transporte → Uber, Gasolina, Manutenção)
- ✅ **Tags/Etiquetas:** Marque transações com tags customizadas
- ✅ **Notas:** Adicione observações em cada transação

#### 👨‍👩‍👧‍👦 Modo Família
- ✅ **Membros Ilimitados:** Adicione cônjuge, filhos ou outros dependentes ( Cada membro pode ou não possuir o seu login próprio, sem custo extra, porém se não tiver preemium tem limitações fora da familia.)
- ✅ **Visualizações Separadas:** Alterne entre gastos pessoais e gastos da família
- ✅ **Permissões:** Controle quem pode adicionar/editar/visualizar transações
- ✅ **Dashboard Família:** Visão consolidada de todos os membros
- ✅ **Responsabilidades:** Atribua transações a membros específicos
- ✅ **Visualização Detalhada:** Filtre os gastos por pessoa da familia (Caso a pessoa tenha gastos atribuidos a ela)

#### 💰 Gestão Financeira Avançada
- ✅ **Múltiplas Contas:** Gerencie várias contas bancárias, carteiras e cartões
- ✅ **Transferências:** Registre transferências entre contas
- ✅ **Metas Financeiras:** Defina objetivos (viagem, carro, casa) e acompanhe progresso
- ✅ **Orçamento por Categoria:** Defina limites de gastos e receba alertas
- ✅ **Transações Recorrentes:** Configure receitas/despesas fixas automáticas
- ✅ **Histórico Ilimitado:** Acesse todo seu histórico financeiro sem restrições

#### 🔔 Alertas e Notificações
- ✅ **Alertas Personalizados:** Notificações quando ultrapassar orçamentos
- ✅ **Lembretes:** Avisos de contas a pagar e recebimentos esperados
- ✅ **Resumo Semanal:** Relatório automático por email/push notification

#### 📤 Exportação e Backup
- ✅ **Exportar Dados:** PDF, Excel, CSV para compartilhar com contador
- ✅ **Backup Automático:** Sincronização na nuvem (Google Drive, iCloud)
- ✅ **Importação:** Importe extratos bancários (OFX, CSV)

#### 🎨 Personalização
- ✅ **Temas Personalizados:** Escolha cores e layout do app
- ✅ **Ícones de Categorias:** Customize ícones para suas categorias
- ✅ **Dashboard Customizável:** Organize widgets conforme preferência

#### 🔐 Segurança
- ✅ **Autenticação Biométrica:** Digital ou reconhecimento facial
- ✅ **Backup Criptografado:** Seus dados protegidos com criptografia de ponta

---

## 💵 Planos e Preços

### 🆓 **Plano FREE**
**R$ 0,00/mês** - Ideal para começar e testar
- 1 usuário
- Funcionalidades básicas com limitações
- Perfeito para quem quer conhecer o app

### 💎 **Plano PREMIUM Individual**
- **Mensal:** R$ 19,90/mês
- **Anual:** R$ 199,90/ano **(economize R$ 38,90)**
- 1 usuário com todos os recursos premium
- Ideal para uso pessoal

### 👨‍👩‍👧 **Plano PREMIUM Família (3 membros)**
- **Mensal:** R$ 39,90/mês **(economize 33% vs 3 contas individuais)**
- **Anual:** R$ 399,90/ano **(economize R$ 199,80 - 2 meses grátis)**
- Até 3 membros com acesso Premium completo
- Cada membro pode ter login próprio
- Dashboard família compartilhado
- **Valor por membro:** R$ 13,30/mês (mensal) ou R$ 11,11/mês (anual)

### 👨‍👩‍👧‍👦 **Plano PREMIUM Família (5 membros)** 🔥 **MAIS VANTAJOSO**
- **Mensal:** R$ 49,90/mês **(economize 50% vs 5 contas individuais)**
- **Anual:** R$ 499,90/ano **(economize R$ 499,60 - 3 meses grátis)**
- Até 5 membros com acesso Premium completo
- Cada membro pode ter login próprio
- Controle total das finanças familiares
- **Valor por membro:** R$ 9,98/mês (mensal) ou R$ 8,33/mês (anual)

### 📊 Comparativo de Economia

| Plano | Mensal | Por Membro/Mês | Economia |
|-------|--------|----------------|----------|
| Individual | R$ 19,90 | R$ 19,90 | - |
| Família 3 | R$ 39,90 | R$ 13,30 | 33% |
| Família 5 | R$ 49,90 | R$ 9,98 | 50% |

### 🎁 Benefícios Adicionais dos Planos Família
- ✅ **Economia significativa** por membro
- ✅ **Gestão centralizada** das finanças familiares
- ✅ **Logins individuais** para cada membro (opcional)
- ✅ **Controle de permissões** por membro
- ✅ **Dashboard consolidado** e visões individuais
- ✅ **Membros FREE fora da família** mantêm limitações em suas contas pessoais

### 💡 Como Funciona o Modo Família?
1. **Administrador** (quem paga) tem controle total
2. **Membros convidados** podem ter conta própria ou usar apenas dentro da família
3. **Permissões configuráveis:** Visualizar, Adicionar, Editar ou Gerenciar
4. **Alternância fácil:** Cada membro alterna entre "Meus Gastos" e "Gastos da Família"
5. **Sem custo extra:** Membros não precisam ter Premium próprio para usar no grupo familiar
