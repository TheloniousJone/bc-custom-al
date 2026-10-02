pageextension 55101 ItemReferencePageExt extends "Item Reference Entries"
{
    layout
    {
        // layout changes here
        addafter("Unit of Measure")
        {
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
            }

            field(ItemDescr; ItemDescr)
            {
                Caption = 'Item Description';
                ApplicationArea = All;
                Visible = true;
                Editable = false;
            }
        }
    }

    actions
    {
        // action changes here
    }

    var
        ItemDescr: Text[100];

    local procedure RefreshItemDescr()
    var
        ItemRec: Record Item;
    begin
        ItemDescr := '';
        if ItemRec.Get(Rec."Item No.") then
            ItemDescr := ItemRec.Description;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshItemDescr();
    end;

    trigger OnAfterGetRecord()
    begin
        RefreshItemDescr();
    end;

}
