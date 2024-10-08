/*******************************************************************
* Copyright         : 2024 nirvana369
* File Name         : types.mo
* Description       : Base64 types.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 10/07/2024		nirvana369 		Implement.
******************************************************************/

module {

    public type FormatType = {
        #text : Text;
        #bytes : [Nat8];
    };

    public let V1 = "1";
    public let V2 = "2";
}