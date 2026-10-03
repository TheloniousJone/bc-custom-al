pageextension 55093 ItemAvailPageExt extends "Available - Item Ledg. Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = all;
            }
        }
    }
}
