import Base64 "./base64";

module {

    public type FormatType = Base64.FormatType;
    
    public func encode(data : FormatType, isSupportURI : Bool) : Text {
        let base64 = Base64.Base64(?isSupportURI);
        base64.encode(data);
    };

    public func decode(b64 : Text, isSupportURI : Bool) : [Nat8] {
        let base64 = Base64.Base64(?isSupportURI);
        base64.decode(b64);
    };

    public func isValid(b64 : Text, isSupportURI : Bool) : Bool {
        let base64 = Base64.Base64(?isSupportURI);
        base64.isValid(b64);
    };
}