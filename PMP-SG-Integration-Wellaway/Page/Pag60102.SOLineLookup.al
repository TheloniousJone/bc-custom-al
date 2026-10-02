page 60102 SOLineLookup
{

    Caption = 'SO Lookup';
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    Editable = false;
    //SourceTableView = where("Invoiced In PMP" = const(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ToolTip = 'Specifies the value of the Quantity (Base) field';
                    ApplicationArea = All;
                }
                field("Unit Of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        WellCU: Codeunit "Wellaway CU";
    begin
        SLRec.reset;
        SLRec.ChangeCompany(WellCU.GetWellawayCompany());
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter("No.", '<>%1', '');
        SLRec.SetFilter(Quantity, '<>0');
        SLRec.SetRange("Invoiced In PMP", false);
        if SLRec.FindSet() then
            repeat
                Rec.reset;
                Rec.init;
                Rec."Document Type" := SLRec."Document Type";
                Rec."Document No." := SLRec."Document No.";
                rec."Line No." := SLRec."Line No.";
                Rec."Sell-to Customer No." := SLRec."Sell-to Customer No.";
                Rec."No." := SLRec."No.";
                Rec.Description := SLRec.Description;
                Rec.Quantity := SLRec.Quantity;
                rec."Quantity (Base)" := SLRec."Quantity (Base)";
                reC."Unit of Measure Code" := SLRec."Unit of Measure Code";
                Rec.insert(FALSE);
            until SLRec.next = 0;


    end;
}
