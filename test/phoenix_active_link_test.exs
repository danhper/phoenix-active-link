defmodule PhoenixActiveLinkTest do
  use ExUnit.Case
  use Phoenix.HTML
  import TestHelpers

  doctest PhoenixActiveLink

  import PhoenixActiveLink

  test "active_path? when :active is true" do
    assert active_path?(conn(), active: true)
  end

  test "active_path? when :active is false" do
    refute active_path?(conn(), active: false)
  end

  test "active_path? when :active is :inclusive" do
    assert active_path?(conn(path: "/foo/bar"), to: "/foo", active: :inclusive)
    refute active_path?(conn(path: "/foo"), to: "/foo/bar", active: :inclusive)
    assert active_path?(conn(path: "/foo/"), to: "/foo", active: :inclusive)
    assert active_path?(conn(path: "/foo"), to: "/foo/", active: :inclusive)
    refute active_path?(conn(path: "/foo"), to: "/", active: :inclusive)
    refute active_path?(conn(path: "/"), to: "/foo", active: :inclusive)
  end

  test "active_path? when :active is not passed" do
    assert active_path?(conn(path: "/foo/bar"), to: "/foo")
  end

  test "active_path? when :active is :exclusive" do
    assert active_path?(conn(path: "/foo"), to: "/foo", active: :exclusive)
    assert active_path?(conn(path: "/foo/"), to: "/foo", active: :exclusive)
    assert active_path?(conn(path: "/foo"), to: "/foo/", active: :exclusive)
    refute active_path?(conn(path: "/foo/bar"), to: "/foo", active: :exclusive)
  end

  test "active_path? when :active is :exact" do
    assert active_path?(conn(path: "/foo"), to: "/foo", active: :exact)
    refute active_path?(conn(path: "/foo/"), to: "/foo", active: :exact)
    refute active_path?(conn(path: "/foo"), to: "/foo/", active: :exact)
  end

  test "active_path? when :active is a regex" do
    assert active_path?(conn(path: "/foo"), active: ~r(^/foo.*))
    refute active_path?(conn(path: "/bar/foo"), active: ~r(^/foo.*))
    assert active_path?(conn(path: "/bar/foo"), active: ~r(foo.*))
  end

  test "active_path? when :active is a {controller, action} list" do
    conn = conn(controller: Foo, action: Bar)
    assert active_path?(conn, active: [{Foo, Bar}])
    assert active_path?(conn, active: [{:any, Bar}])
    assert active_path?(conn, active: [{Foo, :any}])
    refute active_path?(conn, active: [{Bar, Foo}])
  end

  test "active_link without :wrap_tag" do
    assert active_link(conn(path: "/"), "Link", to: "/foo") == link("Link", to: "/foo", class: "")
    assert active_link(conn(path: "/foo"), "Link", to: "/foo") == link("Link", to: "/foo", class: "active")
    assert active_link(conn(path: "/foo"), "Link", to: "/foo", class: "bar") == link("Link", to: "/foo", class: "active bar")
    link = active_link(conn(path: "/foo"), "Link", to: "/foo", class: "bar", class_active: "enabled")
    assert link == link("Link", to: "/foo", class: "enabled bar")
    link = active_link(conn(path: "/bar"), "Link", to: "/foo", class: "bar", class_inactive: "disabled")
    assert link == link("Link", to: "/foo", class: "disabled bar")
  end

  test "active_link with a block" do
    content = content_tag(:p, "Hello")
    expected = link(to: "/foo", class: "") do
      content
    end

    result = active_link(conn(path: "/"), to: "/foo") do
       content
    end

    assert result == expected
  end

  test "active_link with :wrap_tag" do
    expected = content_tag(:li, link("Link", to: "/foo", class: "active"), class: "active")
    assert active_link(conn(path: "/foo"), "Link", to: "/foo", wrap_tag: :li) == expected

    expected = content_tag(:li, link("Link", to: "/foo", class: "disabled"), class: "disabled foo")
    link = active_link(conn(path: "/bar"), "Link", to: "/foo", class_inactive: "disabled", wrap_tag: :li, wrap_tag_opts: [class: "foo"])
    assert link == expected
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
