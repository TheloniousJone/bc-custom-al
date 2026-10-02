pageextension 55100 CompInfoPageExt extends "Company Information"
{
    layout
    {
        // layout changes here
        addbefore("VAT Registration No.")
        {
            field("I9G_Registration No."; Rec."Registration No.")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Registration No.';
            }
        }
        addafter(Picture)
        {
            field("PMP Picture"; Rec."PMP Picture")
            {
                ApplicationArea = All;
            }
            field("Paynow QR"; Rec."Paynow QR")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }

        addafter("Bank Account No.")
        {
            field("Bank Code"; Rec."Bank Code")
            {
                ApplicationArea = All;
            }
            field("Bank Address"; Rec."Bank Address")
            {
                ApplicationArea = All;
            }
        }

        addlast(Payments)
        {
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ApplicationArea = All;
            }
            field("Beneficiary Address"; Rec."Beneficiary Address")
            {
                ApplicationArea = All;
            }
        }
        addlast("System Indicator")
        {
            field(I9G_ArdencePharma; Rec.I9G_ArdencePharma)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // action changes here
    }

}
