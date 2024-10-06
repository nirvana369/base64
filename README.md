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
Takes a byte array and returns a base64 string

```sh
Base64.encode(data : [Nat8]) : Text
```
Takes a base64 string and returns length of byte array
```sh
Base64.decode(base64 : Text, isSupportUrlDecode : Bool) : [Nat8]
```

## License

MIT
