pageextension 55070 BinListExt extends "Bin List"
{
    layout
    {
        modify("Location Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Zone Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify(Description)
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify(Empty)
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;

            trigger OnAfterValidate()
            begin
                if Rec.Empty then
                    gFieldStyle := 'Favorable'
                else
                    gFieldStyle := 'Unfavorable';
            end;
        }

        modify(Default)
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Bin Type Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Warehouse Class Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Block Movement")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Special Equipment Code")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Bin Ranking")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Maximum Cubage")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify("Maximum Weight")
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }

        modify(Dedicated)
        {
            ApplicationArea = All;
            StyleExpr = gFieldStyle;
        }
    }

    var
        gFieldStyle: Text[50];

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Empty then
            gFieldStyle := 'Favorable'
        else
            gFieldStyle := 'Unfavorable';
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Empty then
            gFieldStyle := 'Favorable'
        else
            gFieldStyle := 'Unfavorable';
    end;
}
