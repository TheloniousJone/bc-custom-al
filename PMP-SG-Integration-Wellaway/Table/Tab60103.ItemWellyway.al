table 60103 ItemWellyway
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product Code"; Code[20]) { }
        field(2; "Producte Name"; Text[100])
        {
            Caption = 'Product Name';
        }
        field(3; "Base UOM"; Code[10]) { }
        field(4; "Item Status"; code[35]) { }
        field(5; "Sales UOM"; Code[10]) { }
        field(6; "Generic Name"; Text[300]) { }
        field(7; "Available Status"; Boolean) { }
        field(8; "Expiry Date"; Date) { }
        field(9; "Forensic Group"; Code[20]) { }
        field(10; "Product Type"; Text[100]) { }
        field(11; "Storage Condition"; Option)
        {
            OptionMembers = Fridge,"Non-Fridge";
        }
        field(12; Manufacturer; Text[250]) { }
        field(13; Principal; Text[250]) { }
        field(14; "WholeSales Price"; Decimal) { }
        field(15; "Item Group"; Option)
        {
            OptionMembers = ITEM,RADIANCE,FK,LS;
        }
        field(17; "Base Unit Description"; Text[250]) { }
        field(18; "WareHouse"; Text[50]) { }
        field(19; "Instruction For Use"; text[250]) { }
        field(20; Precautions; Text[250]) { }
        field(21; "Pack Size"; Integer) { }
        field(22; "Purchase UOM"; Code[10]) { }
        field(23; "Purchase Lead Time"; Integer) { }
        field(24; "Sales Lead Time"; Integer) { }
        field(25; "Item GST Group"; Code[20]) { }
        field(26; "Default Vendor"; code[50]) { }
        field(27; "Item Model Group"; Code[20]) { }
        field(28; "Dimension Group"; Code[20]) { }
        field(29; "Dimension [1]"; Code[20]) { }
        field(30; "Dimension [2]"; Code[20]) { }
        field(31; "Dimension [3]"; Code[20]) { }
        field(32; "From Unit"; code[50]) { }
        field(33; "From Unit Description"; Text[250]) { }
        field(34; Factor; Decimal) { }
        field(35; "To Unit"; code[50]) { }
        field(36; "To Unit Description"; Text[250]) { }

    }


    keys
    {
        key(Key1; "Product Code")
        {
            Clustered = true;
        }
        key(Key2; "Producte Name")
        {
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