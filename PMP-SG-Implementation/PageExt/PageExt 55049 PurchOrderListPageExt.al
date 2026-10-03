pageextension 55049 PurchOrderListPageExt extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field(RecCreated; RecCreated)
            {
                Caption = 'WH Receipt Created.';
                ApplicationArea = all;
                Editable = false;
            }
            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;

            }
            field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
            }

        }

        modify("Amount Received Not Invoiced (LCY)")
        {
            Visible = true;
        }
        modify("Amount Received Not Invoiced excl. VAT (LCY)")
        {
            Visible = true;
        }
        addafter(Amount)
        {
            field(Receive; Rec.Receive)
            {
                ApplicationArea = all;
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = all;
            }
            field("Partially Invoiced"; Rec."Partially Invoiced")
            {
                ApplicationArea = all;
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        WHRec: Record "Warehouse Receipt Line";
        regWhRec: Record "Posted Whse. Receipt Line";

    begin
        RecCreated := false;
        WHRec.Reset();
        WHRec.SetLoadFields("Source Document", "Source No.");        //DX        24 May 2023
        WHRec.SetRange("Source Document", WHRec."Source Document"::"Purchase Order");
        WHRec.SetRange("Source No.", Rec."No.");
        if WHRec.FindFirst() then begin
            RecCreated := true;
        end else begin
            regWhRec.reset;
            regWhRec.SetLoadFields("Source No.", "Source Document");  //DX        24 May 2023
            regWhRec.SetRange("Source No.", Rec."No.");
            regWhRec.SetRange("Source Document", regWhRec."Source Document"::"Purchase Order");
            if regWhRec.FindFirst() then
                RecCreated := true
            else
                RecCreated := false;
        end;
    end;

    var
        RecCreated: Boolean;
        enhanceCU: Codeunit "PMP-Enhancements";
}
