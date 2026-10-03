pageextension 55115 PostedPurchaseRcptList extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Location Code")
        {
            field(SpecialOrder; SpecialOrder)
            {
                ApplicationArea = All;
            }
        }
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        PPRRec: Record "Purch. Rcpt. Line";
    begin
        PPRRec.Reset();
        Clear(SpecialOrder);
        PPRRec.SetRange("Document No.", Rec."No.");
        PPRRec.SetFilter("Special Order Sales No.", '<>%1', '');
        if PPRRec.FindFirst() then
            SpecialOrder := PPRRec."Special Order Sales No.";
    end;

    var

        SpecialOrder: code[20];
}

