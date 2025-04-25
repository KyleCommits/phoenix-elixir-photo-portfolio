defmodule PhotoPortfolioWeb.CoreComponents do
  use Phoenix.Component
  import Phoenix.HTML.Form

  # Basic button component
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true
  def button(assigns) do
    ~H"""
    <button class={["button", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  # Table component
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_click, :any, default: nil
  slot :col, required: true
  slot :action, required: false

  def table(assigns) do
    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pr-6 pb-4 font-normal"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only">Actions</span></th>
          </tr>
        </thead>
        <tbody class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700">
          <tr :for={row <- @rows} id={@id && "#{@id}-#{Phoenix.Param.to_param(row)}"} class="relative group hover:bg-zinc-50">
            <td :for={col <- @col} class="p-0 py-4 pr-6">
              <%= render_slot(col, row) %>
            </td>
            <td :if={@action != []} class="p-0 w-14">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span :for={action <- @action} class="ml-4">
                  <%= render_slot(action, row) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  # Header component
  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :actions
  def header(assigns) do
    ~H"""
    <header class={["flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  # Input component
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :type, :string, default: "text"
  attr :value, :any
  attr :field, :any, doc: "a form field struct"
  attr :errors, :list, default: []
  attr :required, :boolean, default: false
  attr :rest, :global, include: ~w(autocomplete disabled form max maxlength min minlength pattern placeholder readonly required size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <label for={@id} class="block text-sm font-semibold leading-6 text-zinc-800">
        <%= @label %>
      </label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[

          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx_no_feedback:border-zinc-300 phx_no_feedback:focus:border-zinc-400",
          "min-h-[2.5rem] border-zinc-300 focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <div class="mt-2 flex gap-3 text-sm leading-6 text-rose-600">
        <%= for error <- @errors do %>
          <div phx-feedback-for={@name}><%= error %></div>
        <% end %>
      </div>
    </div>
    """
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end

  # Simple Form component
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"
  attr :rest, :global, include: ~w(autocomplete name rel action enctype method novalidate target multipart)
  slot :inner_block, required: true
  slot :actions, required: false

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  # List component
  attr :class, :string, default: nil
  slot :item, required: true

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  attr :flash, :map
  def flash_group(assigns) do
    ~H"""
    <div class="fixed top-2 right-2 w-80 z-50">
      <.flash kind={:info} title="Success!" flash={@flash} />
      <.flash kind={:error} title="Error!" flash={@flash} />
      <.flash kind={:warning} title="Warning" flash={@flash} />
    </div>
    """
  end

  attr :flash, :map
  attr :kind, :atom
  attr :title, :string
  attr :rest, :global

  def flash(%{kind: kind} = assigns) do
    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      {@rest}
      role="alert"
      class={[
        "fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 ring-rose-500 fill-rose-900",
        @kind == :warning && "bg-yellow-50 text-yellow-800 ring-yellow-500 fill-yellow-900"
      ]}
    >
      <div class="flex gap-4 text-sm">
        <div class="flex-1">
          <p class="font-semibold"><%= @title %></p>
          <p><%= msg %></p>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders an error message.
  """
  attr :if, :boolean, default: true
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <div
      :if={@if}
      class="rounded-lg bg-red-50 p-4 text-sm text-red-600"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
