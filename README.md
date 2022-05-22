# Bcs

Elixir encoder for [bcs format](https://github.com/diem/bcs).

## WIP

Encoder for:

- [x] Booleans
- [x] Signed 8-bit, 16-bit, 32-bit, 64-bit, and 128-bit integers
- [x] Unsigned 8-bit, 16-bit, 32-bit, 64-bit, and 128-bit integers
- [ ] Option
- [ ] Unit (an empty value)
- [ ] Fixed and variable length sequences
- [ ] UTF-8 Encoded Strings
- [ ] Tuples
- [ ] Structures (aka “structs”)
- [ ] Externally tagged enumerations (aka “enums”)
- [ ] Maps


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bcs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bcs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bcs>.

