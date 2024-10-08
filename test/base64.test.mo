/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : base64.test.mo
* Description       : Base64 version 1.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/07/2024		nirvana369 		Add test case
******************************************************************/

import {test; suite} "mo:test";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import {Base64 = Base64Engine; V1; V2} "../src";

actor {

    public func runTests() : async () {

        let version = V2;
        let Base64 = Base64Engine(#v version, ?false); 
    
        suite("Base64", func() {
            let encodeTestVectors = [
                { 
                    name = "d";
                    input = "d";
                    output = "ZA==";
                    isSupportURI = false;
                },
                { 
                    name = "da";
                    input = "da";
                    output = "ZGE=";
                    isSupportURI = false;
                },
                { 
                    name = "dan";
                    input = "dan";
                    output = "ZGFu";
                    isSupportURI = false;
                }
            ];

            test("encode", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.encode(#text (x.input)) == x.output);
                };
            });

            let decodeTestVectors = [
                { 
                    name = "ZA==";
                    input = "ZA==";
                    output = "d";
                    isSupportURI = false;
                },
                { 
                    name = "ZGE=";
                    input = "ZGE=";
                    output = "da";
                    isSupportURI = false;
                },
                { 
                    name = "ZGFu";
                    input = "ZGFu";
                    output = "dan";
                    isSupportURI = false;
                },
                { 
                    name = "Z A==";
                    input = "Z A==";
                    output = "d";
                    isSupportURI = false;
                },
                { 
                    name = "ZG E=";
                    input = "ZG E=";
                    output = "da";
                    isSupportURI = false;
                },
                { 
                    name = "ZGF u";
                    input = "ZGF u";
                    output = "dan";
                    isSupportURI = false;
                }
            ];

            test("decode", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Option.get(Text.decodeUtf8(Blob.fromArray(Base64.decode(x.input))), "") == x.output);
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.isValid(x.output));
                };
            });
        });


        suite("Base64-2", func() {
            let encodeTestVectors = [
                { 
                    name = "[0]";
                    input : [Nat8] = [0];
                    output = "AA==";
                    isSupportURI = false;
                },
                { 
                    name = "[0, 0]";
                    input : [Nat8] = [0, 0];
                    output = "AAA=";
                    isSupportURI = false;
                },
                { 
                    name = "[0, 0, 0]";
                    input : [Nat8] = [0, 0, 0];
                    output = "AAAA";
                    isSupportURI = false;
                }
            ];

            test("encode", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.encode(#bytes (x.input)) == x.output);
                };
            });

            let decodeTestVectors = [
                { 
                    name = "AA==";
                    input = "AA==";
                    output : [Nat8] = [0];
                    isSupportURI = false;
                },
                { 
                    name = "AAA=";
                    input = "AAA=";
                    output : [Nat8] = [0, 0];
                    isSupportURI = false;
                },
                { 
                    name = "AAAA";
                    input = "AAAA";
                    output : [Nat8] = [0, 0, 0];
                    isSupportURI = false;
                }
            ];

            test("decode", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Array.equal(Base64.decode(x.input), x.output, Nat8.equal));
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.isValid(x.output));
                };
            });
        });

        suite("Base64-3", func() {
            let encodeTestVectors = [
                { 
                    name = "小飼弾";
                    input = "小飼弾";
                    output = "5bCP6aO85by+";
                    isSupportURI = false;
                },
                { // URI
                    name = "小飼弾";
                    input = "小飼弾";
                    output = "5bCP6aO85by-";
                    isSupportURI = true;
                }
            ];

            test("encode", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let encode = Base64.encode(#text (x.input));
                    Debug.print(encode);
                    assert(encode == x.output);
                };
            });

            let decodeTestVectors = [
                { 
                    name = "5bCP6aO85by+";
                    input = "5bCP6aO85by+";
                    output = "小飼弾";
                    isSupportURI = false;
                },
                { 
                    name = "5bCP6aO85by-";
                    input = "5bCP6aO85by-";
                    output = "小飼弾";
                    isSupportURI = true;
                }
            ];

            test("decode", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let decode = Option.get(Text.decodeUtf8(Blob.fromArray(Base64.decode(x.input))), "");
                    Debug.print(decode);
                    assert(decode == x.output);
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.isValid(x.output));
                };
            });
        });

        suite("Base64-3", func() {

            let encodeTestVectors = [
                {
                    name = "dankogai";
                    nat8arr : [Nat8] = [100, 97, 110, 107, 111, 103, 97, 105];
                    text = "dankogai";
                    isSupportURI = false;
                },
                {
                    name = "dankoga";
                    nat8arr : [Nat8] = [100, 97, 110, 107, 111, 103, 97];
                    text = "dankoga";
                    isSupportURI = false;
                },
                {
                    name = "dankog";
                    nat8arr : [Nat8] = [100, 97, 110, 107, 111, 103];
                    text = "dankog";
                    isSupportURI = false;
                },
                {
                    name = "danko";
                    nat8arr : [Nat8] = [100, 97, 110, 107, 111];
                    text = "danko";
                    isSupportURI = false;
                },
                {
                    name = "dank";
                    nat8arr : [Nat8] = [100, 97, 110, 107];
                    text = "dank";
                    isSupportURI = false;
                },
                {
                    name = "dan";
                    nat8arr : [Nat8] = [100, 97, 110];
                    text = "dan";
                    isSupportURI = false;
                },
                {
                    name = "da";
                    nat8arr : [Nat8] = [100, 97];
                    text = "da";
                    isSupportURI = false;
                },
                {
                    name = "d";
                    nat8arr : [Nat8] = [100];
                    text = "d";
                    isSupportURI = false;
                },
                {
                    name = "";
                    nat8arr : [Nat8] = [];
                    text = "";
                    isSupportURI = false;
                }
            ];

            test("encode", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let encodeNat8 = Base64.encode(#bytes (x.nat8arr));
                    let encodeText = Base64.encode(#text (x.text));
                    Debug.print(encodeNat8);
                    Debug.print(encodeText);
                    assert(encodeNat8 == encodeText);
                };
            });

            let decodeTestVectors = [
                {
                    name = "ZGFua29nYWk=";
                    input = "ZGFua29nYWk=";
                    output : [Nat8] = [100,97,110,107,111,103,97,105];
                    isSupportURI = false;
                },
                {
                    name = "ZGFua29nYQ==";
                    input = "ZGFua29nYQ==";
                    output : [Nat8] = [100,97,110,107,111,103,97];
                    isSupportURI = false;
                },
                {
                    name = "ZGFua29n";
                    input = "ZGFua29n";
                    output : [Nat8] = [100,97,110,107,111,103];
                    isSupportURI = false;
                },
                {
                    name = "ZGFua28=";
                    input = "ZGFua28=";
                    output : [Nat8] = [100,97,110,107,111];
                    isSupportURI = false;
                },
                {
                    name = "ZGFuaw==";
                    input = "ZGFuaw==";
                    output : [Nat8] = [100,97,110,107];
                    isSupportURI = false;
                },
                {
                    name = "ZGFu";
                    input = "ZGFu";
                    output : [Nat8] = [100,97,110];
                    isSupportURI = false;
                },
                {
                    name = "ZGE=";
                    input = "ZGE=";
                    output : [Nat8] = [100,97];
                    isSupportURI = false;
                },
                {
                    name = "ZA==";
                    input = "ZA==";
                    output : [Nat8] = [100];
                    isSupportURI = false;
                },
                {
                    name = "";
                    input = "";
                    output : [Nat8] = [];
                    isSupportURI = false;
                }
            ];

            test("decode", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let decode = Base64.decode(x.input);
                    assert(Array.equal(decode, x.output, Nat8.equal));
                };
            });
            let isValidTestVector = [
                {
                    input = "";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "Z";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "ZA";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "ZA=";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "ZA==";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "++";
                    output = false;
                    isSupportURI = true;
                },
                {
                    input = "+-";
                    output = false;
                    isSupportURI = true;
                },
                {
                    input = "+-";
                    output = false;
                    isSupportURI = false;
                },
                {
                    input = "--";
                    output = true;
                    isSupportURI = true;
                },
                {
                    input = "//";
                    output = true;
                    isSupportURI = false;
                },
                {
                    input = "__";
                    output = true;
                    isSupportURI = true;
                },
                {
                    input = "/_";
                    output = false;
                    isSupportURI = false;
                }
            ];

            test("isValid", func() {
                for (x in isValidTestVector.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.isValid(x.input) == x.output);
                };
            });
        });

        suite("Base64-3", func() {

            let encodeTestVectors = [
                {
                    name = "𠮷野家";
                    input = "𠮷野家";
                    output = "8KCut+mHjuWutg==";
                    isSupportURI = false;
                },
                {
                    name = "𠮷野家";
                    input = "𠮷野家";
                    output = "8KCut-mHjuWutg";
                    isSupportURI = true;
                }
            ];

            test("encode", func() {
                for (x in encodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let encodeText = Base64.encode(#text (x.input));
                    Debug.print(encodeText);
                    assert(x.output == encodeText);
                };
            });

            let decodeTestVectors = [
                {
                    name = "8KCut+mHjuWutg==";
                    input = "8KCut+mHjuWutg==";
                    output = "𠮷野家";
                    isSupportURI = false;
                },
                {
                    name = "8KCut-mHjuWutg";
                    input = "8KCut-mHjuWutg";
                    output = "𠮷野家";
                    isSupportURI = true;
                },
                {
                    name = "8KCut-mHjuWut_";
                    input = "8KCut-mHjuWut_";
                    output = "𠮷野宷";
                    isSupportURI = true;
                }
            ];

            test("decode", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    let decode = Base64.decode(x.input);
                    Debug.print(Text.join(", ", Array.map<Nat8, Text>(decode, func c = Nat8.toText(c)).vals()));
                    Debug.print(Text.join(", ", Array.map<Nat8, Text>(Blob.toArray(Text.encodeUtf8(x.output)), func c = Nat8.toText(c)).vals()));
                    assert(Array.equal(decode, Blob.toArray(Text.encodeUtf8(x.output)), Nat8.equal));
                };
            });

            test("isValid", func() {
                for (x in decodeTestVectors.vals()) {
                    Base64.setSupportURI(x.isSupportURI);
                    assert(Base64.isValid(x.name));
                };
            });

            let expected : [Nat8] = [0xff, 0xff, 0xbe, 0xff, 0xef, 0xbf, 0xfb, 0xef, 0xff];

            test("url-safe", func() {
                let strA = "//++/++/++//";
                Base64.setSupportURI(false);
                let notSupportURI = Base64.decode(strA);
                assert(Array.equal(notSupportURI, expected, Nat8.equal));

                let strB = "__--_--_--__";
                Base64.setSupportURI(true);
                let supportURI = Base64.decode(strB);
                assert(Array.equal(supportURI, expected, Nat8.equal));
            });

            test("big-data", func() {
                let MAX_LENGTH = 64 * 1024;
                let big = Buffer.Buffer<Nat8>(MAX_LENGTH);
                for (i in Iter.range(1, MAX_LENGTH)) {
                    big.add(Nat8.fromNat(i % 256));
                };
                Base64.setSupportURI(false);
                let base64 = Base64.encode(#bytes (Buffer.toArray<Nat8>(big)));
                let base64Decode = Base64.decode(base64);
                assert(Array.equal<Nat8>(Buffer.toArray<Nat8>(big), base64Decode, Nat8.equal));
            });
        });

    };
}