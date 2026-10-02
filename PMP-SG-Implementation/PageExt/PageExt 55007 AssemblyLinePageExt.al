pageextension 55007 AssemblyLinePageExt extends "Assembly Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field(ExprDate; ExprDate)
            {
                ApplicationArea = all;
                Caption = 'Expiration Date';
                Editable = false;
                Style = Attention;
            }
        }
        addafter(Quantity)
        {

        }
        modify(Quantity)
        {
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //DX        27 Jun 2021
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else
            ExprDate := '';


        //DX        27 Jun 2021
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin

        //DX        27 Jun 2021
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else
            ExprDate := '';
        //DX        27 Jun 2021
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else begin
            ExprDate := '';
        end;
        ;        //DX        27 Jun 2021
    end;

    var
        myInt: Integer;
        ExprDate: Text[250];
        EnhanceCU: Codeunit "PMP-Enhancements";
        PackQty: Integer;
}