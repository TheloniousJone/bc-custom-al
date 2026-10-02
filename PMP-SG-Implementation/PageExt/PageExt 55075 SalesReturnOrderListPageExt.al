pageextension 55075 SalesReturnOrderListPageExt extends "Sales Return Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(SystemCreatedBy; EnhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field("Return Status"; Rec."Return Status")
            {
                ApplicationArea = all;
            }
            //RL        19 Oct 2021
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = All;
            }
            field("Last Return Receipt No."; Rec."Last Return Receipt No.")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        EnhanceCU: Codeunit "PMP-Enhancements";
}
