tableextension 80154 ShipToAddress3PL extends "Ship-to Address"
{
    fields
    {
        field(80130; "I9G_DeliveryZone"; Code[20])
        {
            Caption = 'Delivery Zone';
            TableRelation = "Delivery Zone";
        }
        field(80131; "I9G_DeliveryCharge"; Code[20])
        {
            Caption = 'Delivery Charge';
            TableRelation = "Delivery Charge";
        }
        field(80132; "I9G_NovemCustNoOfCopies"; Integer)
        {
            Caption = 'Novem Cust. No. Of Copies';
        }
        modify(Code)
        {
            trigger OnAfterValidate()
            var
            begin
                I9G_NovemCustNoOfCopies := 1;
            end;
        }
    }
}