page 50197 "Halal List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Halal Certificate";
    CardPageId = "Halal Certificate";
    //AutoSplitKey = true;
    RefreshOnActivate = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(HalalList)
            {
                /*field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                }*/
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = All;
                    Caption = 'Expired';
                }
                // RL20200804 - Start
                field("PSS/PL"; Rec."PSS/PL")
                {
                    ApplicationArea = All;

                }
                // RL20200804 - End
            }
        }
    }

    var
}