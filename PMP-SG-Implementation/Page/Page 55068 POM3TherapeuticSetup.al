page 55068 "POM3 Therapeutic Setup"
{

    ApplicationArea = All;
    Caption = 'POM3 Therapeutic Setup';
    PageType = List;
    // SourceTable = "Therapeutic-Item Setup";
    SourceTable = "POM3 Therapeutic Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Forensic Group"; Rec."Forensic Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Generic Name"; Rec."Generic Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Therapeutic Category 1"; Rec."Therapeutic Category 1")
                {
                    ToolTip = 'Specifies the value of the Therapeutic Category field';
                    ApplicationArea = All;
                }

                field("Therapeutic Category 2"; Rec."Therapeutic Category 2")
                {
                    ToolTip = 'Specifies the value of the Therapeutic Category field';
                    ApplicationArea = All;
                }

                field("Therapeutic Category 3"; Rec."Therapeutic Category 3")
                {
                    ToolTip = 'Specifies the value of the Therapeutic Category field';
                    ApplicationArea = All;
                }

                field("Therapeutic Category 4"; Rec."Therapeutic Category 4")
                {
                    ToolTip = 'Specifies the value of the Therapeutic Category field';
                    ApplicationArea = All;
                }

            }
        }
    }

}
