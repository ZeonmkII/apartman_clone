defmodule ApartmanWeb.TestLive.Temp do
  use ApartmanWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :username, "john-doe")
      |> assign(:password, "********")

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <section class="bg-gray-800 h-screen w-screen">
        <div class="container mx-auto h-full flex justify-center items-center">
        <div class="w-1/3">
          <h1 class="text-yellow-600 hover:text-yellow-500 font-bold text-4xl text-center">J-Resident</h1><br>
          <div class="border-yellow-600 p-8 border-t-4 bg-white mb-6 rounded-lg shadow-lg">
            <form class="w-full max-w-sm">
              <div class="md:flex md:items-center mb-6">
                <div class="md:w-1/4">
                  <label class="block text-gray-600 font-bold text-lg md:text-left mb-1 md:mb-0 pr-4" for="username">
                    ชื่อผู้ใช้
                  </label>
                </div>
                <div class="md:w-3/4">
                  <input class="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-yellow-500" id="username" placeholder="<%= @username %>" type="text" name="username" required autofocus>
                </div>
              </div>
              <div class="md:flex md:items-center mb-6">
                <div class="md:w-1/4">
                  <label class="block text-gray-600 font-bold text-lg md:text-left mb-1 md:mb-0 pr-4" for="password">
                    รหัสผ่าน
                  </label>
                </div>
                <div class="md:w-3/4">
                  <input class="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-yellow-500" id="password" placeholder="<%= @password %>" type="password" name="password" required>
                </div>
              </div>
              <div class="md:flex md:items-center">
                <div class="md:w-1/4"></div>
                <div class="md:w-3/4">
                  <button class="shadow bg-yellow-600 hover:bg-yellow-500 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded" type="button">
                    ล็อกอิน
                  </button>
                </div>
              </div>
            </form>
            </div>
            <div class="flex justify-center">
              <p class="text-center text-gray-500 text-xs">
              &copy;2020 Horganice. All rights reserved.
              </p>
            </div>
          </div>
        </div>
    </section>
    """
  end
end
