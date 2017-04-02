# phoenix-active-link

[![Build Status](https://travis-ci.org/tuvistavie/phoenix-active-link.svg?branch=master)](https://travis-ci.org/tuvistavie/phoenix-active-link)

Elixir/Phoenix helper to create links with "active" state.

## Installation

Add `phoenix_active_link` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:phoenix_active_link, "~> 0.1.1"}]
end
```

## Usage

First, add

```
import PhoenixActiveLink
```

to the `quote` of the `view` function in your `web.ex`.

You can then use the functions as follow:

```erb
<header>
  <ul>
    <%= active_link(@conn, "Dashboard", to: "/", active: [{Dashboard, :index}], wrap_tag: :li) %>
    <%= active_link(@conn, "Users", to: "/users", wrap_tag: :li) %>
    <%= active_link(@conn, to: "/users", wrap_tag: :li) do %>
      <img src="foo.png">
    <% end %>
  </ul>
</header>
```

If you prefer to write `PhoenixActiveLink.active_link` explicitly, you can skip
the first step.

## Documentation

For more information, take a look at the [documentation](https://hexdocs.pm/phoenix_active_link/PhoenixActiveLink.html)

## Credits

This library is inspired by/ported from [active_link_to](https://github.com/comfy/active_link_to).
