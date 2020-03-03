# phoenix-active-link

[![Build Status](https://travis-ci.org/tuvistavie/phoenix-active-link.svg?branch=master)](https://travis-ci.org/tuvistavie/phoenix-active-link)

Elixir/Phoenix helper to create links with "active" state.

## Installation

Add `phoenix_active_link` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:phoenix_active_link, "~> 0.3.0"}]
end
```

## Usage

First, add

```elixir
import PhoenixActiveLink
```

to the `quote` of the `view` function in your `web.ex`.

You can then use the functions as follow:

```eex
<%= active_link(@conn, to: "/") do %>
  <img src="logo.png">
<% end %>

<nav>
  <ul>
    <%= active_link(@conn, "Dashboard", to: "/", wrap_tag: :li, active: [{Dashboard, :index}]) %>
    <%= active_link(@conn, "Users", to: "/users", wrap_tag: :li) %>
  </ul>
</nav>
```

If you prefer to write `PhoenixActiveLink.active_link` explicitly, you can skip the first step.

### Example for Bootstrap navigation

You can create active Bootstrap navigation items as follows:

```ex
active_link(@conn, "Home", to: "/", class: "nav-link", wrap_tag: :li, wrap_tag_opts: [class: "nav-item"])
```

_Defaults can be set in the `config.ex` as noted in the [documentation](https://hexdocs.pm/phoenix_active_link/PhoenixActiveLink.html#module-configuration)._

## Documentation

For more information, take a look at the [documentation](https://hexdocs.pm/phoenix_active_link/PhoenixActiveLink.html).

## Credits

This library is inspired by/ported from [active_link_to](https://github.com/comfy/active_link_to).
