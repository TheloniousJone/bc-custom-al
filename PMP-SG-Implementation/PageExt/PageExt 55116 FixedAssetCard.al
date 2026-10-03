pageextension 55116 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;


            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim5Code; Rec.ShortcutDim5Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim6Code; Rec.ShortcutDim6Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim7Code; Rec.ShortcutDim7Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim8Code; Rec.ShortcutDim8Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }

    }
}
