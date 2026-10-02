tableextension 55043 TransferShptHeaderTblExt extends "Transfer Shipment Header"
{
    fields
    {
        field(55000; "Transfer-To Bin Code"; Code[20])
        {
            Caption = 'Transfer-To Bin Code';
            DataClassification = ToBeClassified;
        }

        field(55001; "Remarks"; Text[500])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(55002; "No. of Carton"; Text[100])
        {
            Caption = 'No. of Carton';
            DataClassification = ToBeClassified;
        }
        field(55003; "TO Created By"; Code[20])
        {
            Caption = 'TO Created By';
            DataClassification = ToBeClassified;
        }
        field(55004; I9G_DriverCode; Code[20])
        {
            Caption = 'Driver Code';
            TableRelation = "Delivery Zone";
        }
        field(55005; I9G_DeliveryChargeCode; Code[20])
        {
            Caption = 'Delivery Charge Code';
            TableRelation = "Delivery Charge";
        }
    }
}
