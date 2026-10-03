pageextension 55094 AvailItemTrackPageExt extends "Avail. - Item Tracking Lines"
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
