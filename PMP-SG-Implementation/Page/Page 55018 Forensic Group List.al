page 55018 "Forensic Group List"
{
    ApplicationArea = All;
    Caption = 'Forensic Group List';
    PageType = List;
    SourceTable = "Forensic Group";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Forensic Group"; Rec."Forensic Group")
                {
                    ToolTip = 'Specifies the value of the Forensic Group field';
                    ApplicationArea = All;

                }
                field("Controlled Drug"; Rec."Controlled Drug")
                {
                    ApplicationArea = all;
                    ToolTip = 'Check this to indicate that group is a controlled drug.';
                }
                field(Poison; Rec.Poison)
                {
                    ApplicationArea = all;
                }

                // YF 24 Mar 2025
                field(I9G_STBio; Rec.I9G_STBio)
                {
                    ApplicationArea = All;
                    Visible = ShowSTBio;
                }
                // YF 24 Mar 2025
            }
        }
    }

    // YF 25 Mar 2025
    var
        ShowSTBio: Boolean;

    trigger OnOpenPage()
    var
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        ShowSTBio := PMPCU.IsPMPCompany();
    end;
    // YF 25 Mar 2025
}