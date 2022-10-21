defmodule Apartman.Helper do
  # Convert map keys to various cases
  # from: https://nts.strzibny.name/snake-case-camel-case-keys-elixir/

  # ===================== Convert to camelCase ========================

  def map_keys_to_camel(%Date{} = val), do: val
  def map_keys_to_camel(%DateTime{} = val), do: val
  def map_keys_to_camel(%NaiveDateTime{} = val), do: val

  @doc """
  Convert the input map keys to camelCase
  """
  def map_keys_to_camel(map) when is_map(map) do
    for {key, val} <- map, into: %{} do
      {Inflex.camelize(key, :lower), map_keys_to_camel(val)}
    end
  end

  def map_keys_to_camel(val), do: val

  # ===================== Convert to snake_case ========================

  def map_keys_to_snake(%Date{} = val), do: val
  def map_keys_to_snake(%DateTime{} = val), do: val
  def map_keys_to_snake(%NaiveDateTime{} = val), do: val

  @doc """
  Convert the input map keys to snake_case
  """
  def map_keys_to_snake(map) when is_map(map) do
    for {key, val} <- map, into: %{} do
      {Inflex.underscore(key), map_keys_to_snake(val)}
    end
  end

  def map_keys_to_snake(val), do: val
end
