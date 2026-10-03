pageextension 55068 WhseReceiptsListExt extends "Warehouse Receipts"
{
    layout
    {
        addafter("Sorting Method")
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

            /*
            field(gSourceDocType; gSourceDocType)
            {
                Caption = 'Source Document';
                ApplicationArea = All;
                Editable = false;
            }

            field(gSourceNo; gSourceNo)
            {
                Caption = 'Source No.';
                ApplicationArea = All;
                Editable = false;
            }

            field(gVendCustName; gVendCustName)
            {
                Caption = 'Vendor/Customer Name';
                ApplicationArea = All;
                Editable = false;
            }
            field(gBranchName; gBranchName)
            {
                Caption = 'Branch';
                ApplicationArea = All;
                Editable = False;
            }
            */
            // YF 08 Nov 2021
        }
    }

    // YF 08 Nov 2021
    trigger OnAfterGetRecord()
    begin
        if Rec."Source Doc No." = '' then
            GetFirstWhseReceiptLineDetail();
    end;

    local procedure GetFirstWhseReceiptLineDetail()
    var
        lWhseReceiptLineRec: Record "Warehouse Receipt Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
        lTransferHeaderRec: Record "Transfer Header";
    begin
        lWhseReceiptLineRec.Reset();
        lWhseReceiptLineRec.SetRange("No.", Rec."No.");
        if lWhseReceiptLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseReceiptLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Purchase Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Order";
                    Rec."Source Doc No." := lWhseReceiptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Purchase Return Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Purchase Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Return Order";
                    Rec."Source Doc No." := lWhseReceiptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseReceiptLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := '';
                    Rec."Source Branch" := '';
                    Rec."Source Vend/Cust No." := lPurchaseHeaderRec."Buy-from Vendor No.";
                    Rec."Source Vend/Cust Name" := lPurchaseHeaderRec."Buy-from Vendor Name";
                end;
            end;

            // Handle Sales
            if lWhseReceiptLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Sales Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Order";
                    Rec."Source Doc No." := lWhseReceiptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Sales Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Return Order";
                    Rec."Source Doc No." := lWhseReceiptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseReceiptLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lSalesHeaderRec."External Document No.";
                    Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lSalesHeaderRec."Sell-to Customer No.";
                    Rec."Source Vend/Cust Name" := lSalesHeaderRec."Sell-to Customer Name";
                end;
            end;
            //RL    14 Jan 2022
            // Handle Transfer
            if lWhseReceiptLineRec."Source Type" = 5741 then begin
                // Process for Transfer Type
                lTransferHeaderRec.Reset();

                // Outbound
                if lWhseReceiptLineRec."Source Document" = lWhseReceiptLineRec."Source Document"::"Inbound Transfer" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Inbound Transfer";
                    Rec."Source Doc No." := lWhseReceiptLineRec."Source No.";
                    // lTransferHeaderRec.SetRange("Document Type", lTransferHeaderRec."Document Type"::Order);
                end;

                // Set Transfer Details
                lTransferHeaderRec.SetRange("No.", lWhseReceiptLineRec."Source No.");
                if lTransferHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lTransferHeaderRec."External Document No.";
                    // Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lTransferHeaderRec."Transfer-from Code";
                    Rec."Source Vend/Cust Name" := lTransferHeaderRec."Transfer-from Name";
                end;
            end;
            //RL    14 Jan 2022

            Rec.Modify(false);

        end;
    end;

    /*
    var
        gSourceDocType: Text[50];
        gSourceNo: Code[20];
        gVendCustName: Text[100];
        gBranchName: Text[100];

    local procedure GetFirstWhseReceiptLineDetail()
    var
        lWhseReceiptLineRec: Record "Warehouse Receipt Line";
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
                gBranchName := lSalesHeaderRec."Branch/Subsidiary";
            end;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetFirstWhseReceiptLineDetail();
    end;

    trigger OnAfterGetRecord()
    begin
        GetFirstWhseReceiptLineDetail();
    end;
    */
    // YF 08 Nov 2021
}
