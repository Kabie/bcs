# Bcs

Pure Elixir encoder for [BCS format](https://github.com/diem/bcs).

## Features

Encoder for:

- [x] Booleans
- [x] Signed 8-bit, 16-bit, 32-bit, 64-bit, and 128-bit integers
- [x] Unsigned 8-bit, 16-bit, 32-bit, 64-bit, and 128-bit integers
- [x] Option
- [ ] Unit (an empty value)
- [x] Fixed and variable length sequences
- [x] UTF-8 Encoded Strings
- [x] Tuples
- [x] Structures (aka “structs”)
- [x] Externally tagged enumerations (aka “enums”)
- [x] Maps


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
