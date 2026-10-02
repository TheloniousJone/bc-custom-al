pageextension 52003 DBSCompanyInfoExt extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(BankAccountPostingGroup)
        {
            group("DBS Integration")
            {
                field("Organization ID for DBS"; Rec."Organization ID for DBS")
                {
                    ApplicationArea = All;
                }

                field("Sender Name for DBS"; Rec."Sender Name for DBS")
                {
                    ApplicationArea = All;
                }

                field("Payment Advice Email"; Rec."Payment Advice Email")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}