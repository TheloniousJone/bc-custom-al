pageextension 55034 BinContentPageExt extends "Bin Contents"
{
    layout
    {
        addafter("Item No.")
        {
            field(DescItem; DescItem)
            {
                ApplicationArea = all;
                Caption = 'Item Description';
                Editable = false;
            }
        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec.GetItemDescr(Rec."Item No.", Rec."Variant Code", DescItem);

    end;

    var
        DescItem: Text[100];
}
