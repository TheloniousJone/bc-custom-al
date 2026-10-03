table 60101 GroupPrice
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Currency; Text[10]) { }
        field(2; "Customer Group No."; Text[20]) { }
        field(3; "Item No."; Text[20]) { }
        field(4; "Product Name"; Text[100]) { }
        field(5; UOM; Text[10]) { }
        field(6; "FromDate"; Date) { }
        field(7; "ToDate"; Date) { }
        field(8; "Quantity"; Decimal) { }
        field(9; Price; Decimal)
        {
            AutoFormatExpression = "Currency";
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(10; "Rec ID"; Text[20]) { }
        field(11; "Have Bonus"; Boolean) { }
    }

    keys
    {
        key(PK; "Item No.", "Customer Group No.", Quantity, FromDate, ToDate, UOM)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}