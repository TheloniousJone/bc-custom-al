pageextension 55053 WhPutAwayListPageExt extends "Warehouse Put-aways"
{
    layout
    {
        modify("Assigned User ID")
        {
            ApplicationArea = all;
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        addafter("External Document No.")
        {
            field("External Document No.2"; Rec."External Document No.2")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.")
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
            //DX        06 Oct 2021
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
        //rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());
        //DX        30 Aug 2021
    end;

    trigger OnAfterGetRecord()
    var
        WHActLine: Record "Warehouse Activity Line";
        PORec: Record "Purchase Header";
        SORec: Record "Sales Header";
    begin
        if Rec."External Document No." = '' then begin
            WHActLine.reset;
            WHActLine.SetRange("No.", Rec."No.");
            WHActLine.SetRange("Action Type", WHActLine."Action Type"::Take);
            if WHActLine.FindFirst() then begin
                Rec."External Document No." := WHActLine."Source No.";
                Rec.Modify(TRUE);
            end;
        end;
        if Rec."External Document No.2" = '' then begin
            WHActLine.reset;
            WHActLine.SetRange("No.", Rec."No.");
            WHActLine.SetRange("Action Type", WHActLine."Action Type"::Take);
            if WHActLine.FindFirst() then begin
                if WHActLine."Source Document" = WHActLine."Source Document"::"Purchase Order" then begin
                    PORec.reset;
                    PORec.SetRange("No.", WHActLine."Source No.");
                    if PORec.FindFirst() then begin
                        Rec."External Document No.2" := CopyStr(PORec."Buy-from Vendor Name", 1, 35);
                        Rec.Modify(FALSE);
                    end;
                end else
                    if WHActLine."Source Document" = WHActLine."Source Document"::"Sales Return Order" then begin
                        SORec.reset;
                        SORec.SetRange("No.", WHActLine."Source No.");
                        if SORec.FindFirst() then begin
                            Rec."External Document No.2" := CopyStr(SORec."Sell-to Customer Name", 1, 35);
                            Rec.Modify(FALSE);
                        end;
                    end;
            end;

        end;

        // YF 08 Nov 2021
        if Rec."Source Doc No." = '' then
            GetFirstWhsePutawayLineDetail();
        // YF 08 Nov 2021
    end;

    local procedure GetFirstWhsePutawayLineDetail()
    var
        lWhseActivityLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
        lTransferHeaderRec: Record "Transfer Header";
    begin
        lWhseActivityLineRec.Reset();
        lWhseActivityLineRec.SetRange("No.", Rec."No.");
        if lWhseActivityLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseActivityLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Purchase Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := '';
                    Rec."Source Branch" := '';
                    Rec."Source Vend/Cust No." := lPurchaseHeaderRec."Buy-from Vendor No.";
                    Rec."Source Vend/Cust Name" := lPurchaseHeaderRec."Buy-from Vendor Name";
                end;
            end;

            // Handle Sales
            if lWhseActivityLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lSalesHeaderRec."External Document No.";
                    Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lSalesHeaderRec."Sell-to Customer No.";
                    Rec."Source Vend/Cust Name" := lSalesHeaderRec."Sell-to Customer Name";
                end;
            end;
            //RL    14 Jan 2022
            // Handle Transfer
            if lWhseActivityLineRec."Source Type" = 5741 then begin
                // Process for Transfer Type
                lTransferHeaderRec.Reset();

                // Outbound
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Inbound Transfer" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Inbound Transfer";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    // lTransferHeaderRec.SetRange("Document Type", lTransferHeaderRec."Document Type"::Order);
                end;

                // Set Transfer Details
                lTransferHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
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
        PMPCU: Codeunit "Warehouse CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
    */
}