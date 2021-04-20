defmodule Ev.Repo.Migrations.MockData do
  use Ecto.Migration

  alias Ev.Repo
  def change do

    ## Inserir Usuários de teste
    Repo.insert(%Ev.Models.User{
      email: "alberto@email.com", 
      name: "Alberto Maia", 
      password: Ev.Models.User.crypted("123456"),
    })
    Repo.insert(%Ev.Models.User{
      email: "maria@email.com", 
      name: "Maria Gabriela", 
      password: Ev.Models.User.crypted("123456"),
    })
    Repo.insert(%Ev.Models.User{
      email: "jose@email.com", 
      name: "José da Silva", 
      password: Ev.Models.User.crypted("123456"),
    })


    ## Inserir Eventos de Teste
    Repo.insert(%Ev.Models.Event{
      title: "O primeiro evento da Elo Eventos", 
      description: "A Elo Eventos é uma agência de eventos que foi surpreendida no início de 2020 pelas medidas de distanciamento social que impediram a realização de eventos presenciais. Na busca por se adaptar ao momento, a Elo e a Softaliza formaram uma parceria de sucesso. Confira abaixo a entrevista realizada com Kerolen, do atendimento da Elo, sobre o trabalho junto à Softaliza.", 
      creator_id: 1
    })

    Repo.insert(%Ev.Models.Event{
      title: "Congresso Brasileiro de Educação em Engenharia (COBENGE).", 
      description: "Todo ano desde 1973 a Associação Brasileira de Educação em Engenharia (ABENGE) realiza o fórum de discussão mais importante sobre a área no país, o Congresso Brasileiro de Educação em Engenharia (COBENGE). Destinado a dirigentes universitários, coordenadores, professores e pesquisadores de Engenharia e representantes de entidades da área, o evento sempre foi realizado de forma presencial. ", 
      creator_id: 1
    })


    ### Inserir Artigos
    Repo.insert(%Ev.Models.Article{
      title: "Elo Eventos é uma agência de eventos ", 
      abstract: "Com a imposição do distanciamento social e a inerente mudança na realização de eventos em 2020, a agência começou a pesquisar por plataformas que pudessem atender as demandas de seus clientes, encontrando através de uma busca do Google a Softaliza. ", 
      coauthors: ["Fulano", "Beltrano", "Sicrano"],
      keywords: ["Elo", "agência", "eventos"],
      event_id: 1,
      author_id: 1
    })

    Repo.insert(%Ev.Models.Article{
      title: "O segundo evento realizado foi o Fascia in Movement and Sport.", 
      abstract: "Quando eu mostrei o projeto do Psicodrama pra esse segundo projeto eles falaram ‘nossa a gente quer esse hall, a gente quer essa plataforma’ foi assim, amor a primeira vista da cliente. Deu o mesmo retorno positivo em questões de impacto. A parceria teve muito sucesso nesses dois projetos (…)", 
      coauthors: ["Felícia", "Fernanda", "Moreno"],
      keywords: ["parceria", "impacto", "gente"],
      event_id: 1,
      author_id: 2
    })
    
    Repo.insert(%Ev.Models.Article{
      title: "Os eventos realizados pela Elo em parceria com a Softaliza foram criados na plataforma Ciente Live.", 
      abstract: "O Ciente Live é uma plataforma para realização de eventos online criada pela Softaliza que garante a mesma experiência que um evento presencial. Crie um ambiente completamente personalizado para seu evento, com salas virtuais, stands para patrocinadores, gravação de todas atividades, emissão de relatórios, entre outras funcionalidades! Valorize sua marca e sua identidade visual personalizando completamente a plataforma. Ofereça uma experiência completa para palestrantes e participantes. ", 
      coauthors: ["Joaquim", "Ferreira", "Horácio"],
      keywords: ["relatórios", "funcionalidades", "atividades"],
      event_id: 1,
      author_id: 3
    })

    Repo.insert(%Ev.Models.Article{
      title: "Transformar um evento presencial no formato online sem a organização ter nenhuma experiência na área", 
      abstract: "Mesmo com a pandemia, a ABENGE não considerou o cancelamento do evento, tendo de se adaptar à nova realidade. Percebendo a ascensão dos congressos online, a equipe de organização do COBENGE começou uma busca por alternativas e soluções para realização do evento. Ao se depararem com diversas plataformas, perceberam que nenhuma delas atendia as demandas do Congresso. ", 
      coauthors: ["Silva", "Juracir", "Alice"],
      keywords: ["soluções", "demandas", "COBENGE"],
      event_id: 2,
      author_id: 2
    })
  end
end
