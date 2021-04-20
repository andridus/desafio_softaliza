## DESAFIO SOFTALIZA

O seu desafio é desenvolver uma API REST em Elixir, utilizando Phoenix, para geração de anais (proceedings) de artigos científicos submetidos a eventos. Além da geração dos anais, a aplicação deve permitir a inclusão, edição, visualização e exclusão de eventos e artigos.

### Requisitos

  - [ ] O acesso de escrita deve ser autorizado e a consulta de eventos e anais deve ser aberta. As entradas e saídas devem ser serializadas em JSON.
  - [ ] Os eventos são compostos por: Título e Descrição.
  - [ ] Os artigos devem possuir relação com um evento e um usuário (autor do artigo), e são compostos por: Título, Resumo, Palavras-chave, Autor (usuário autenticado) e Co-autores.
  - [ ] A geração dos anais do evento deve ser viabilizada através de um endpoint do evento, que ao ser requisitado retorna um arquivo em PDF, com todos artigos já registrados para aquele evento (para esse desafio, consideramos que todos artigos são aceitos para publicação nos anais).
    - [ ] O PDF com todos artigos deve conter um cabeçalho simples contendo o título do evento, seguido pelos artigos, dispostos em ordem alfabética. 
    - [ ] Para cada artigo deve ser exibido: o título; as palavras-chave; os autores (o autor que registrou o artigo seguido pelos co-autores em ordem alfabética); e o resumo.
  - [ ] Os endpoints desenvolvidos devem ser documentados.

### Etapas de Desenvolvimento
  - [x] Estrutura Base
    - [x] Novo Projeto Phoenix
    - [x] Configuração do Docker
    - [x] Configuração do Guardian
    - [x] Configuração do Swagger
  - [x] Login, Signup (Criação de novo Usuário )
  - [x] Usuários (Criar, Visualizar, Editar, Remover)
  - [x] Eventos (Criar, Visualizar, Editar, Remover)
      - os Endpoints GET / e GET /:id não precisam de autenticação 
      - o Endpoint GET /:id/proceedings Lista os artigos por evento
  - [x] Artigos (Criar, Visualizar, Editar, Remover)
  - [ ] Geração dos Anais em PDF

### Instalação E Execução

  1. Rode o comando `docker-compose up`
  
### Testes 

  - Navegue até [locahost:8080/swagger](http://locahost:8080/swagger)  para observar a documentação das rotas

