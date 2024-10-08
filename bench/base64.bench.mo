/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : base64.bench.mo
* Description       : Benchmark Base64 engine v1 and v2.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/08/2024		nirvana369 		Add benchmarks.
******************************************************************/

import Bench "mo:bench";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import {Base64 = Base64Engine; V1; V2} "../src/lib";


module {

    func getBase64EncodeBytes() : [Nat8] {
        let MAX_LENGTH = 1024;
        let big = Buffer.Buffer<Nat8>(MAX_LENGTH);
        for (i in Iter.range(1, MAX_LENGTH)) {
            big.add(Nat8.fromNat(i % 256));
        };
        Buffer.toArray(big);
    };

    func getBase64Decode() : Text {
        let MAX_LENGTH = 1024;
        let big = Buffer.Buffer<Nat8>(MAX_LENGTH);
        for (i in Iter.range(1, MAX_LENGTH)) {
            big.add(Nat8.fromNat(i % 256));
        };
        let bytes = Buffer.toArray(big);

        let base64 = Base64Engine(#v V2, null);
        base64.encode(#bytes bytes);
    };

    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("Base64");
        bench.description("Base64 module benchmark");

        bench.rows(["EngineV1.Base64.encode",
                    "EngineV1.Base64.decode",
                    "EngineV1.Base64.isValid",
                    "EngineV2.Base64.encode",
                    "EngineV2.Base64.decode",
                    "EngineV2.Base64.isValid"
                    ]);
        bench.cols(["1", "10", "100", "500"/*, "1000"*/]);

        let base64 = Base64Engine(#v V1, null);
        let base64v2 = Base64Engine(#v V2, null);
        
        bench.runner(func(row, col) {
            let ?n = Nat.fromText(col);

            switch (row) {
                // Engine V1
                case ("EngineV1.Base64.encode") {
                    let bytes = getBase64EncodeBytes();
                    for (i in Iter.range(1, n)) {
                        ignore base64.encode(#bytes bytes);
                    };
                };
                case ("EngineV1.Base64.decode") {
                    let b64 = getBase64Decode();
                    for (i in Iter.range(1, n)) {
                        ignore base64.decode(b64);
                    };
                };
                case ("EngineV1.Base64.isValid") {
                    let b64 = getBase64Decode();
                    for (i in Iter.range(1, n)) {
                        ignore base64.isValid(b64);
                    };
                };
                // Engine V2
                case ("EngineV2.Base64.encode") {
                    let bytes = getBase64EncodeBytes();
                    for (i in Iter.range(1, n)) {
                        ignore base64v2.encode(#bytes bytes);
                    };
                };
                case ("EngineV2.Base64.decode") {
                    let b64 = getBase64Decode();
                    for (i in Iter.range(1, n)) {
                        ignore base64v2.decode(b64);
                    };
                };
                case ("EngineV2.Base64.isValid") {
                    let b64 = getBase64Decode();
                    for (i in Iter.range(1, n)) {
                        ignore base64v2.isValid(b64);
                    };
                };
                case _ {};
            };
        });

        bench;
  };
};