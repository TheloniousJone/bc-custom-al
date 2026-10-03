pageextension 55039 WarehouseReceiptPageExt extends "Warehouse Receipt"
{
    layout
    {
        // ...

    }
    actions
    {
        modify("Post Receipt")
        {
            trigger OnBeforeAction()
            var
                ReservationEntry: Record "Reservation Entry";
            begin


            end;
        }
    }

    trigger OnOpenPage()
    begin
        //DX        20 Aug 2021
        // Rec.Validate("Posting Date", Today);
        Rec.Validate("Posting Date", WorkDate);  //RL 28 Dec 2022
        Rec.Modify(TRUE);
        //DX        20 Aug 2021
    end;

    // YF 08 Nov 2021
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetFirstWhseReceiptLineDetail();
    end;

    local procedure GetFirstWhseReceiptLineDetail()
    var
        lWhseReceiptLineRec: Record "Warehouse Receipt Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
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

            Rec.Modify(false);

        end;
    end;
}
