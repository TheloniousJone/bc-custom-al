pageextension 55054 WhPickListPageExt extends "Warehouse Picks"
{
    Editable = true;
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
            //LK24 Jun 2024
            field(AssigmentStatus; AssigmentStatus)
            {
                ApplicationArea = all;
                Caption = 'Status';
                Editable = false;
            }
            field("Order Date"; OrderDate)
            {
                ApplicationArea = all;
                Caption = 'Sales Order Date';
                Editable = false;
            }

            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
            }

            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Editable = false;
            }

            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
                Editable = false;
            }

            field(SystemModifiedBy; enhanceCU.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
                Editable = false;
            }

            //LK24 Jun 2024

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
            */
            // YF 08 Nov 2021
        }
    }


    // YF 08 Nov 2021

    trigger OnAfterGetRecord()
    var
        SalesOrder: Record "Sales Header";
        AssmEntries: Record "Assignment Ledger Entry";
    begin
        if Rec."Source Doc No." = '' then
            GetFirstWhsePickLineDetail();

        //LK24 Jun 2024
        OrderDate := 0D;
        SalesOrder.Reset();
        SalesOrder.SetRange("No.", Rec."Source Doc No.");
        if SalesOrder.FindFirst() then
            OrderDate := SalesOrder."Order Date";

        Clear(AssigmentStatus);
        AssmEntries.Reset();
        AssmEntries.SetRange("Picking Doc No.", rec."No.");
        if AssmEntries.FindFirst() then
            AssigmentStatus := format(AssmEntries.Status);
        //LK24 Jun 2024

    end;

    local procedure GetFirstWhsePickLineDetail()
    var
        lWhseActivityLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
        lAssemblyHeaderRec: Record "Assembly Header";
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
            // Handle Assembly
            if lWhseActivityLineRec."Source Type" = 901 then begin
                // Process for Assembly Type
                lAssemblyHeaderRec.Reset();

                // Assembly Consumption
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Assembly Consumption" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Assembly Consumption";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lAssemblyHeaderRec.SetRange("Document Type", lAssemblyHeaderRec."Document Type"::Order);
                end;

                // Set Assembly Details
                lAssemblyHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lAssemblyHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lAssemblyHeaderRec."PO No.";
                    // Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lAssemblyHeaderRec."Item No.";
                    Rec."Source Vend/Cust Name" := lAssemblyHeaderRec.Description;
                end;
            end;
            // Handle Transfer
            if lWhseActivityLineRec."Source Type" = 5741 then begin
                // Process for Transfer Type
                lTransferHeaderRec.Reset();

                // Outbound
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Outbound Transfer" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Outbound Transfer";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    // lTransferHeaderRec.SetRange("Document Type", lTransferHeaderRec."Document Type"::Order);
                end;

                // Set Transfer Details
                lTransferHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lTransferHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lTransferHeaderRec."External Document No.";
                    // Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lTransferHeaderRec."Transfer-to Code";
                    Rec."Source Vend/Cust Name" := lTransferHeaderRec."Transfer-to Name";
                end;
            end;
            //RL    14 Jan 2022

            Rec.Modify(false);

        end;
    end;

    var
        enhanceCU: Codeunit "PMP-Enhancements";
        OrderDate: Date;
        AssigmentStatus: Text;
    /*
    var
        gSourceDocType: Text[50];
        gSourceNo: Code[20];
        gVendCustName: Text[100];
        gSourceDate: Date;

    local procedure GetFirstWhseShptLineDetail()
    var
        lWhseShptLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
        lTransHeaderRec: Record "Transfer Header";
    begin
        gSourceDocType := '';
        gSourceNo := '';
        gVendCustName := '';

        lWhseShptLineRec.Reset();
        lWhseShptLineRec.SetRange("No.", Rec."No.");
        if lWhseShptLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseShptLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Purchase Order" then begin
                    gSourceDocType := 'Purchase Order';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);

                end;

                // Purchase Return Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Purchase Return Order" then begin
                    gSourceDocType := 'Purchase Return Order';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseShptLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then begin
                    gVendCustName := lPurchaseHeaderRec."Buy-from Vendor Name";
                    gSourceDate := lPurchaseHeaderRec."Posting Date";
                end;

            end;

            // Handle Sales
            if lWhseShptLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Sales Order" then begin
                    gSourceDocType := 'Sales Order';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Sales Return Order" then begin
                    gSourceDocType := 'Sales Return Order';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lsalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseShptLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then begin
                    gVendCustName := lSalesHeaderRec."Sell-to Customer Name";
                    gSourceDate := lSalesHeaderRec."Posting Date";
                end;

            end;

            if lWhseShptLineRec."Source Type" = 5740 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Outbound Transfer" then begin
                    gSourceDocType := 'Transfer Shipment';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    //lTransHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Inbound Transfer" then begin
                    gSourceDocType := 'Transfer Receipt';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    //lTransHeaderRec.SetRange("Document Type", lsalesHeaderRec."Document Type"::);
                end;

                // Set Vendor/Customer Name
                lTransHeaderRec.SetRange("No.", lWhseShptLineRec."Source No.");
                if lTransHeaderRec.FindFirst() then begin
                    gVendCustName := lTransHeaderRec."Transfer-to Code";
                    gSourceDate := lTransHeaderRec."Posting Date";
                end;

            end;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetFirstWhseShptLineDetail();
    end;

    trigger OnAfterGetRecord()
    begin
        GetFirstWhseShptLineDetail();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

        //DX        30 Aug 2021


        //Rec.FilterGroup(2);
        //Rec.SetFilter("Assigned User ID", '%1|%2', '', EnhanceCU.GetUsername(UserSecurityId()));
        //Rec.FilterGroup(0);
        //DX        30 Aug 2021
        //rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());

    end;

    var
        PMPCU: Codeunit "Warehouse CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
    */
}