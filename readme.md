# Sistema de Gestão e Monitoramento de Frotas 🚛

Projeto desenvolvido para a disciplina de Engenharia de Software, com a proposta de criar uma aplicação mobile para auxiliar no gerenciamento e acompanhamento de frotas de veículos.

A ideia é reunir em um só lugar informações sobre veículos, motoristas e operações de transporte, facilitando a organização e o acesso aos dados da frota.

## Sobre o projeto

O sistema foi desenvolvido utilizando Flutter e Dart, com integração ao Firebase Firestore para armazenamento das informações.

A aplicação tem como foco facilitar tarefas que fazem parte da rotina de uma empresa de transporte, permitindo organizar os dados da frota e acompanhar as informações relacionadas aos veículos e às viagens.

## Funcionalidades

O projeto contempla as seguintes funcionalidades:

- **Cadastro de veículos:** registro de informações como placa, modelo e capacidade de carga.
- **Cadastro de motoristas:** organização dos dados dos profissionais responsáveis pelos veículos.
- **Controle de cargas e viagens:** associação entre veículos, motoristas e operações de transporte.
- **Acompanhamento de status:** identificação da situação das viagens, como em trânsito, entregue ou aguardando.
- **Armazenamento de dados:** utilização do Firebase Firestore para guardar e consultar as informações.

## Tecnologias utilizadas

| Tecnologia | Utilização |
|---|---|
| Flutter | Desenvolvimento da aplicação mobile |
| Dart | Linguagem de programação |
| Firebase Core | Integração com os serviços Firebase |
| Cloud Firestore | Banco de dados na nuvem |
| Android Studio | Ambiente de desenvolvimento |

## Organização do projeto

A estrutura principal do projeto está organizada dentro da pasta `lib`, onde ficam os arquivos responsáveis pelo funcionamento da aplicação.

```text
engenharia-de-software/
│
├── lib/
│   └── Código-fonte da aplicação
│
├── pubspec.yaml
└── readme.md
```

## Como executar o projeto

Para executar a aplicação em sua máquina, é necessário ter o Flutter instalado e configurado.

**1. Clone o repositório**

```bash
git clone https://github.com/CarlosRGV-dev/engenharia-de-software.git
```

**2. Entre na pasta do projeto**

```bash
cd engenharia-de-software
```

**3. Instale as dependências**

```bash
flutter pub get
```

**4. Configure o Firebase**

Configure um projeto Firebase e conecte a aplicação ao Firestore. Verifique também se os arquivos de configuração da plataforma escolhida estão presentes.

**5. Execute a aplicação**

```bash
flutter run
```

## Objetivo acadêmico

Este projeto faz parte das atividades da disciplina de Engenharia de Software e tem como objetivo colocar em prática os conhecimentos adquiridos durante o desenvolvimento de uma aplicação, desde sua organização até a implementação de suas funcionalidades.

## Repositório

O código-fonte e as atualizações do projeto estão disponíveis no GitHub:

[engenharia-de-software](https://github.com/CarlosRGV-dev/engenharia-de-software)
