pageextension 55069 WhseShipmentListExt extends "Warehouse Shipment List"
{
    layout
    {
        addafter("Sorting Method")
        {
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
        }
    }

    var
        gSourceDocType: Text[50];
        gSourceNo: Code[20];
        gVendCustName: Text[100];

    local procedure GetFirstWhseShptLineDetail()
    var
        lWhseShptLineRec: Record "Warehouse Shipment Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
        lAssemblyHeaderRec: Record "Assembly Header";
        lTransferHeaderRec: Record "Transfer Header";
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
                if lPurchaseHeaderRec.FindFirst() then
                    gVendCustName := lPurchaseHeaderRec."Buy-from Vendor Name";
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
                if lSalesHeaderRec.FindFirst() then
                    gVendCustName := lSalesHeaderRec."Sell-to Customer Name";
            end;

            // Handle Transfer
            if lWhseShptLineRec."Source Type" = 5741 then begin
                // Process for Transfer Type
                lTransferHeaderRec.Reset();

                // Outbound
                if lWhseShptLineRec."Source Document" = lWhseShptLineRec."Source Document"::"Outbound Transfer" then begin
                    gSourceDocType := 'Transfer';
                    gSourceNo := lWhseShptLineRec."Source No.";
                    // lTransferHeaderRec.SetRange("Document Type", lTransferHeaderRec."Document Type"::Order);
                end;

                // Set Transfer Details
                lTransferHeaderRec.SetRange("No.", lWhseShptLineRec."Source No.");
                if lTransferHeaderRec.FindFirst() then begin

                    gVendCustName := lTransferHeaderRec."Transfer-to Name";
                end;
            end;
            //RL    14 Jan 2022
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
}
