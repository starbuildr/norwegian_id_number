# NorwegianIdNumber

Ease way to parse and validate Norwegian governmental identification numbers.

We don't extract a gender information as it's no longer encoded since 2017.

We also don't check if the age derived from a number makes sense.

## Usage

### Parsing

* `NorwegianIdNumber.parse("81234567802") === {:ok, %NorwegianIdNumber{}}`
* `NorwegianIdNumber.parse("812345678A2") === {:error, :invalid_number}`

### Validation

* `NorwegianIdNumber.is_valid?("81234567802") === true`
* `NorwegianIdNumber.is_valid?("812345678A2") === false`

### Rendering

* `NorwegianIdNumber.render("01415612385") === "01.01.1956 - 12385"`
* `NorwegianIdNumber.render("01415612385", :birthdate) === "01.01.1956"`

### Structure

```
%NorwegianIdNumber{
  id_type: :fh_number | :d_number | :h_number | :birth_number,
  birth_day: integer(),
  birth_month: integer(),
  birth_year: integer(),
  personal_number: String.t,
  raw: String.t
}
```

## Installation

Add `norwegian_id_number` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:norwegian_id_number, "~> 0.1.0"}
  ]
end
```
