table 50003 "Halal Certificate Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Halal Certificate Name"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Halal Certificate".Name;
        }
        field(2; "Line No."; Integer)
        {

        }
        field(3; "Item No."; Code[20])
        {
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                lrec_Item: Record Item;
            begin
                if "Item No." <> '' then begin
                    lrec_Item.Get("Item No.");
                    "Item Description" := lrec_Item.Description;
                    "Item Description 2" := lrec_Item."Description 2";
                end;
            end;
        }
        field(4; "Item Description"; Text[100])
        {

        }
        field(5; "Item Description 2"; Text[50])
        {

        }
    }

    keys
    {
        key(PK; "Halal Certificate Name", "Line No.")
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

    //Select Multiple Items - Start
    procedure SelectMultipleItems()
    var
        ItemListPage: Page "Item List";
        SelectionFilter: Text;
    begin
        SelectionFilter := ItemListPage.SelectActiveItems;

        if SelectionFilter <> '' then
            AddItems(SelectionFilter);
    end;

    local procedure AddItems(SelectionFilter: Text)
    var
        HalalLine: Record "Halal Certificate Line";
        Item: Record Item;
    begin
        InitNewLine(HalalLine);
        Item.SetFilter("No.", SelectionFilter);
        if item.FindSet() then
            repeat
                HalalLine.Init();
                HalalLine."Line No." += 10000;
                //HalalLine.Validate(Type, Type::Item);
                HalalLine.Validate("Item No.", Item."No.");
                HalalLine.Insert(true);
            until Item.Next() = 0;
    end;

    local procedure InitNewLine(var NewLine: Record "Halal Certificate Line")
    var
        HalalLine: Record "Halal Certificate Line";
    begin
        NewLine.Copy(Rec);
        HalalLine.SetRange("Halal Certificate Name", NewLine."Halal Certificate Name");
        if HalalLine.FindLast() then begin
            NewLine."Line No." := HalalLine."Line No.";
        end else begin
            NewLine."Line No." := 0;
        end;
    end;
    //Select Multiple Items - End

}