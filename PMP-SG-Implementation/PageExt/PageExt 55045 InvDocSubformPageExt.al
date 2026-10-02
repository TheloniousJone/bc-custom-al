pageextension 55045 InvDocSubformPageExt extends "Invt. Document Lines"
{
    layout
    {
        addafter("Location Code")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
