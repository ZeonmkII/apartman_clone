defmodule ApartmanWeb.CustomerLive.Create do
  use ApartmanWeb, :live_view

  alias Apartman.Tenant
  alias Apartman.Account.User
  alias Apartman.Account.Relationship.Create
  alias Apartman.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: page_title(socket.assigns.live_action),
       customer: %Tenant.Customer{},
       error: false,
       error_msg: "",
       debug: false
     )}
  end

  @impl true
  def handle_event(
        "update",
        %{
          "id_number" => id_number,
          "firstname" => firstname,
          "lastname" => lastname,
          "firstname_alt" => firstname_alt,
          "lastname_alt" => lastname_alt,
          "date_of_birth" => date_of_birth,
          "sex" => sex,
          "nationality" => nationality,
          "religion" => religion,
          "address" => address,
          "issue_by" => issue_by,
          "date_of_issue" => date_of_issue,
          "date_of_expiry" => date_of_expiry,
          "phone" => phone,
          "line" => line,
          "occupation" => occupation,
          "emergency_contact" => emergency_contact
        },
        socket
      ) do
    socket =
      socket
      |> assign(
        customer: %{
          idNumber: id_number,
          firstName: firstname,
          lastName: lastname,
          firstNameAlt: firstname_alt,
          lastNameAlt: lastname_alt,
          dateOfBirth: date_of_birth,
          sex: sex,
          nationality: nationality,
          faith: religion,
          address: address,
          issueBy: issue_by,
          dateOfIssue: date_of_issue,
          dateOfExpiry: date_of_expiry,
          phone: phone,
          line: line,
          occupation: occupation,
          emergencyContact: emergency_contact
        }
      )

    {:noreply, socket}
  end

  def handle_event("submit", _, socket) do
    # get Parent node
    parent = get_creator()
    parent_id = parent.properties["uuid"]

    with {:ok, customer} <- Tenant.create_customer(socket.assigns.customer) do
      # ====== Relationship ================================
      user = Repo.Node.get(User, parent_id)

      rel = %{
        start_node: user,
        end_node: customer
      }

      relationship = %Create{} |> Create.changeset(rel)
      {:ok, _created} = Repo.Relationship.create(relationship)
      # ====================================================
      {:noreply,
       socket
       |> push_redirect(to: Routes.customer_dashboard_path(socket, :show, id: customer.idNumber))}
    else
      {:error, reason} ->
        IO.inspect(reason, label: "::ERROR::")

        {:noreply,
         socket
         |> assign(error: true, error_msg: "⚠️ ERROR ⚠️ #{reason}")}
    end
  end

  # Ramdom เอา User มาเป็นคนสร้างข้อมูลผู้ใช้ (ชั่วคราว)
  defp get_creator do
    Tenant.get_one_random_user_id()
  end

  defp page_title(:update), do: "📝 แก้ไขข้อมูลลูกค้า"
  defp page_title(_any), do: "📝 ลงทะเบียนลูกค้าใหม่"
end
