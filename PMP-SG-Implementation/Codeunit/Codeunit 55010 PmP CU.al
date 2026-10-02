codeunit 55010 "PMP CU"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]

    local procedure "TransferOrder-Post (Yes/No)_OnBeforePost"(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment"; var TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt"; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post");
    var
        TransLine: Record "Transfer Line";
    begin
        TransLine.Reset();
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetRange("Transfer-to Code", 'OBSOLETE');
        TransLine.SetRange("Transfer-To Bin Code", 'PMP_OPS');
        TransLine.SetRange("I9G QC/QA Comments", '');
        // TransLine.SetFilter("Qty. to Ship", '<>%1', 0);


        //RL 31012024 - To enable once clear existing records. 
        // if TransLine.FindFirst() then begin
        //     Error('Please fill in the QC/QA Comments');
        // end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure "Transfer Shipment Line_OnAfterCopyFromTransferLine"(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line");

    begin
        TransferShipmentLine."I9G QC/QA Comments" := TransferLine."I9G QC/QA Comments";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure "Transfer Receipt Line_OnAfterCopyFromTransferLine"(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line");
    begin
        TransferReceiptLine."I9G QC/QA Comments" := TransferLine."I9G QC/QA Comments";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean);
    var
        SalesLine: Record "Sales Line";


    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Location Code", 'OBSOLETE');
        SalesLine.SetRange("Bin Code", 'PMP_OPS');
        SalesLine.SetRange("I9G QC/QA Comments", '');

        if SalesLine.findfirst() then begin
            Error('Please fill in the QC/QA Comments');
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure "Return Receipt Line_OnAfterInitFromSalesLine"(ReturnRcptHeader: Record "Return Receipt Header"; SalesLine: Record "Sales Line"; var ReturnRcptLine: Record "Return Receipt Line");
    begin
        // ReturnRcptLine."I9G QC/QA Comments" := ReturnRcptLine."I9G QC/QA Comments";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure "Sales Cr.Memo Line_OnAfterInitFromSalesLine"(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line");
    begin
        //SalesCrMemoLine."I9G QC/QA Comments" := SalesCrMemoLine."I9G QC/QA Comments";
    end;

    //DX        21 Feb 2024
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            IsChanged := (SalesInvoiceHeader."Sell-to Post Code" <> xSalesInvoiceHeader."Sell-to Post Code") or
            (SalesInvoiceHeader."Bill-to Post Code" <> xSalesInvoiceHeader."Bill-to Post Code") or
            (SalesInvoiceHeader."Ship-to Post Code" <> xSalesInvoiceHeader."Ship-to Post Code") or
            (salesinvoiceheader."External Document No." <> xSalesInvoiceHeader."External Document No.") or
            (salesinvoiceheader."Order Status" <> xSalesInvoiceHeader."Order Status");

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnOnRunOnBeforeTestFieldNo', '', false, false)]
    local procedure OnOnRunOnBeforeTestFieldNo(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Bill-to Post Code" := SalesInvoiceHeaderRec."Bill-to Post Code";
        SalesInvoiceHeader."Sell-to Post Code" := SalesInvoiceHeaderRec."Sell-to Post Code";
        SalesInvoiceHeader."Ship-to Post Code" := SalesInvoiceHeaderRec."Ship-to Post Code";
        SalesInvoiceHeader."External Document No." := SalesInvoiceHeaderRec."External Document No.";
        SalesInvoiceHeader."Order Status" := SalesInvoiceHeaderRec."Order Status";
    end;

    //DX        21 Feb 2024

    //DX        03 Jun 2026 Additional Event to skip the revert of SO quantity after CN
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", OnBeforeUpdateSalesOrderLinesFromCancelledInvoice, '', true, true)]
    local procedure OnBeforeUpdateSalesOrderLinesFromCancelledInvoice(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", OnBeforeUpdateSalesOrderLineInvoicedQuantity, '', true, true)]
    local procedure OnBeforeUpdateSalesOrderLineInvoicedQuantity(var IsHandled: Boolean)
    begin
        ishandled := true;
    end;
}
