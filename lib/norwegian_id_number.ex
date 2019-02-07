defmodule NorwegianIdNumber do
  @moduledoc """
  Useful information extracted from Norwegian national identification number.

  From 2017, checksum is included to the personal number and no longer validated.
  """

  @type id_type ::  :fh_number | :d_number | :h_number | :birth_number

  defstruct [:id_type, :birth_day, :birth_month, :birth_year, :personal_number, :raw]

  @doc """
  Extract useful information from Norwegian national identification number
  """
  @spec parse(String.t) :: {:ok, %NorwegianIdNumber{}} | {:error, atom()}
  def parse(number) do
    NorwegianIdNumber.Parser.execute(number)
  end

  @doc """
  Extract useful information from Norwegian national identification number
  """
  @spec render(String.t, :pretty | :raw) :: String.t
  def render(number, render_mode \\ :pretty) do
    {:ok, parsed_number} = parse(number)
    case render_mode do
      :pretty ->
        NorwegianIdNumber.Formatter.pretty(parsed_number)
      _ ->
        NorwegianIdNumber.Formatter.default(parsed_number)
    end
  end

  @doc """
  Checks if Norwegian national identification number is valid
  """
  @spec is_valid?(String.t) :: boolean()
  def is_valid?(number) when is_binary(number) do
    case NorwegianIdNumber.Parser.execute(number) do
      {:ok, _} ->
        checksum_verification(number)
      _ ->
        false
    end
  end
  def is_valid?(_), do: false

  @spec checksum_verification(String.t) :: boolean()
  defp checksum_verification(number) do
    first_check_digit = [3, 7, 6, 1, 8, 9, 4, 5, 2, 1]
    second_check_digit = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2, 1]

    int_array =
      String.split(number, "")
      |> Enum.slice(1, 11)
      |> Enum.map(&String.to_integer/1)

    is_valid_check_digit?(first_check_digit, Enum.slice(int_array, 0..9))
      && is_valid_check_digit?(second_check_digit, int_array)
  end

  @spec is_valid_check_digit?([integer()], [integer()]) :: boolean()
  defp is_valid_check_digit?(sequence, int_array) do
    product =
      List.zip([sequence, int_array])
      |> Enum.reduce(0, fn({value, check}, acc) ->
        acc + (value * check)
      end)
      |> Kernel.rem(11)
    product === 0
  end
end
