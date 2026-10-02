page 60101 "Patient Card"
{

    Caption = 'Patient Card';
    PageType = Card;
    SourceTable = Patient;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field(NRIC; Rec.NRIC)
                {
                    ToolTip = 'Specifies the value of the NRIC field';
                    ApplicationArea = All;
                }
                field("Address 1"; Rec."Address 1")
                {
                    ToolTip = 'Specifies the value of the Address 1 field';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field';
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile No. field';
                    ApplicationArea = All;
                }
                field(DOB; Rec.DOB)
                {
                    ToolTip = 'Specifies the value of the DOB field';
                    ApplicationArea = All;
                }
                field("Drug Allergy"; Rec."Drug Allergy")
                {
                    ToolTip = 'Specifies the value of the Drug Allergy field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
