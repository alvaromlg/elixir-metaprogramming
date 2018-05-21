defmodule ElixirMeta.LangLoader do
  @moduledoc """
  Dynamically generates lang functions depending on
  lang files available
  i.e:
  lang("es")
  lang_es
  @lang_es
  ...
  """

  @external_resource [Path.join([__DIR__, "es.json"]),
                      Path.join([__DIR__, "en.json"])]

  defmacro __using__(_) do
    for lang <- ["es", "en"] do
      {:ok, body} = File.read(Path.join([__DIR__, "#{lang}.json"]))
      {:ok, json} = Poison.decode(body)
      quote do
        # Lang.lang("es")
        def lang(unquote(lang)), do: unquote(Macro.escape(json))
        # Lang.lang_es
        def unquote(:"lang_#{lang}")(), do: unquote(Macro.escape(json))
        # @lang_es
        Module.put_attribute __MODULE__,
          :"lang_#{unquote(lang)}", unquote(lang)
      end
    end
  end
end

defmodule ElixirMeta.Lang do
  use ElixirMeta.LangLoader

  def test do
    IO.inspect @lang_es
  end
end
