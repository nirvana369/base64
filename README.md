[![mops](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/mops/base64)](https://mops.one/base64) [![documentation](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/documentation/base64)](https://mops.one/base64/docs)
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

### Usage

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

Instructions
||1|	10|	100|	500|
|---|---|---|---|---|
|EngineV1.Base64.encode|	53_185_077|	527_312_719|	5_268_604_248|	26_339_781_620|
|EngineV1.Base64.decode|	21_661_160|	198_741_071|	1_969_537_568|	9_839_736_894|
|EngineV1.Base64.isValid|	22_465_115|	206_773_229|	2_049_853_988|	10_241_327_716|
|EngineV2.Base64.encode|	1_820_700|	13_680_140|	132_273_539|	659_354_371|
|EngineV2.Base64.decode|	4_198_463|	24_102_850|	223_145_595|	1_107_779_937|
|EngineV2.Base64.isValid|	4_014_300|	22_255_564|	204_666_459|	1_015_381_137|

Heap
||1|	10|	100|	500|
|---|---|---|---|---|
|EngineV1.Base64.encode|	244 B|	244 B|	280 B|	280 B|
|EngineV1.Base64.decode|	352 B|	352 B|	388 B|	388 B|
|EngineV1.Base64.isValid|	352 B|	352 B|	388 B|	388 B|
|EngineV2.Base64.encode|	352 B|	352 B|	352 B|	352 B|
|EngineV2.Base64.decode|	352 B|	352 B|	352 B|	388 B|
|EngineV2.Base64.isValid|	352 B|	352 B|	352 B|	352 B|

Garbage Collection
||1|	10|	100|	500|
|---|---|---|---|---|
|EngineV1.Base64.encode|	4.2 MiB|	41.91 MiB|	418.98 MiB|	2.05 GiB|
|EngineV1.Base64.decode|	1.26 MiB|	11.82 MiB|	117.46 MiB|	586.99 MiB|
|EngineV1.Base64.isValid|	955.36 KiB|	8.58 MiB|	85.02 MiB|	424.79 MiB|
|EngineV2.Base64.encode|	67.73 KiB|	596.52 KiB|	5.75 MiB|	28.7 MiB|
|EngineV2.Base64.decode|	150.68 KiB|	736.66 KiB|	6.44 MiB|	31.88 MiB|
|EngineV2.Base64.isValid|	154.97 KiB|	779.59 KiB|	6.86 MiB|	33.97 MiB|

## License

MIT
