defmodule NorwegianIdNumber.Parser do
  @moduledoc """
  Parser for Norwegian ID number to extract useful information.
  """

  @spec execute(String.t) :: {:ok, %NorwegianIdNumber{}} | {:error, atom()}
  def execute(
    <<day::bytes-size(2)>> <> <<month::bytes-size(2)>> <> <<year::bytes-size(2)>>
    <> <<age_group::bytes-size(3)>> <> <<control::bytes-size(2)>> = country_uid
  ) do
    id_type = get_type(country_uid)
    with \
      {:ok, day_int} <- parse_birth_day(id_type, day),
      {:ok, year_int} <- parse_birth_year(id_type, year, age_group),
      {:ok, month_int} <- parse_birth_month(id_type, month)
    do
      number =
        %NorwegianIdNumber{
          id_type: id_type,
          birth_day: day_int,
          birth_month: month_int,
          birth_year: year_int,
          personal_number: "#{age_group}#{control}",
          raw: country_uid
        }
      {:ok, number}
    end
  end
  def execute(_), do: {:error, :invalid_number}

  @spec parse_birth_year(NorwegianIdNumber.id_type, String.t, String.t) :: {:ok, integer()} | {:error, :invalid_year}
  defp parse_birth_year(_, <<year::bytes-size(2)>>, <<age_group::bytes-size(3)>>) do
    with \
      {age_group_int, ""} <- Integer.parse(age_group),
      {year_int, ""} <- Integer.parse(year)
    do
      century_prefix = get_century_prefix(age_group_int, year_int)
      {:ok, "#{century_prefix}#{year}" |> String.to_integer()}
    else
      _ ->
        {:error, :invalid_year}
    end
  end

  @spec parse_birth_month(NorwegianIdNumber.id_type, String.t) :: {:ok, integer()} | {:error, :invalid_month}
  defp parse_birth_month(:h_number, <<month_first::bytes-size(1)>> <> <<month_second::bytes-size(1)>>) do
    case Integer.parse(month_first) do
      {month_first_int, ""} ->
        {:ok, "#{month_first_int - 4}#{month_second}" |> String.to_integer()}
      _ ->
        {:error, :invalid_month}
    end
  end
  defp parse_birth_month(_, <<month::bytes-size(2)>>) do
    case Integer.parse(month) do
      {month_int, ""} ->
        {:ok, month_int}
      _ ->
        {:error, :invalid_month}
    end
  end

  @spec parse_birth_day(NorwegianIdNumber.id_type, String.t) :: {:ok, integer()} | {:error, :invalid_day}
  defp parse_birth_day(:d_number, <<day_first::bytes-size(1)>> <> <<day_second::bytes-size(1)>>) do
    case Integer.parse(day_first) do
      {day_first_int, ""} ->
        {:ok, "#{day_first_int - 4}#{day_second}" |> String.to_integer()}
      _ ->
        {:error, :invalid_number}
    end
  end
  defp parse_birth_day(_, <<day::bytes-size(2)>>) do
    case Integer.parse(day) do
      {day_int, ""} ->
        {:ok, day_int}
      _ ->
        {:error, :invalid_number}
    end
  end

  @spec get_type(String.t) :: NorwegianIdNumber.id_type
  defp get_type(<<first::bytes-size(1)>> <> <<_second::bytes-size(1)>> <> <<third::bytes-size(1)>> <> _) do
    case {first, third} do
      {first, _third} when first in ["8", "9"] ->
        :fh_number
      {first, _third} when first in ["4", "5", "6", "7"] ->
        :d_number
      {_first, third} when third in ["4", "5"] ->
        :h_number
      _ ->
        :birth_number
    end
  end

  @spec get_century_prefix(integer(), integer()) :: String.t
  defp get_century_prefix(age_group_int, _year_int) when age_group_int >= 0 and age_group_int < 500, do: "19"
  defp get_century_prefix(age_group_int, year_int) when age_group_int >= 500 and age_group_int < 750 and year_int >= 54, do: "18"
  defp get_century_prefix(age_group_int, year_int) when age_group_int >= 900 and age_group_int < 1000 and year_int >= 40, do: "19"
  defp get_century_prefix(_age_group_int, _year_int), do: "20"


  def format_country_uid(
    <<day::bytes-size(2)>> <> <<month::bytes-size(2)>>
    <> <<year::bytes-size(2)>> <> <<age_group::bytes-size(3)>> <> <<control::bytes-size(2)>>,
    _date
  ) do
    day_int = String.to_integer(day)
    year_int = String.to_integer(year)
    age_group_int = String.to_integer(age_group)

    century_prefix =
      cond do
        age_group_int >= 0 and age_group_int < 500 ->
          "19"
        age_group_int >= 500 and age_group_int < 750 and year_int >= 54 ->
          "18"
        age_group_int >= 900 and age_group_int < 1000 and year_int >= 40 ->
          "19"
        true ->
          "20"
      end

    year = "#{century_prefix}#{year}"

    if day_int > 40 do
      "#{day_int - 40}.#{month}.#{year} - #{age_group}#{control}"
    else
      "#{day}.#{month}.#{year} - #{age_group}#{control}"
    end
  end
end
