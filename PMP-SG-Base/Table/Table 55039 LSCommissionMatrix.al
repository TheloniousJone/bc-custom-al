table 55039 "LS Commission Matrix"
{
    Caption = 'LS Commission Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(4; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(5; Percentage; Decimal)
        {
            Caption = 'Percentage';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if (Percentage < 0) or (Percentage > 100) then
                    Error('Please ensure percentage is between 0 to 100 only.');
            end;
        }
    }
    keys
    {
        key(PK; "Customer Code", "Item Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
        CustRec: Record customer;
        ItemRec: Record item;
    begin
        if Rec."Customer Code" <> xRec."Customer Code" then begin
            CustRec.reset;
            CustRec.get(Rec."Customer Code");
            Rec."Customer Name" := CustRec.Name;

        end;
        if Rec."Item Code" <> xRec."Item Code" then begin
            ItemRec.reset;
            ItemRec.Get(Rec."Item Code");
            Rec."Item Description" := ItemRec.Description;

        end;
    end;

    trigger OnRename()
    var
        myInt: Integer;
        CustRec: Record customer;
        ItemRec: Record item;
    begin
        if Rec."Customer Code" <> xRec."Customer Code" then begin
            CustRec.reset;
            CustRec.get(Rec."Customer Code");
            Rec."Customer Name" := CustRec.Name;

        end;
        if Rec."Item Code" <> xRec."Item Code" then begin
            ItemRec.reset;
            ItemRec.Get(Rec."Item Code");
            Rec."Item Description" := ItemRec.Description;

        end;
    end;

    var
        CustRec: Record Customer;
        ItemRec: Record Item;
}
