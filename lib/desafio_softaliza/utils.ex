defmodule Ev.Utils do

  # Pega os erros verificados pelo Changeset
  def model_errors(changeset) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        field: field,
        detail: render_error_detail(detail)
      }
    end)
    %{errors: errors}
  end

  def render_error_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  def render_error_detail(message) do
    message
  end

  #-----

end