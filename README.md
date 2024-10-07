# Base64
### Base64 implementation for Motoko

## Documentation

### Installation

Install with mops

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops add base64
```
### Testing

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops test
```

### Usage

```sh
import Base64 "mo:base64";
```
Takes a data by format type (text/ byte array) and returns a base64 string

```sh
Base64.encode(data : FormatType, isSupportURI : Bool) : Text
```

Takes a base64 string and returns length of byte array

```sh
Base64.decode(base64 : Text, isSupportURI : Bool) : [Nat8]
```

## License

MIT
