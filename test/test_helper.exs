ExUnit.start()

defmodule TestHelpers do
  def conn(opts \\ []) do
    %Plug.Conn{}
    |> Map.put(:private, make_private(opts))
    |> Map.put(:request_path, opts[:path])
    |> Map.put(:query_string, opts[:query_string] || "")
  end

  defp make_private(opts) do
    cond do
      opts[:controller] -> %{phoenix_controller: opts[:controller], phoenix_action: opts[:action]}
      opts[:live_view] -> %{phoenix_live_view: {opts[:live_view], [action: opts[:action]]}}
      true -> %{}
    end
  end
end
