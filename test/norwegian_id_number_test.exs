defmodule NorwegianIdNumberTest do
  use ExUnit.Case
  doctest NorwegianIdNumber

  describe "junk input" do
    test "non integers" do
      refute NorwegianIdNumber.is_valid?("8123456A8B2")
    end

    test "invalid length" do
      refute NorwegianIdNumber.is_valid?("812345678021")
    end
  end

  describe "FH number" do
    test "valid" do
      assert NorwegianIdNumber.is_valid?("81234567802")
    end

    test "invalid" do
      refute NorwegianIdNumber.is_valid?("81234567803")
    end
  end

  describe "H number" do
    test "valid" do
      assert NorwegianIdNumber.is_valid?("01415612385")
    end

    test "invalid" do
      refute NorwegianIdNumber.is_valid?("01535612304")
    end
  end

  describe "D number" do
    test "valid" do
      assert NorwegianIdNumber.is_valid?("42059199212")
    end

    test "invalid" do
      refute NorwegianIdNumber.is_valid?("42059199252")
    end
  end

  describe "Useful info" do
    test "extract type" do
      {:ok, parsed} = NorwegianIdNumber.parse("42059199212")
      assert parsed.id_type === :d_number
      {:ok, parsed} = NorwegianIdNumber.parse("01415612385")
      assert parsed.id_type === :h_number
      {:ok, parsed} = NorwegianIdNumber.parse("81234567802")
      assert parsed.id_type === :fh_number
    end

    test "extract birth day" do
      {:ok, parsed} = NorwegianIdNumber.parse("42059199212")
      assert parsed.birth_day === 2
      {:ok, parsed} = NorwegianIdNumber.parse("01415612385")
      assert parsed.birth_day === 1
    end

    test "extract birth month" do
      {:ok, parsed} = NorwegianIdNumber.parse("42059199212")
      assert parsed.birth_month === 5
      {:ok, parsed} = NorwegianIdNumber.parse("01415612385")
      assert parsed.birth_month === 1
    end

    test "extract birth year" do
      {:ok, parsed} = NorwegianIdNumber.parse("42059199212")
      assert parsed.birth_year === 1991
      {:ok, parsed} = NorwegianIdNumber.parse("01415612385")
      assert parsed.birth_year === 1956
    end

    test "extract personal number" do
      {:ok, parsed} = NorwegianIdNumber.parse("42059199212")
      assert parsed.personal_number === "99212"
      {:ok, parsed} = NorwegianIdNumber.parse("01415612385")
      assert parsed.personal_number === "12385"
    end
  end

  describe "Rendering" do
    test "raw" do
      assert NorwegianIdNumber.render("42059199212") === "02.05.1991 - 99212"
      assert NorwegianIdNumber.render("01415612385") === "01.01.1956 - 12385"
    end
  end
end
