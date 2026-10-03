page 50194 "Halal Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Halal Setup";

    layout
    {
        area(Content)
        {
            group(HalalSetup)
            {
                Caption = 'Halal Setup';

                field("Sender Address"; Rec."Sender Address")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("To Address"; Rec."To Address")
                {
                    ApplicationArea = All;

                }
                field("CC Adress"; Rec."CC Adress")
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var

}