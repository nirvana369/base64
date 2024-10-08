# Base64
### Base64 implementation for Motoko

## Documentation
* [Installation](###installation)
* [Usage](#usage)
  * [Encode](#base64-encode)
  * [Decode](#base64-decode)
  * [Is valid](#base64-isvalid)
  * [Set is support URI](#base64-setissupporturi)
* [Testing](#testing)
* [Benchmarks](#benchmarks)
* [License](#license)

### Installation

Install with mops

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops add base64
```

Usage

```sh
import {Base64 = Base64Engine, V2} "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64Engine(#v V2, ?isSupportURI);
```

Or

```sh
import Base64 "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64.Base64(#version (Base64.V2), ?isSupportURI);
```

### Base64 encode

Base64.encode(data : FormatType) : Text

Takes a data by format type (text/ byte array) and returns a base64 string

```sh
import {Base64 = Base64Engine, V2} "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64Engine(#v V2, ?isSupportURI);

let bytesData : [Nat8] = [100, 97, 110, 107, 111, 103, 97, 105];
base64.encode(#bytes bytesData);

let textData : Text = "𠮷野家";
let base64EncodeString : Text = base64.encode(#text textData);
```

### Base64 decode

Base64.decode(base64String : Text) : [Nat8]

Takes a base64 string and returns length of byte array

```sh
import {Base64 = Base64Engine, V2} "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64Engine(#v V2, ?isSupportURI);

let base64String : Text = "ZA==";
let bytesArrayDecode : [Nat8] = base64.decode(base64String);
```

### Base64 is valid

Base64.isValid(base64String : Text) : [Nat8]

Takes a base64 string and returns a boolean value

```sh
import {Base64 = Base64Engine, V2} "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64Engine(#v V2, ?isSupportURI);

let base64String : Text = "8KCut+mHjuWutg==";
let isSupportURI : Bool = base64.isValid(base64String);
```

### Base64 set is support uri

Base64.setSupportURI(isSupportURI : Bool)

Base64 uri support ([RFC 4648 §5: base64url (URL- and filename-safe standard)](https://en.wikipedia.org/wiki/Base64#URL_applications))

```sh
import {Base64 = Base64Engine, V2} "mo:base64";

let isSupportURI : Bool = false;
let base64 = Base64Engine(#v V2, ?isSupportURI);

base64.setSupportURI(true);
```


### Testing

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops test
```

### Benchmarks

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops bench
```

## License

MIT
