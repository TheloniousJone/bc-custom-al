pageextension 52005 VendorCardExt2 extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Preferred Bank Account Code")
        {
            field("Bank Payment Type"; Rec."Bank Payment Type")
            {
                ApplicationArea = All;
            }
        }
    }

}