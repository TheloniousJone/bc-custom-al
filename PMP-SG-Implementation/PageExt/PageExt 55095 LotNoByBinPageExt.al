pageextension 55095 LotNoByBinPageExt extends "Lot Numbers by Bin FactBox"
{
    layout
    {
        addafter("Lot No.")
        {
            field(ExprDate; ExprDate)
            {
                ApplicationArea = all;
                Caption = 'Expiration Date';
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        WHEntry: Record "Warehouse Entry";
    begin
        WHEntry.reset;
        WHEntry.SetLoadFields("Lot No.", "Item No.", "Entry No.", "Expiration Date");      //DX        16 May 2023
        WHEntry.SetCurrentKey("Lot No.", "Item No.");        //DX        05 Jun 2023     Change key
        WHEntry.SetRange("Lot No.", Rec."Lot No.");           //DX        05 Jun 2023     Change key
        WHEntry.SetRange("Item No.", Rec."Item No.");             //DX        05 Jun 2023     Change key
        //WHEntry.SetCurrentKey("Entry No.");
        //WHEntry.SetAscending("Entry No.", false);
        if WHEntry.FindLast() then begin //RL 18 Aug 2023 - changed to last
            ExprDate := WHEntry."Expiration Date";
        end else
            ExprDate := 0D;
    end;

    var
        ExprDate: Date;
}
