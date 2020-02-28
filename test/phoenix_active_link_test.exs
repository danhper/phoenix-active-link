defmodule PhoenixActiveLinkTest do
  use ExUnit.Case
  use Phoenix.HTML
  import TestHelpers
  import PhoenixActiveLink

  doctest PhoenixActiveLink

  describe "active_path?/2" do
    test "when :active is true" do
      assert active_path?(conn(), active: true)
    end

    test "when :active is false" do
      refute active_path?(conn(), active: false)
    end

    test "when :active is :inclusive" do
      assert active_path?(conn(path: "/foo/bar"), to: "/foo", active: :inclusive)
      refute active_path?(conn(path: "/foo"), to: "/foo/bar", active: :inclusive)
      assert active_path?(conn(path: "/foo/"), to: "/foo", active: :inclusive)
      assert active_path?(conn(path: "/foo"), to: "/foo/", active: :inclusive)
      assert active_path?(conn(path: "/foo"), to: "/foo?param=bar", active: :inclusive)
      assert active_path?(conn(path: "/foo?param=bar"), to: "/foo", active: :inclusive)
      refute active_path?(conn(path: "/foo"), to: "/", active: :inclusive)
      refute active_path?(conn(path: "/"), to: "/foo", active: :inclusive)
    end

    test "when :active is not passed" do
      assert active_path?(conn(path: "/foo/bar"), to: "/foo")
    end

    test "when :active is :exclusive" do
      assert active_path?(conn(path: "/foo"), to: "/foo", active: :exclusive)
      assert active_path?(conn(path: "/foo/"), to: "/foo", active: :exclusive)
      assert active_path?(conn(path: "/foo"), to: "/foo/", active: :exclusive)
      refute active_path?(conn(path: "/foo/bar"), to: "/foo", active: :exclusive)
    end

    test "when :active is :exact" do
      assert active_path?(conn(path: "/foo"), to: "/foo", active: :exact)
      refute active_path?(conn(path: "/foo/"), to: "/foo", active: :exact)
      refute active_path?(conn(path: "/foo"), to: "/foo/", active: :exact)
    end

    test "when :acitve is :exact_with_params" do
      assert active_path?(conn(path: "/foo", query_string: "bar=1"), to: "/foo?bar=1", active: :exact_with_params)
      refute active_path?(conn(path: "/foo", query_string: "bar=1&baz=2"), to: "/foo?bar=1", active: :exact_with_params)
      assert active_path?(conn(path: "/foo", query_string: "bar[x]=1&bar[y]=1"), to: "/foo?bar[x]=1&bar[y]=1", active: :exact_with_params)
      refute active_path?(conn(path: "/foo", query_string: "bar=baz%20foo"), to: "/foo?bar=baz foo", active: :exact_with_params)
    end

    test "when :active is :inclusive_with_params" do
      assert active_path?(conn(path: "/foo", query_string: "bar=2&baz=2"), to: "/foo", active: :inclusive_with_params)
      assert active_path?(conn(path: "/foo", query_string: "bar=2&baz=2"), to: "/foo?baz=2", active: :inclusive_with_params)
      assert active_path?(conn(path: "/foo", query_string: "bar%5Bx%5D=2&bar%5By%5D=2"), to: "/foo?bar[x]=2", active: :inclusive_with_params)
      assert active_path?(conn(path: "/foo", query_string: "bar[x]=2&bar[y]=2"), to: "/foo?bar[x]=2", active: :inclusive_with_params)
      refute active_path?(conn(path: "/foo", query_string: "bar=2&baz=2"), to: "/foo?baz=2&bax=6", active: :inclusive_with_params)
      refute active_path?(conn(path: "/foo", query_string: "bar[x]=2&bar[y]=2"), to: "/foo?bar[x]=2&bar[z]=6", active: :inclusive_with_params)
      refute active_path?(conn(path: "/foo", query_string: "bar=2&baz=2"), to: "/foobar?baz=2",active: :inclusive_with_params)
    end

    test "when :active is a regex" do
      assert active_path?(conn(path: "/foo"), active: ~r(^/foo.*))
      refute active_path?(conn(path: "/bar/foo"), active: ~r(^/foo.*))
      assert active_path?(conn(path: "/bar/foo"), active: ~r(foo.*))
    end

    test "when :active is a {controller, action} list" do
      conn = conn(controller: Foo, action: Bar)
      assert active_path?(conn, active: [{Foo, Bar}])
      assert active_path?(conn, active: [{:any, Bar}])
      assert active_path?(conn, active: [{Foo, :any}])
      refute active_path?(conn, active: [{Bar, Foo}])
    end
  end

  describe "active_link/3" do
    test "without :wrap_tag" do
      assert active_link(conn(path: "/"), "Link", to: "/foo") == link("Link", to: "/foo", class: "")
      assert active_link(conn(path: "/foo"), "Link", to: "/foo") == link("Link", to: "/foo", class: "active")
      assert active_link(conn(path: "/foo"), "Link", to: "/foo", class: "bar") == link("Link", to: "/foo", class: "active bar")

      link = active_link(conn(path: "/foo"), "Link", to: "/foo", class: "bar", class_active: "enabled")
      assert link == link("Link", to: "/foo", class: "enabled bar")

      link = active_link(conn(path: "/bar"), "Link", to: "/foo", class: "bar", class_inactive: "disabled")
      assert link == link("Link", to: "/foo", class: "disabled bar")
    end

    test "with a block" do
      content = content_tag(:p, "Hello")
      expected = link(to: "/foo", class: "") do
        content
      end

      result = active_link(conn(path: "/"), to: "/foo") do
        content
      end

      assert result == expected
    end

    test "with :wrap_tag" do
      expected = content_tag(:li, link("Link", to: "/foo", class: "active"), class: "active")
      assert active_link(conn(path: "/foo"), "Link", to: "/foo", wrap_tag: :li) == expected

      expected = content_tag(:li, link("Link", to: "/foo", class: "disabled"), class: "disabled foo")
      link = active_link(conn(path: "/bar"), "Link", to: "/foo", class_inactive: "disabled", wrap_tag: :li, wrap_tag_opts: [class: "foo"])
      assert link == expected
    end
  end

  test "customize defaults" do
    Application.put_env(:phoenix_active_link, :defaults, [wrap_tag: :li])
    expected = content_tag(:li, link("Link", to: "/foo", class: "active"), class: "active")
    assert active_link(conn(path: "/foo"), "Link", to: "/foo") == expected

    Application.put_env(:phoenix_active_link, :defaults, [class_active: "enabled"])
    assert active_link(conn(path: "/foo"), "Link", to: "/foo") == link("Link", to: "/foo", class: "enabled")
  after
    Application.put_env(:phoenix_active_link, :defaults, [])
  end
end
