pageextension 55057 PostedWHReceiptListPageExt extends "Posted Whse. Receipt List"
{
    layout
    {
        addafter("No.")
        {
            // YF 08 Nov 2021
            field("Source Doc Type"; Rec."Source Doc Type")
            {
                Caption = 'Source Document Type';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Doc No."; Rec."Source Doc No.")
            {
                Caption = 'Source Document No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Ext Doc No."; Rec."Source Ext Doc No.")
            {
                Caption = 'Source External Document No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Vend/Cust No."; Rec."Source Vend/Cust No.")
            {
                Caption = 'Source Vendor/Customer No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Vend/Cust Name"; Rec."Source Vend/Cust Name")
            {
                Caption = 'Source Vendor/Customer Name';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Branch"; Rec."Source Branch")
            {
                Caption = 'Source Branch';
                ApplicationArea = All;
                Editable = false;
            }

            field(SystemCreatedAt;Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy;Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
            }
            field(SystemModifiedBy;Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
            /*
            field(gSourceDocType; gSourceDocType)
            {
                Caption = 'Source Document';
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }

            field(gSourceNo; gSourceNo)
            {
                Caption = 'Source No.';
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }

            field(gVendCustName; gVendCustName)
            {
                Caption = 'Vendor/Customer Name';
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            */
            // YF 08 Nov 2021
        }
    }

    // YF 08 Nov 2021
    /*
    var
        gSourceDocType: Text[50];
        gSourceNo: Code[20];
        gVendCustName: Text[100];

    local procedure GetFirstWhseReceiptLineDetail()
    var
        lWhseReceiptLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
    begin
        gSourceDocType := '';
        gSourceNo := '';
        gVendCustName := '';

        lWhseReceiptLineRec.Reset();
        lWhseReceiptLineRec.SetRange("No.", Rec."No.");
        if lWhseReceiptLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseReceiptLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Purchase Order" then begin
                    gSourceDocType := 'Purchase Order';
                    gSourceNo := lWhseReceiptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Purchase Return Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Purchase Return Order" then begin
                    gSourceDocType := 'Purchase Return Order';
                    gSourceNo := lWhseReceiptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseReceiptLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then
                    gVendCustName := lPurchaseHeaderRec."Buy-from Vendor Name";
            end;

            // Handle Sales
            if lWhseReceiptLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Sales Order" then begin
                    gSourceDocType := 'Sales Order';
                    gSourceNo := lWhseReceiptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Sales Return Order" then begin
                    gSourceDocType := 'Sales Return Order';
                    gSourceNo := lWhseReceiptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lsalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseReceiptLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then
                    gVendCustName := lSalesHeaderRec."Sell-to Customer Name";
            end;
        end;
    end;
    */
    // YF 08 Nov 2021

    trigger OnOpenPage()
    begin
        /*
        Rec.FilterGroup(2);
        Rec.SetFilter(SystemCreatedBy, '%1|%2', '', EnhanceCU.GetUserGUID());

        Rec.FilterGroup(0);
        */
        rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());
        //DX        30 Aug 2021
    end;
}