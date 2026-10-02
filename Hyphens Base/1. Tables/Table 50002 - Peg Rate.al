table 50002 "Peg Rate"
{
    Caption = 'Peg Rate';
    // DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Type"; Option)
        {
            Caption = 'Item Type';
            DataClassification = ToBeClassified;
            OptionMembers = Specific,Group;
        }

        field(10; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
            TableRelation = if ("Item Type" = const(Specific)) Item."No."
            else
            if ("Item Type" = const(Group)) "Hyphens Item Group".Code;

            trigger OnValidate()
            var
                ItemRec: Record Item;
                ItemComGroup: Record "Hyphens Item Group";
            begin
                "Item Description" := '';

                if "Item Type" = "Item Type"::Group then begin
                    if ItemComGroup.Get("Item Code") then
                        "Item Description" := ItemComGroup.Description;
                end;

                if "Item Type" = "Item Type"::Specific then begin
                    if ItemRec.Get("Item Code") then
                        "Item Description" := ItemRec.Description;
                end;
            end;
        }

        field(20; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }

        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                CustRec: Record Customer;
            begin
                "Customer Name" := '';

                if CustRec.Get("Customer No.") then
                    "Customer Name" := CustRec.Name;
            end;
        }

        field(40; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }

        field(50; Currency; Code[10])
        {
            Caption = 'Currency';
            TableRelation = Currency.Code;
        }

        field(60; "Peg Rate"; Decimal)
        {
            Caption = 'Peg Rate';
        }

        field(70; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }

        field(80; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(90; "Wholesale Price"; Decimal)
        {

        }
    }

    keys
    {
        key(PK; "Item Type", "Item Code", "Customer No.", Currency, "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

}