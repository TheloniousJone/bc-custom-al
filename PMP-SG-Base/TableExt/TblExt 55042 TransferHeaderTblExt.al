tableextension 55042 TransferHeaderBaseTblExt extends "Transfer Header"
{
    fields
    {
        field(55000; "Transfer-To Bin Code"; Code[20])
        {
            Caption = 'Transfer-To Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"));

            trigger OnValidate()
            var
                Location: Record Location;
                Bin: Record Bin;
                Customer: Record Customer;
            begin
                TestField("Transfer-to Code");
                if "Transfer-To Bin Code" <> '' then begin
                    Location.Get("Transfer-to Code");
                    Location.TestField("Bin Mandatory");
                    Location.TestField("Directed Put-away and Pick", false);
                    Bin.Get("Transfer-to Code", "Transfer-To Bin Code");
                    TestField("Transfer-to Code", Bin."Location Code");

                    Customer.Reset();
                    if Customer.Get("Transfer-To Bin Code") then begin
                        I9G_DriverCode := Customer."Delivery Zone";
                        I9G_DeliveryChargeCode := Customer."Delivery Charge";
                    end;
                end;
            end;
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
    trigger OnAfterInsert()
    begin
        rec.Validate("TO Created By", UserId);
        rec.Modify(true);
    end;
}
