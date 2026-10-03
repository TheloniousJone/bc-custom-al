pageextension 55055 ItemLookupPageExt extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("Item Status"; Rec."Item Status")
            {
                ApplicationArea = all;
            }
            field("Forensic Group"; Rec."Forensic Group")
            {
                ApplicationArea = all;
            }
            field("Generic Name"; Rec."Generic Name")
            {
                ApplicationArea = all;
            }
        }
    }
}
