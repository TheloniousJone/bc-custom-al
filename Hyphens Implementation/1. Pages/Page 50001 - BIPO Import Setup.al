page 50001 "BIPO Import Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BIPO Impport Setup";

    layout
    {
        area(Content)
        {
            repeater(BIPO)
            {
                field("BIPO Type"; Rec."BIPO Type")
                {
                    ApplicationArea = All;
                }
                field("BIPO Code"; Rec."BIPO Code")
                {
                    ApplicationArea = All;

                }
                //KM20210406 - Start
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                //KM20210406 - End
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    //Enabled = gbol_RowEnable;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    //Enabled = gbol_RowEnable;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    //Enabled = gbol_RowEnable;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    //Enabled = gbol_RowEnable;
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    //Enabled = not gbol_RowEnable;
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = All;
                    //Enabled = not gbol_RowEnable;
                }
            }
        }
    }

    actions
    {

    }

    var
        gbol_RowEnable: Boolean;

    trigger OnAfterGetRecord()
    begin
        Clear(gbol_RowEnable);

        if Rec."BIPO Type" = Rec."BIPO Type"::RowID then begin
            gbol_RowEnable := true;
        end else begin
            gbol_RowEnable := false;
        end;
    end;
}