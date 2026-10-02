pageextension 57002 MovementWkshtPageExt extends "Movement Worksheet"
{
    actions
    {
        addbefore("Create Movement")
        {
            action("Lot Balance Report")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report 57016;
            }

        }
        addafter("Calculate Bin &Replenishment")
        {
            action("Calculate Bin Replenishment2")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Calculate Bin Replenishment2";
            }
        }
    }

    var
        dim: Code[20];
        item: Record Item;
}
