defmodule ApartmanWeb.TestLive.Test do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Apartman.Tenant
  # alias Apartman.Tenant.Customer

  def mount(_params, _session, socket) do
    customer = get_customer("9798768869731")
    {:ok, assign(socket, :customer, customer)}
  end

  def render(assigns) do
    ~L"""
    <center>
      <h3 class="font-mono font-semibold text-yellow-700 text-2xl text-center">ID: <%= inspect @customer.uuid %></h3>
      Data: <%= inspect @customer %>
      <h1 class="text-orange-500 text-5xl font-bold text-center">Tailwind CSS</h1>
    </center>
    """
  end

  defp get_customer(id) do
    Tenant.get_customer_by_id_number(id)
  end
end
