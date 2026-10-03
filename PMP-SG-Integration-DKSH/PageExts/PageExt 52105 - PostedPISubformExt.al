pageextension 52105 DKSHPostedPISubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Purchase Price")
        {
            field("Imported Invoiced Price"; Rec."Imported Invoiced Price")
            {
                ApplicationArea = All;
                DecimalPlaces = 2 : 5;
                BlankZero = true;
                StyleExpr = gFieldStyle;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetPurchasePriceStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetPurchasePriceStyle();
    end;

    local procedure SetPurchasePriceStyle()
    begin
        if (Rec."Imported Invoiced Price" <> 0) And (Rec."Purchase Price" <> Rec."Imported Invoiced Price") then
            gFieldStyle := 'Attention'
        else
            gFieldStyle := 'Standard';
    end;

    var
        gFieldStyle: Text[50];
}
