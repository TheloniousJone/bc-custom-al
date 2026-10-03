pageextension 60100 CompanyInfoPageExt extends "Company Information"
{
    layout
    {
        addafter("E-Mail")
        {
            group(Additional)
            {
                /*
                field("Wellaway Company"; Rec."Wellaway Company")
                {
                    ApplicationArea = all;
                    ToolTip = 'For indicating that this is the Wellaway company.';
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                    begin
                        WellCU.CheckWellAwayCompany();
                    end;
                }
                field("PMP Company"; Rec."PMP Company")
                {
                    ApplicationArea = all;
                    ToolTip = 'For indicating that this is the PMP company.';
                    trigger OnValidate()
                    var
                        WellCU: Codeunit "Wellaway CU";
                    begin
                        WellCU.CheckPMPCompany();
                    end;
                }
                */
                field("PMP Name"; Rec."PMP Name")
                {
                    ApplicationArea = all;
                }
                field("Wellaway Name"; Rec."Wellaway Name")
                {
                    ApplicationArea = all;
                }

                // YF 06 May 2022
                field("WhatsApp QR Phone No."; Rec."WhatsApp QR Phone No.")
                {
                    ApplicationArea = All;
                }

                field("WhatsApp QR Message"; Rec."WhatsApp QR Message")
                {
                    ApplicationArea = All;
                }
                // YF 06 May 2022
            }
        }
    }
}
