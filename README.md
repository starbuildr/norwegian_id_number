# NorwegianIdNumber

Ease way to parse and validate Norwegian governmental identification numbers.

We don't extract a gender information as it's no longer encoded since 2017.

We also don't check if the age derived from a number makes sense.

## Usage

Parsing: `NorwegianIdNumber.parse("81234567802") === {:ok, %NorwegianIdNumber{}}`
Validation: `NorwegianIdNumber.is_valid?("81234567802") === true`
Rendering: `NorwegianIdNumber.render("01415612385") === "01.01.1956 - 12385"`

## Installation

Add `norwegian_id_number` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:norwegian_id_number, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/norwegian_id_number](https://hexdocs.pm/norwegian_id_number).

