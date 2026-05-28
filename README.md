<img width="1919" height="1003" alt="Captura de tela 2026-05-27 223752" src="https://github.com/user-attachments/assets/28ce8ce3-ff23-406f-8bb1-290c95fdc8cc" />



# Copa do Mundo 2026 - Plataforma de Acompanhamento



Plataforma full-stack desenvolvida para o acompanhamento e gestão de dados da Copa do Mundo 2026. O sistema oferece uma interface responsiva focada na experiência do usuário, com permissões administrativas para todos os usuários e painéis de dados em tempo real.



## Arquitetura e Estrutura



O projeto front-end foi construído utilizando **Flutter** e segue uma arquitetura modular baseada em *Features* (Design Orientado a Domínio), garantindo escalabilidade, separação de responsabilidades e facilidade de manutenção.



A estrutura de diretórios principal está organizada da seguinte forma:



* **`lib/core/`**: Configurações globais, temas e integrações de rede (`ApiService`).

* **`lib/features/`**: Módulos independentes da aplicação.

    * `auth/`: Autenticação, login e cadastro.

    * `campeonato/`: Gestão de partidas, placares e árvore de eliminatórias (chaveamento).

    * `dashboard/`: Painel central com estatísticas em tempo real e notícias.

    * `equipes/`: Listagem e gestão das seleções participantes.

    * `jogadores/`: Listagem e gestão dos atletas.



O back-end é suportado por uma API REST desenvolvida em **Python** (Flask/FastAPI), responsável por fornecer os dados das partidas, jogadores e estatísticas gerais.



## Funcionalidades Principais



* **Permissões Administrativas para Todos**: 

    * Todos os usuários podem editar seleções, jogadores, atualizar placares, gerenciar o chaveamento e publicar notícias.

* **Dashboard Interativo**: Visão geral do torneio com indicadores quantitativos (total de seleções, jogadores, partidas, gols e grupos).

* **Acompanhamento de Partidas**: Status de jogos ao vivo ("Online"), partidas do dia e calendário futuro.

* **Gestão de Entidades**: Visualização detalhada de seleções e jogadores cadastrados.

* **Chaveamento**: Visualização estruturada das fases eliminatórias (Oitavas, Quartas, Semifinal e Final).



## Tecnologias Utilizadas



**Front-end:**

* Flutter

* Dart



**Back-end:**

* Python

* Flask REST API



## Pré-requisitos



Para executar este projeto localmente, você precisará ter instalado em sua máquina:



* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versão compatível com o projeto)

* [Dart SDK](https://dart.dev/get-dart)

* Navegador Google Chrome (para testes web) ou emulador configurado.

* [Python 3.x](https://www.python.org/downloads/) (para execução do servidor back-end)



## Como Executar o Projeto



### 1. Configurando o Front-end (Flutter)



Abra o terminal, navegue até a pasta raiz do projeto Flutter (`flutter_campeonato_flutter`) e instale as dependências:



    flutter pub get



Para executar a aplicação no navegador (Chrome):



    flutter run -d chrome



### 2. Configurando o Back-end (Python)



Navegue até a pasta do back-end (`backend_campeonato_flutter`) e instale as dependências contidas no arquivo `requirements.txt`:



    pip install -r requirements.txt



Inicie o servidor local:



    python main.py



## Autores



* **Luiza Ferraz** - *Mobile Front-End/UX*

* **Anny Luisa** - *Mobile Back-end*

* **Maria Isabel Mariz** - *Mobile Full-Stack*

* **Monalisa Ellen** - *Arquitetura/Back-end*

