defmodule Utils.ProceedingTemplate do


  def render(event) do
    event
    |> body
    |> html
    
  end
  def html(b) do
    """
    <html>
      <head>
        <meta charset="UTF-8">
        <style>
          * { font-family: sans-serif }
          .container{
            padding: 15px;
            font-family: sans-serif; 
          }
          h1, h2,h3,h4,h5,h6{
            font-family: sans-serif;
            font-size: 15px;
            padding: 5px;
          }
          h1{
            font-size: 20pt;
          }
        </style>
      </head>
      <body>
        <div class="container">
          #{b}
        </div>
      </body>
    </html>
    """
  end
  def body(event) do

    articles = 
      event.articles
      |> Enum.map(&parse_article/1)
      |> Enum.join("<hr />")

    """
      <h1>EVENTO: #{event.title}</h1>
      #{articles} 
    """
  end

  def parse_article(a) do
    authors = [a.author.name | a.coauthors] |> Enum.join(", ")
    """
    <hr />
    <div><b>Título: #{a.title}</b></div>
    <div>Palavras-Chave: #{Enum.join(a.keywords, ", ")}</div>
    <div>Autores: #{authors}</div>
    <p>Resumo: #{a.abstract}</p>
    """
  end
end