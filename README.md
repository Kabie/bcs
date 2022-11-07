# Bcs

Pure Elixir encoder/decoder for [BCS format](https://github.com/diem/bcs).

## Features

Encoder/Decoder for:

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


## Usage

```elixir
# Define the struct
defmodule MyStruct do
  @derive {Bcs.Struct,
    label: :string,
    chars: [:u8 | 4],  # <<= we use improper list for fixed length array
    boolean: :bool,
    maps: %{:u8 => :string},
  }

  defstruct [:label, :chars, :boolean, :maps, :field]
end

my_struct = %MyStruct{
  label: "hello",
  chars: 'abcd',
  boolean: true,
  maps: %{1 => "1", 2 => "2"},
  field: "this field will be ignored"
}

# encode
my_struct
|> Bcs.encode()
# then decode
|> Bcs.decode(MyStruct)
```

## Define field Types

 Rust Type   | Syntax
-------------|-------------
 `u8`, `s8`, `u16`, `u256`, ...   | `:u8`, `:s8`, `:u16`, `:u256`, ...
 `bool`      |  `:bool`
 `Option<T>` | `[t \| nil]`
 `[T]`       | `[t]`
 `[T; N]`    | `[t \| n]`
 `String`    | `:string`
 `(T1, T2)`  | `{t1, t2}`
 `MyStruct`  | `MyStruct`
 `enum E`    | `E`
 `Map<K, V>` | `%{k => v}`

### Define Tagged Enums

```elixir
defmodule Foo do
  use Bcs.TaggedEnum, [
    {:variant0, :u16},
    {:variant1, :u8},
    {:variant2, :string},
    :variant3
  ]
end
```

Some valid values for type `Foo`: `{:variant0, 42}`, `{:variant2, "hello"}`, `:variant3`, etc.
