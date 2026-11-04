# 🚛 Sistema de Monitoramento de Frotas de Veículos

Este repositório contém a atividade de desenvolvimento de um aplicativo mobile criado no **Android Studio** utilizando **Flutter** e banco de dados local **SQLite**. O sistema tem como objetivo realizar a gestão e o monitoramento de frotas de veículos voltados para o transporte de cargas.

---

## 📌 Sobre o Projeto

O **Sistema de Monitoramento de Frotas** é uma solução mobile desenvolvida para facilitar o controle de veículos, rotas, motoristas e cargas. A aplicação utiliza o **SQLite** como banco de dados relacional interno, garantindo a retenção e manipulação dos dados de forma rápida, eficiente e offline.

### 🎯 Objetivos da Atividade
- Implementar uma interface intuitiva e responsiva em **Flutter**.
- Estruturar a persistência de dados localmente utilizando a biblioteca **SQLite** (`sqflite`).
- Garantir as operações essenciais de **CRUD** (Create, Read, Update, Delete) para os recursos do sistema.

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** [Dart](https://dart.dev/)
- **Framework:** [Flutter](https://flutter.dev/)
- **IDE:** [Android Studio](https://developer.android.com/studio)
- **Banco de Dados Local:** [SQLite](https://www.sqlite.org/) (via pacote [`sqflite`](https://pub.dev/packages/sqflite))

---

## 🚀 Funcionalidades Principais

- [x] **Cadastro de Veículos:** Registro de caminhões/veículos (placa, modelo, capacidade de carga, status).
- [x] **Cadastro de Motoristas:** Gestão dos dados dos condutores responsáveis pelas entregas.
- [x] **Controle de Cargas e Viagens:** Vinculação de motoristas, veículos e itinerários.
- [x] **Histórico e Status:** Acompanhamento do status do transporte (Em Trânsito, Entregue, Aguardando).
- [x] **Persistência de Dados Local:** Salvamento offline de todas as informações utilizando SQLite.

---

## 📂 Estrutura do Projeto

```text
lib/
├── database/        # Configuração do banco SQLite e DAOs (Data Access Objects)
├── models/          # Modelos de dados (Veículo, Carga, Motorista)
├── screens/         # Interfaces do usuário (Telas de cadastro, listagem, etc.)
├── widgets/         # Componentes reutilizáveis de UI
└── main.dart        # Ponto de entrada da aplicação
```

---

## 🔧 Como Executar o Projeto

### Pré-requisitos
- **Flutter SDK** instalado.
- **Android Studio** configurado com um emulador Android (ou dispositivo físico conectado via Depuração USB).

### Passo a passo

1. **Clone este repositório:**
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   ```

2. **Acesse a pasta do projeto:**
   ```bash
   cd seu-repositorio
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute a aplicação:**
   ```bash
   flutter run
   ```

---

## 📝 Licença

Este projeto foi desenvolvido para fins acadêmicos e pedagógicos. Sinta-se à vontade para utilizar e aprimorar a solução!