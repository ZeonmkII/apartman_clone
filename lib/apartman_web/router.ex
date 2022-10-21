defmodule ApartmanWeb.Router do
  use ApartmanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApartmanWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward("/graphql", Absinthe.Plug, schema: ApartmanWeb.Schema)

    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ApartmanWeb.Schema)
    end
  end

  scope "/", ApartmanWeb do
    pipe_through :browser

    # HomePage => ค้นหาข้อมูลลูกค้าเก่าจากเลขประจำตัวประชาชน หรือ กดสร้างลูกค้าใหม่
    live "/", CustomerLive.Search

    # Register => ลงทะเบียนลูกค้าใหม่
    live "/customer/register", CustomerLive.Create, :new

    # User Dashboard => แสดงข้อมูลทุกอย่างของลูกค้าจาก Database -> สามารถทำการจอง / เช็คหนี้ค้างในระบบ / ฯลฯ
    live "/customer/dashboard", CustomerLive.Dashboard, :show

    # ========================= จองห้องพัก แบบรายเดือน ==========================

    # จองห้องพัก
    live "/monthlybooking/new", MonthlyBookingLive.Create, :new
    # Confirmation จองห้องพัก
    live "/monthlybooking/confirmation", MonthlyBookingLive.Summary, :show
    # !WIP :: Invoice ค่าจอง
    live "/monthlybooking/invoice", BookingFeeLive.Monthly, :new
    # !TODO :: Receipt ค่าจอง
    # live "/monthlybooking/receipt", ??????????????, :new

    # ทำสัญญาเช่า (Walk-in)
    live "/monthly/new", ContractLive.Create, :new
    # ทำสัญญาเช่า (Booked)
    live "/monthly/booked", ContractLive.Create, :edit
    # ต่อสัญญา
    live "/monthly/renew", ContractLive.Renew, :new
    # !WIP :: Confirmation การเซ็นสัญญาเช่า
    live "/monthly/confirmation", ContractLive.Summary, :show
    # !TODO :: Receipt ค่าเซ็นสัญญาเช่า
    # live "/monthly/contract-receipt", ContractFeeLive.Create :new
    # !WIP :: Invoice ใบแจ้งหนี้ (ออกทุกเดือน)
    # live "/monthly/invoice", MonthlyInvoiceLive.Create, :new
    # !TODO :: Receipt ของแต่ละห้อง (ออกทุกเดือน)
    # live "/monthly/receipt", ??????????????, :new

    # ========================= จองห้องพัก แบบรายวัน ============================

    # !WIP :: จองห้องพัก
    live "/dailybooking/new", DailyBookingLive.Create, :new
    # !TODO :: Confirmation จองห้องพัก
    live "/dailybooking/confirmation", DailyBookingLive.Summary, :show
    # !TODO :: Invoice ค่าจอง
    # live "/dailybooking/invoice", BookingFeeLive.Daily, :new
    # !TODO :: Receipt ค่าจอง
    # live "/dailybooking/receipt", ??????????????, :new

    # !WIP :: ทำสัญญาเช่า (Walk-in)
    live "/daily/new", CheckinLive.Create, :new
    # !WIP :: ทำสัญญาเช่า (Booked)
    live "/daily/booked", CheckinLive.Create, :edit
    # !TODO :: Confirmation การเช่า
    live "/daily/confirmation", CheckinLive.Summary, :show
    # !WIP :: Invoice ใบแจ้งหนี้
    # live "/daily/invoice", DailyInvoiceLive.Create, :new
    # !TODO :: Receipt ค่าห้อง
    # live "/daily/receipt", ??????????????, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApartmanWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ApartmanWeb.Telemetry
    end
  end
end
