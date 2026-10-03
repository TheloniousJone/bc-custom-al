pageextension 55047 CustDiscGroupPageExt extends "Customer Disc. Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Total Percentage"; Rec."Total Percentage")
            {
                ApplicationArea = all;
            }
        }
    }
}
