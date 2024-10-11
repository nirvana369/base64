/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : lib.mo
* Description       : Base64 library interface
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/07/2024		nirvana369 		Implement.
* 10/08/2024        nirvana369      Implement base64 factory
******************************************************************/

import Types "./types";
import EngineV1 "./base64v1";
import EngineV2 "./base64v2";
import Text "mo:base/Text";

module {

    public type FormatType = Types.FormatType;

    public type Version = {
        #version : Text;
        #ver : Text;
        #v : Text;
    };

    public let V1 = Types.V1;
    public let V2 = Types.V2;

    public class Base64(version : Version, isSupportURI : ?Bool) {

        let engine = switch (version) {
            case (#version(index)) {
                if (index == V1) {
                    EngineV1.Base64(isSupportURI);
                } else {
                    EngineV2.Base64(isSupportURI);
                };
            };
            case (#ver(index)) {
                if (index == V1) {
                    EngineV1.Base64(isSupportURI);
                } else {
                    EngineV2.Base64(isSupportURI);
                };
            };
            case (#v(index)) {
                if (index == V1) {
                    EngineV1.Base64(isSupportURI);
                } else {
                    EngineV2.Base64(isSupportURI);
                };
            };
        };

        public func decode (b64 : Text) : [Nat8] {
            engine.decode(b64);
        };

        public func encode (data : Types.FormatType) : Text {
            engine.encode(data);
        };

        public func isValid(b64 : Text) : Bool {
            engine.isValid(b64);
        };

        public func setSupportURI(isSupportURI : Bool) {
            engine.setSupportURI(isSupportURI);
        };
    };
}