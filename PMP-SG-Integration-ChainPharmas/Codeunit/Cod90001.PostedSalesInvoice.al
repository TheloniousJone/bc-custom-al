codeunit 90001 PostedSalesInvoiceUpdateCU
{
    Permissions = TableData "Sales Invoice Header" = rm;
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader := Rec;
        SalesInvoiceHeader.LockTable();
        SalesInvoiceHeader.Find();
        SalesInvoiceHeader.Exported := rec.Exported;
        SalesInvoiceHeader.TestField("No.", rec."No.");
        SalesInvoiceHeader.Modify();
        Rec := SalesInvoiceHeader;
    end;

}
