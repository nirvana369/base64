import {test; suite} "mo:test";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Base64 "../src";

actor {

    public func runTests() : async () {
    
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
                    assert(Base64.encode(#text (x.input), x.isSupportURI) == x.output);
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
                    assert(Option.get(Text.decodeUtf8(Blob.fromArray(Base64.decode(x.input, x.isSupportURI))), "") == x.output);
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    assert(Base64.isValid(x.output, x.isSupportURI));
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
                    assert(Base64.encode(#bytes (x.input), x.isSupportURI) == x.output);
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
                    assert(Array.equal(Base64.decode(x.input, x.isSupportURI), x.output, Nat8.equal));
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    assert(Base64.isValid(x.output, x.isSupportURI));
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
                    let encode = Base64.encode(#text (x.input), x.isSupportURI);
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
                    let decode = Option.get(Text.decodeUtf8(Blob.fromArray(Base64.decode(x.input, x.isSupportURI))), "");
                    Debug.print(decode);
                    assert(decode == x.output);
                };
            });

            test("isValid", func() {
                for (x in encodeTestVectors.vals()) {
                    assert(Base64.isValid(x.output, x.isSupportURI));
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
                    let encodeNat8 = Base64.encode(#bytes (x.nat8arr), x.isSupportURI);
                    let encodeText = Base64.encode(#text (x.text), x.isSupportURI);
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
                    let decode = Base64.decode(x.input, false);
                    assert(Array.equal(decode, x.output, Nat8.equal));
                };
            });

            test("isValid", func() {
                assert(Base64.isValid("", false) == true);
                assert(Base64.isValid("Z", false) == true);
                assert(Base64.isValid("ZA", false) == true);
                assert(Base64.isValid("ZA=", false) == true);
                assert(Base64.isValid("ZA==", false) == true);
                assert(Base64.isValid("++", false) == true);
                assert(Base64.isValid("+-", true) == false);
                assert(Base64.isValid("+-", false) == false);
                assert(Base64.isValid("--", true) == true);
                assert(Base64.isValid("//", false) == true);
                assert(Base64.isValid("__", true) == true);
                assert(Base64.isValid("/_", false) == false);
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
                    let encodeText = Base64.encode(#text (x.input), x.isSupportURI);
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
                    let decode = Base64.decode(x.input, x.isSupportURI);
                    Debug.print(Text.join(", ", Array.map<Nat8, Text>(decode, func c = Nat8.toText(c)).vals()));
                    Debug.print(Text.join(", ", Array.map<Nat8, Text>(Blob.toArray(Text.encodeUtf8(x.output)), func c = Nat8.toText(c)).vals()));
                    assert(Array.equal(decode, Blob.toArray(Text.encodeUtf8(x.output)), Nat8.equal));
                };
            });

            test("isValid", func() {
                for (x in decodeTestVectors.vals()) {
                    assert(Base64.isValid(x.name, x.isSupportURI));
                };
            });

            let expected : [Nat8] = [0xff, 0xff, 0xbe, 0xff, 0xef, 0xbf, 0xfb, 0xef, 0xff];

            test("url-safe", func() {
                let strA = "//++/++/++//";
                let notSupportURI = Base64.decode(strA, false);
                assert(Array.equal(notSupportURI, expected, Nat8.equal));

                let strB = "__--_--_--__";
                let supportURI = Base64.decode(strB, true);
                assert(Array.equal(supportURI, expected, Nat8.equal));
            });

            test("big-data", func() {
                let MAX_LENGTH = 64 * 1024;
                let big = Buffer.Buffer<Nat8>(MAX_LENGTH);
                for (i in Iter.range(1, MAX_LENGTH)) {
                    big.add(Nat8.fromNat(i % 256));
                };

                let base64 = Base64.encode(#bytes (Buffer.toArray<Nat8>(big)), false);
                let base64Decode = Base64.decode(base64, false);
                assert(Array.equal<Nat8>(Buffer.toArray<Nat8>(big), base64Decode, Nat8.equal));
            });
        });

    };
}