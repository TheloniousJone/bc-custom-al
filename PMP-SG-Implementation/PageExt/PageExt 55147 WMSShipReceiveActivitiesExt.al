pageextension 55147 "WMS Ship&Receive ActivitiesExt" extends "WMS Ship & Receive Activities"
{
    layout
    {
        addlast(Internal)
        {

            field("Open Transfer Order"; Rec."Open Transfer Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Open Transfer Order field.';
                Image = Document;
                DrillDownPageId = "Transfer Orders";
            }
            field("Released Transfer Order"; Rec."Released Transfer Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Released Transfer Order field.';
                Image = Document;
                DrillDownPageId = "Transfer Orders";
            }
        }
    }
}
