/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : v2engine.mo
* Description       : Base64 version 2 - bitwise processing.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/08/2024		nirvana369 		Implement.
******************************************************************/

import Text "mo:base/Text";
import Option "mo:base/Option";
import Hash "mo:base/Hash";
import Char "mo:base/Char";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Nat32 "mo:base/Nat32";
import Types "./types";

module {

    type FormatType = Types.FormatType;

    public class Base64(isSupportURI : ?Bool) {

        let lookup = HashMap.HashMap<Nat32, Char>(0, Nat32.equal, func (x) : Hash.Hash = x);
        var revLookup = HashMap.HashMap<Char, Nat32>(0, Char.equal, func x : Hash.Hash = Char.toNat32(x));

        let code = Text.toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");

        var _isSupportURI = false;

        private func _initSupportURI(isSupportURI : Bool) {
            if (_isSupportURI != isSupportURI) {
                _isSupportURI := isSupportURI;

                if (_isSupportURI) {
                    revLookup.put('-', 62);
                    revLookup.put('_', 63);
                    lookup.put(62, '-');
                    lookup.put(63, '_');
                } else {
                    revLookup.put('+', 62);
                    revLookup.put('/', 63);
                    lookup.put(62, '+');
                    lookup.put(63, '/');
                };
            };
        };

        private func _init(isSupportURI : Bool) {
            for (i in Iter.range(0, code.size() - 1)) {
                lookup.put(Nat32.fromNat(i), code[i]);
                revLookup.put(code[i], Nat32.fromNat(i));
            };
            _initSupportURI(isSupportURI);
        };

        /**
        * Support decoding URL-safe base64 strings.
        * RFC 4648 §5: base64url (URL- and filename-safe standard)[a]
        * See: https://en.wikipedia.org/wiki/Base64#URL_applications
        **/
        switch (isSupportURI) {
            case(?sp) {
                _init(sp);
            };
            case (null) {
                _init(_isSupportURI);
            };
        };

        public func decode (b64 : Text) : [Nat8] {
            let base64 = Text.toArray(b64);
            var padding = 0;

            var result = Buffer.fromArray<Nat8>([]);
            var bitcount : Nat32 = 0;
            var char : Nat32 = 0;
            for (c in base64.vals()) {
                if (Char.toNat32(c) != 10 and Char.toNat32(c) != 32) {
                    if (c == '=') {
                        padding += 1;
                    } else {
                        let val = Option.get<Nat32>(revLookup.get(c), 0);
                        if (bitcount + 6 >= 8) {
                            let ret = (char << (8 - bitcount) | (val >> (6 - (8 - bitcount)))) & 0xff;
                            result.add(Nat8.fromNat(Nat32.toNat(ret)));
                            bitcount := bitcount + 6 - 8;
                            if (bitcount == 0) {
                                char := 0;
                            } else {
                                char := val;
                            }
                        } else {
                            char := val;
                            bitcount := 6;
                        };
                    };
                };
            };
            (Buffer.toArray(result))
        };

        public func encode (data : FormatType) : Text {
            let bytes = switch(data) {
                case (#text(t)) {
                    Blob.toArray(Text.encodeUtf8(t));
                };
                case (#bytes(arr)) {
                    arr;
                };
            };
            var ret = "";
            var remain : Nat32 = 0;
            var bits : Nat32 = 0;
            var bitcount = 0;
            for (byte in bytes.vals()) {
                bitcount += 8;
                let b = Nat32.fromNat(Nat8.toNat(byte));
                remain += 8;
                bits <<= 8;
                bits |= b;
                while (remain >= 6) {
                    let c = (bits >> (remain - 6)) & 0x3f;
                    let char = Option.get(lookup.get(c), ' ');
                    ret #= Char.toText(char);
                    remain -= 6;
                };
                bits := b & (2 ** remain - 1);
            };

            if (remain != 0) {
                bits <<= (6 - remain);
                bits &= 0x3f;
                let char = Option.get(lookup.get(bits), ' ');
                ret #= Char.toText(char);
            };

            // check special case
            if (_isSupportURI == false) {
                let extraBytes = bitcount % 3;
            
                if (extraBytes > 0) {
                    for (i in Iter.range(1, extraBytes)) ret #= "=";
                };
            };
            (ret)
        };

        public func isValid(b64 : Text) : Bool {
             let base64 = Text.toArray(b64);
             let size : Int = if (base64.size() > 0) {base64.size() - 1} else 0;
             var i = 0;
             for (c in base64.vals()) {
                switch (revLookup.get(c)) {
                    case (?v) {
                        let charBits = Option.get(lookup.get(v), ' ');
                        if (c != charBits) {
                            return false;
                        };
                    };
                    case null {
                        if (Char.toNat32(c) == 10 or Char.toNat32(c) == 32) {
                            ()
                        } else if (c == '=') {
                            if (i != size and i != size - 1) {
                                return false;
                            };
                        } else {
                            return false;
                        };
                    };
                };
                i += 1;
             };
             true;
        };

        public func setSupportURI(isSupportURI : Bool) {
            _initSupportURI(isSupportURI);
        };
    };

}