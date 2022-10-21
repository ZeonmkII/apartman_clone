defmodule ApartmanWeb.Resolvers.TenantResolver do
  alias Apartman.Tenant
  alias Apartman.Account.User
  alias Apartman.Account.Relationship.Create
  alias Apartman.Repo
  alias Apartman.Helper

  def customers(_parent, _args, _resolution) do
    {:ok, Tenant.list_customers()}
  end

  def customer(_parent, %{id: id}, _resolution) do
    customer = Tenant.get_customer!(id) |> node_to_absinthe()
    {:ok, customer}
  end

  def customer_id_number(_parent, %{id_number: id_number}, _resolution) do
    customer = Tenant.get_customer_by_id_number(id_number) |> node_to_absinthe()
    {:ok, customer}
  end

  def create_customer(_parent, %{input: input}, _resolution) do
    attrs = Helper.map_keys_to_camel(input)

    with {:ok, customer} <- Tenant.create_customer(attrs) do
      # ====== Relationship ================================
      user = Repo.Node.get(User, input.parent_id)

      rel = %{
        start_node: user,
        end_node: customer
      }

      relationship = %Create{} |> Create.changeset(rel)
      {:ok, _created} = Repo.Relationship.create(relationship)
      # ====================================================
      customer_data = node_to_absinthe(customer)
      {:ok, customer_data}
    else
      {:error, _} -> {:error, "Cannot create customer."}
    end
  end

  def update_customer(_parent, %{id: id, input: input}, _resolution) do
    attrs = Helper.map_keys_to_camel(input)
    db_customer = Tenant.get_customer!(id)

    with {:ok, customer} <- Tenant.update_customer(db_customer, attrs) do
      {:ok, node_to_absinthe(customer)}
    else
      {:error, _} -> {:error, "Failed to update customer info."}
    end
  end

  def delete_customer(_parent, %{id: id}, _resolution) do
    with {:ok, customer} <- Tenant.delete_customer(id) do
      {:ok, node_to_absinthe(customer)}
    else
      {:error, _} -> {:error, "Couldn't delete customer."}
    end
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def daily_rents(_parent, _args, _resolution) do
    {:ok, Tenant.list_dailyrents()}
  end

  def daily_rent(_parent, %{id: id}, _resolution) do
    daily_rent = Tenant.get_daily_rent!(id) |> node_to_absinthe()
    {:ok, daily_rent}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  def monthly_rents(_parent, _args, _resolution) do
    {:ok, Tenant.list_monthlyrents()}
  end

  def monthly_rent(_parent, %{id: id}, _resolution) do
    monthly_rent = Tenant.get_monthly_rent!(id) |> node_to_absinthe()
    {:ok, monthly_rent}
  end

  # |++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

  defp node_to_absinthe(node) do
    if node do
      cond do
        # Customer node
        Map.has_key?(node, :firstName) ->
          %{
            id: node.uuid,
            id_number: node.idNumber,
            first_name: node.firstName,
            first_name_alt: node.firstNameAlt,
            last_name: node.lastName,
            last_name_alt: node.lastNameAlt,
            date_of_birth: node.dateOfBirth,
            faith: node.faith,
            nationality: node.nationality,
            gender: node.sex,
            address: node.address,
            issue_by: node.issueBy,
            date_of_issue: node.dateOfIssue,
            date_of_expiry: node.dateOfExpiry,
            photo: node.photo,
            phone: node.phone,
            line: node.line,
            occupation: node.occupation,
            emergency_contact: node.emergencyContact
          }

        # MonthlyRent node
        Map.has_key?(node, :bTenant) ->
          %{
            id: node.uuid,
            b_current: node.bCurrent,
            b_tenant: node.bTenant,
            b_contract: node.bContract
          }

        # DailyRent node
        Map.has_key?(node, :bCurrent) ->
          %{
            id: node.uuid,
            b_current: node.bCurrent
          }
      end
    else
      nil
    end
  end
end
