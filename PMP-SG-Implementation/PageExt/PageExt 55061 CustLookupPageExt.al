pageextension 55061 CustLookupPageExt extends "Customer Lookup"
{
    layout
    {
        addafter(Address)
        {
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("No.")
        {
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = all;
            }
        }
    }
}
