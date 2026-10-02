pageextension 55113 PostedTransferReceiptSubform extends "Posted Transfer Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Line Remarks"; Rec."Line Remarks")
            {
                ApplicationArea = All;
            }
            field("No. of Carton"; Rec."No. of Carton")
            {
                ApplicationArea = All;
            }
        }
    }
}
