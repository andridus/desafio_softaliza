### __DESAFIO SOFTALIZA__

O seu desafio é desenvolver uma API REST em Elixir, utilizando Phoenix, para geração de anais (proceedings) de artigos científicos submetidos a eventos. Além da geração dos anais, a aplicação deve permitir a inclusão, edição, visualização e exclusão de eventos e artigos.

#### __Requisitos__

  - [ ] O acesso de escrita deve ser autorizado e a consulta de eventos e anais deve ser aberta. As entradas e saídas devem ser serializadas em JSON.
  - [ ] Os eventos são compostos por: Título e Descrição.
  - [ ] Os artigos devem possuir relação com um evento e um usuário (autor do artigo), e são compostos por: Título, Resumo, Palavras-chave, Autor (usuário autenticado) e Co-autores.
  - [ ] A geração dos anais do evento deve ser viabilizada através de um endpoint do evento, que ao ser requisitado retorna um arquivo em PDF, com todos artigos já registrados para aquele evento (para esse desafio, consideramos que todos artigos são aceitos para publicação nos anais).
    - [ ] O PDF com todos artigos deve conter um cabeçalho simples contendo o título do evento, seguido pelos artigos, dispostos em ordem alfabética. 
    - [ ] Para cada artigo deve ser exibido: o título; as palavras-chave; os autores (o autor que registrou o artigo seguido pelos co-autores em ordem alfabética); e o resumo.
  - [ ] Os endpoints desenvolvidos devem ser documentados.

#### __Etapas de Desenvolvimento__
  - [-] Estrutura Base
    - [x] Novo Projeto Phoenix
    - [x] Configuração do Docker
    - [ ] Configuração do Guardian
    - [ ] Configuração do Swagger
  - [ ] Usuários (Criar, Visualizar, Editar, Remover)
  - [ ] Eventos (Criar, Visualizar, Editar, Remover)
  - [ ] Artigos (Criar, Visualizar, Editar, Remover)
  - [ ] Geração dos Anais em PDF

#### __Instalação E Execução__

