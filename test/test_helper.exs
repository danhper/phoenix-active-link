ExUnit.start()

defmodule TestHelpers do
  def conn(opts \\ []) do
    %Plug.Conn{}
    |> Map.put(:private, make_private(opts))
    |> Map.put(:request_path, opts[:path])
  end

  defp make_private(opts) do
    %{phoenix_controller: opts[:controller],
      phoenix_action: opts[:action]}
  end
end
