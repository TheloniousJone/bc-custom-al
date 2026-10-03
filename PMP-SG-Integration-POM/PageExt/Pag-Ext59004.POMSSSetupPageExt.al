pageextension 59004 POMSSSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Allow VAT Difference")
        {
            field("POM2 Email"; Rec."POM2 Email")
            {
                ApplicationArea = all;
                ToolTip = 'Enter email for POM2 notifications for integration failures.';
            }

            // YF 08 Sep 2022
            field("POM Collect Payt Method Filter"; Rec."POM Collect Payt Method Filter")
            {
                ApplicationArea = All;
            }
            // YF 08 Sep 2022

            // YF 23 Sep 2022
            field("Retire POM Prefix"; Rec."Retire POM Prefix")
            {
                ApplicationArea = All;
                Visible = false; // YF 28 Sep 2022
            }
            // YF 23 Sep 2022
        }

        /*
        addlast(content)
        {
            usercontrol(SetFieldFocus; SetFieldFocus)
            {
                ApplicationArea = All;
                trigger Ready()
                begin
                    CurrPage.SetFieldFocus.SetFocusOnField('POM2 Email');
                end;
            }
        }
        */
    }

    /*
    trigger OnOpenPage()
    begin
        CurrPage.SetFieldFocus.SetFocusOnField('POM2 Email');
    end;
    */
}
