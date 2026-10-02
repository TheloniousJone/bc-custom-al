page 55031 "Picker List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Picker;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("E Tag ID"; Rec."E Tag ID")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field(Wellaway; Rec.Wellaway)
                {
                    ApplicationArea = all;
                }
                field(Dedicated; Rec.Dedicated)
                {
                    ApplicationArea = all;
                }
                field(Logistics; Rec.Logistics)
                {
                    ApplicationArea = all;
                }
                field(Normal; Rec.Normal)
                {
                    ApplicationArea = all;
                }
                field(CD; Rec.CD)
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
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
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