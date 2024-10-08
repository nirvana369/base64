/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : base64v1.mo
* Description       : Base64 version 1.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/07/2024		nirvana369 		Implement.
******************************************************************/

import Text "mo:base/Text";
import Option "mo:base/Option";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Char "mo:base/Char";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Types "./types";

module {

    type FormatType = Types.FormatType;

    public class Base64(isSupportURI : ?Bool) {

        let charhash = func (x : Char) : Hash.Hash = Char.toNat32(x); 

        let lookup = HashMap.HashMap<Text, Char>(0, Text.equal, Text.hash);
        var revLookup = HashMap.HashMap<Char, [Bool]>(0, Char.equal, charhash);

        let code = Text.toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");

        var _isSupportURI = false;

        private func _initSupportURI(isSupportURI : Bool) {
            if (_isSupportURI != isSupportURI) {
                _isSupportURI := isSupportURI;

                let b62 = byte2bits<Bool>(62, func z = z, 6);
                let b63 = byte2bits<Bool>(63, func z = z, 6);
                let bits62 = Text.join("", Array.map<Bool, Text>(b62, func z = if (z) "1" else "0").vals());
                let bits63 = Text.join("", Array.map<Bool, Text>(b63, func z = if (z) "1" else "0").vals());

                if (_isSupportURI) {
                    revLookup.put('-', b62);
                    revLookup.put('_', b63);
                    lookup.put(bits62, '-');
                    lookup.put(bits63, '_');
                } else {
                    revLookup.put('+', b62);
                    revLookup.put('/', b63);
                    lookup.put(bits62, '+');
                    lookup.put(bits63, '/');
                };
            };
        };

        private func _init(isSupportURI : Bool) {
            for (i in Iter.range(0, code.size() - 1)) {
                let b = byte2bits<Bool>(i, func z = z, 6);
                lookup.put(Text.join("", Array.map<Bool, Text>(b, func z = if (z) "1" else "0").vals()), code[i]);
                revLookup.put(code[i], b);
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

            var buf = Buffer.fromArray<Bool>([]);
            for (c in base64.vals()) {
                if (Char.toNat32(c) == 10 or Char.toNat32(c) == 32) {
                    ()
                } else if (c == '=') {
                    padding += 1;
                } else {
                    buf.append(Buffer.fromArray(Option.get<[Bool]>(revLookup.get(c), [])));
                };
            };
            if (padding > 0) {
                buf := Buffer.subBuffer<Bool>(buf, 0, 8 * (buf.size() / 8));
            };
            // check special case
            if (_isSupportURI == true) {
                if (buf.size() % 8 != 0) {
                    buf := Buffer.subBuffer<Bool>(buf, 0, 8 * (buf.size() / 8));
                };
            };
            let ret = bits2bytes<Bool>(Buffer.toArray(buf), func i = i);
            (ret)
        };

        public func encode (data : FormatType) : Text {
            let bits = switch(data) {
                case (#text(t)) {
                    bytes2bits<Bool>(Blob.toArray(Text.encodeUtf8(t)), func i = i);
                };
                case (#bytes(arr)) {
                    bytes2bits<Bool>(arr, func i = i);
                };
            };
            var buf = Buffer.fromArray<Bool>([]);
            var ret = "";
            var i = 0;
            label process loop {
                if (i < bits.size()) {
                    buf.add(bits[i]);

                    if (buf.size() == 6) {
                        let v = lookup.get(Text.join("", Buffer.map<Bool, Text>(buf, func z = if (z) "1" else "0").vals()));
                        ret #= Char.toText(Option.get<Char>(v, ' '));
                        buf := Buffer.fromArray<Bool>([]);
                    };
                } else {

                    if (buf.size() > 0) {
                        let last = rpad<Bool>(Buffer.toArray(buf), false, 6);
                        let v = lookup.get(Text.join("", Array.map<Bool, Text>(last, func z = if (z) "1" else "0").vals()));
                        ret #= Char.toText(Option.get<Char>(v, ' '));
                    };
                    break process;
                };
                i += 1;
            };
            // check special case
            if (_isSupportURI == false) {
                let extraBytes = bits.size() % 3;
            
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
                        let charBits = Option.get(lookup.get(Text.join("", Array.map<Bool, Text>(v, func z = if (z) "1" else "0").vals())), ' ');
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


    //////////////// BIT PROCESSING //////////////////
    /**
    *   put value v to left of arr
    *   function make sure arr.size() == size
    **/
    func lpad<K>(arr : [K], v : K, size : Nat) : [K] {
        if (size <= arr.size()) return arr;
        let l = Array.tabulate<K>(size - arr.size(), func i = v);
        Array.flatten([l, arr]);
    };

    /**
    *   put value v to right of arr
    *   function make sure arr.size() == size
    **/
    func rpad<K>(arr : [K], v : K, size : Nat) : [K] {
        if (size <= arr.size()) return arr;
        let r = Array.tabulate<K>(size - arr.size(), func i = v);
        Array.flatten([arr, r]);
    };

    /**
    *   Convert bytes array ([Nat8]) to binary array (with K type)
    *   [K] = any [1,0,1,0,1,0,1,0,1,0] or [true, false, true, false, true, false]
    *
    **/
    func bytes2bits<K>(arr : [Nat8], f : (Bool) -> (K)) : [K] {
        let buf = Buffer.fromArray<K>([]);
        for (byte in arr.vals()) {
            let bits = Buffer.fromArray<K>(byte2bits<K>(Nat8.toNat(byte), f, 8));
            buf.append(bits);
        };
        Buffer.toArray(buf);
    };

    /**
    *   Convert binary array (with K type) to bytes array
    *   [K] = any [1,0,1,0,1,0,1,0,1,0] or [true, false, true, false, true, false]
    *
    **/
    func bits2bytes<K>(bits : [K], f : (K) -> (Bool)) : [Nat8] {
        assert(bits.size() % 8 == 0);
        var i = 0;
        let r = Buffer.Buffer<Nat8>(0);
        while (i < bits.size()) {
            let byte = bits2byte<K>(Array.subArray<K>(bits, i, 8), f);
            r.add(Nat8.fromNat(Int.abs(byte)));
            i += 8;
        };
        Buffer.toArray(r);
    };

    // convert int to binary array & padding binary array size = bitSize (BE)
    func byte2bits<K>(num : Int, f : (Bool) -> (K), bitSize : Nat) : [K] {
        if (num == 0) {
            return Array.map(Array.tabulate<Bool>(bitSize, func x = false), f);
        };
        var ret = Buffer.Buffer<Bool>(1);
        var n = num;
        while (n > 0) {
            let val = ((n % 2) == 1);
            ret.add(val);
            n /= 2;
        };
        // padding 0 to right
        if (ret.size() < bitSize) {
            let expectSize = if (ret.size() % bitSize == 0) ret.size() else (ret.size() + (bitSize - ret.size() % bitSize));
            while (ret.size() < expectSize) {
                ret.add(false);
            };
        };

        // reverse & mapping
        let result = Buffer.Buffer<K>(ret.size());
        var j = ret.size();
        for (i in Iter.range(0, ret.size() - 1)) {
             j -= 1;
            result.add(f(ret.get(j)));
        };

        Buffer.toArray(result);
    };

    // convert binary array to int
    func bits2byte<K>(bin : [K], f : K -> Bool) : Int {
        let arr = Array.map<K, Bool>(Array.reverse(bin), f);
        var ret : Int = 0;
        for (i in Iter.range(0, arr.size() - 1)) {
            if (arr[i]) {
                ret := ret + (2 ** i);
            };
        };
        return ret;
    };
}