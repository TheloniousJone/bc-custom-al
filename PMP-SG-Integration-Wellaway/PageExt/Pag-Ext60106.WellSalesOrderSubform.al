pageextension 60106 WellSalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addafter(ExprDate)
        {
            field(StockBal; StockBal)
            {
                Caption = 'Wellaway Stock Bal.';
                Editable = false;
                ApplicationArea = all;
                Style = Attention;
                Visible = VisibleBool;
            }
            field("Invoiced In PMP"; Rec."Invoiced In PMP")
            {
                Caption = 'Line Invoiced in PMP';
                Editable = true;
                ApplicationArea = all;
                Visible = VisibleBool;
            }
        }
        modify(ExprDate)
        {
            Visible = not VisibleBool;
        }
        addlast(content)
        {
            field("Presc. Desc"; Rec."Presc. Desc")
            {
                ApplicationArea = all;
            }
            field("Presc. Desc 2"; Rec."Presc. Desc 2")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                SHRec.reset;
                SHRec.SetRange("No.", Rec."Document No.");
                SHRec.SetRange("Document Type", Rec."Document Type");
                if SHRec.FindFirst() then begin
                    if SHRec."Samples SO" = true then begin
                        rec.Validate("Selling Price", 0);
                        Rec.Validate("Unit Price", 0);
                        rec.Modify(true);
                    end;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                SHRec.reset;
                SHRec.SetRange("No.", Rec."Document No.");
                SHRec.SetRange("Document Type", Rec."Document Type");
                if SHRec.FindFirst() then begin
                    if SHRec."Samples SO" = true then begin
                        rec.Validate("Selling Price", 0);
                        Rec.Validate("Unit Price", 0);
                        rec.Modify(true);
                    end;
                end;
            end;
        }


    }
    actions
    {
        addfirst("Related Information")
        {
            action("Presc. Instructions")
            {
                Visible = VisibleBool;
                ApplicationArea = all;
                ShortcutKey = "Ctrl+Shift+P";
                Image = Process;
                RunObject = page "Prescription Line";
                RunPageLink = "Line No." = field("Line No."), "Document No." = field("Document No.");
                RunPageView = sorting("Document Type", "Document No.", "Line No.");

            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then
            StockBal := WellCU.GetWellStockBalance(Rec)
        else
            StockBal := 0;

        if WellCU.IsWellawayCompany() then
            VisibleBool := true else
            VisibleBool := false;
    end;



    var
        WellCU: Codeunit "Wellaway CU";
        VisibleBool: Boolean;
        StockBal: Decimal;
        SHRec: Record "Sales Header";
}
