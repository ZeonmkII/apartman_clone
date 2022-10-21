defmodule Apartman.FacilityTest do
  use Apartman.DataCase

  alias Apartman.Facility

  describe "buildings" do
    alias Apartman.Facility.Building

    @valid_attrs %{address: "some address", calcTypeElectric: "some calcTypeElectric", calcTypeWater: "some calcTypeWater", name: "some name", phone: "some phone", taxId: "some taxId", unitPriceElectric: "some unitPriceElectric", unitPriceWater: "some unitPriceWater"}
    @update_attrs %{address: "some updated address", calcTypeElectric: "some updated calcTypeElectric", calcTypeWater: "some updated calcTypeWater", name: "some updated name", phone: "some updated phone", taxId: "some updated taxId", unitPriceElectric: "some updated unitPriceElectric", unitPriceWater: "some updated unitPriceWater"}
    @invalid_attrs %{address: nil, calcTypeElectric: nil, calcTypeWater: nil, name: nil, phone: nil, taxId: nil, unitPriceElectric: nil, unitPriceWater: nil}

    def building_fixture(attrs \\ %{}) do
      {:ok, building} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Facility.create_building()

      building
    end

    test "list_buildings/0 returns all buildings" do
      building = building_fixture()
      assert Facility.list_buildings() == [building]
    end

    test "get_building!/1 returns the building with given id" do
      building = building_fixture()
      assert Facility.get_building!(building.id) == building
    end

    test "create_building/1 with valid data creates a building" do
      assert {:ok, %Building{} = building} = Facility.create_building(@valid_attrs)
      assert building.address == "some address"
      assert building.calcTypeElectric == "some calcTypeElectric"
      assert building.calcTypeWater == "some calcTypeWater"
      assert building.name == "some name"
      assert building.phone == "some phone"
      assert building.taxId == "some taxId"
      assert building.unitPriceElectric == "some unitPriceElectric"
      assert building.unitPriceWater == "some unitPriceWater"
    end

    test "create_building/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Facility.create_building(@invalid_attrs)
    end

    test "update_building/2 with valid data updates the building" do
      building = building_fixture()
      assert {:ok, %Building{} = building} = Facility.update_building(building, @update_attrs)
      assert building.address == "some updated address"
      assert building.calcTypeElectric == "some updated calcTypeElectric"
      assert building.calcTypeWater == "some updated calcTypeWater"
      assert building.name == "some updated name"
      assert building.phone == "some updated phone"
      assert building.taxId == "some updated taxId"
      assert building.unitPriceElectric == "some updated unitPriceElectric"
      assert building.unitPriceWater == "some updated unitPriceWater"
    end

    test "update_building/2 with invalid data returns error changeset" do
      building = building_fixture()
      assert {:error, %Ecto.Changeset{}} = Facility.update_building(building, @invalid_attrs)
      assert building == Facility.get_building!(building.id)
    end

    test "delete_building/1 deletes the building" do
      building = building_fixture()
      assert {:ok, %Building{}} = Facility.delete_building(building)
      assert_raise Ecto.NoResultsError, fn -> Facility.get_building!(building.id) end
    end

    test "change_building/1 returns a building changeset" do
      building = building_fixture()
      assert %Ecto.Changeset{} = Facility.change_building(building)
    end
  end

  describe "floors" do
    alias Apartman.Facility.Floor

    @valid_attrs %{number: "some number"}
    @update_attrs %{number: "some updated number"}
    @invalid_attrs %{number: nil}

    def floor_fixture(attrs \\ %{}) do
      {:ok, floor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Facility.create_floor()

      floor
    end

    test "list_floors/0 returns all floors" do
      floor = floor_fixture()
      assert Facility.list_floors() == [floor]
    end

    test "get_floor!/1 returns the floor with given id" do
      floor = floor_fixture()
      assert Facility.get_floor!(floor.id) == floor
    end

    test "create_floor/1 with valid data creates a floor" do
      assert {:ok, %Floor{} = floor} = Facility.create_floor(@valid_attrs)
      assert floor.number == "some number"
    end

    test "create_floor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Facility.create_floor(@invalid_attrs)
    end

    test "update_floor/2 with valid data updates the floor" do
      floor = floor_fixture()
      assert {:ok, %Floor{} = floor} = Facility.update_floor(floor, @update_attrs)
      assert floor.number == "some updated number"
    end

    test "update_floor/2 with invalid data returns error changeset" do
      floor = floor_fixture()
      assert {:error, %Ecto.Changeset{}} = Facility.update_floor(floor, @invalid_attrs)
      assert floor == Facility.get_floor!(floor.id)
    end

    test "delete_floor/1 deletes the floor" do
      floor = floor_fixture()
      assert {:ok, %Floor{}} = Facility.delete_floor(floor)
      assert_raise Ecto.NoResultsError, fn -> Facility.get_floor!(floor.id) end
    end

    test "change_floor/1 returns a floor changeset" do
      floor = floor_fixture()
      assert %Ecto.Changeset{} = Facility.change_floor(floor)
    end
  end

  describe "rooms" do
    alias Apartman.Facility.Room

    @valid_attrs %{bBooked: true, bOccupied: true, number: "some number"}
    @update_attrs %{bBooked: false, bOccupied: false, number: "some updated number"}
    @invalid_attrs %{bBooked: nil, bOccupied: nil, number: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Facility.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Facility.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Facility.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Facility.create_room(@valid_attrs)
      assert room.bBooked == true
      assert room.bOccupied == true
      assert room.number == "some number"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Facility.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Facility.update_room(room, @update_attrs)
      assert room.bBooked == false
      assert room.bOccupied == false
      assert room.number == "some updated number"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Facility.update_room(room, @invalid_attrs)
      assert room == Facility.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Facility.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Facility.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Facility.change_room(room)
    end
  end
end
