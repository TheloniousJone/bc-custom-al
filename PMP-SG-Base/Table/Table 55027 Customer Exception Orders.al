table 55027 "Customer Exception Orders"
{
    //DX        17 Jun 2021
    //Table for storing the exceptions of allowing customer to order above the standard monthly item limit (Item Card setting)
    Caption = 'Customer Exception Orders';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cust No."; Code[20])
        {
            Caption = 'Cust No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(10; Description; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(20; "Item No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = item."No.";
        }
        field(30; "Item Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "UOM"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(50; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Cust No.", "Item No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
        CustRec: Record Customer;
        ItemRec: Record item;
    begin
        if Rec."Cust No." <> '' then begin
            CustRec.reset;
            CustRec.get("Cust No.");
            Rec.Description := CustRec.Name;
        end else begin
            Rec.Description := '';
        end;
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.get("Item No.");
            Rec."Item Description" := ItemRec.Description;
        end else begin
            rec."Item Description" := '';
        end;
    end;

    trigger OnModify()
    var
        myInt: Integer;
        CustRec: Record Customer;
        ItemRec: Record item;
    begin
        if Rec."Cust No." <> '' then begin
            CustRec.reset;
            CustRec.get("Cust No.");
            Rec.Description := CustRec.Name;
        end else
            if Rec."Cust No." = '' then begin
                rec.Description := '';
            end;
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.get("Item No.");
            Rec."Item Description" := ItemRec.Description;
            if Rec."Item No." = '' then begin
                Rec."Item Description" := '';
            end;
        end
    end;
}
