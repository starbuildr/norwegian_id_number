defmodule NorwegianIdNumber.Formatter do
  @moduledoc """
  Parser for Norwegian ID number to extract useful information.
  """

  @doc """
  Just return as plain string
  """
  @spec default(%NorwegianIdNumber{}) :: String.t
  def default(%NorwegianIdNumber{raw: raw}), do: raw

  @doc """
  User-friendly display
  """
  @spec pretty(%NorwegianIdNumber{}) :: String.t
  def pretty(%NorwegianIdNumber{
    birth_day: birth_day,
    birth_month: birth_month,
    birth_year: birth_year,
    personal_number: personal_number
  }), do: "#{zero_pad(birth_day, 2)}.#{zero_pad(birth_month, 2)}.#{birth_year} - #{personal_number}"

  @doc """
  Birthdate display
  """
  @spec birthdate(%NorwegianIdNumber{}) :: String.t
  def birthdate(%NorwegianIdNumber{
    birth_day: birth_day,
    birth_month: birth_month,
    birth_year: birth_year,
  }), do: "#{zero_pad(birth_day, 2)}.#{zero_pad(birth_month, 2)}.#{birth_year}"

  @spec zero_pad(integer(), integer()) :: String.t
  defp zero_pad(number, length) when is_integer(number) and is_integer(length) do
    number
    |> Integer.to_string()
    |> String.pad_leading(length, "0")
  end
end
