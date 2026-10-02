Codeunit 59001 POM5
{
    Permissions =
        TableData "Sales Invoice Header" = rm,
        TableData "Sales Invoice Line" = rm;

    procedure MarkExported(InvoiceNo: Code[20])
    var
        InvoiceHeader: Record "Sales Invoice Header";
        InvoiceLine: Record "Sales Invoice Line";
    begin
        InvoiceHeader.SetLoadFields(InvoiceHeader."I9G Line Export");
        InvoiceHeader.Get(InvoiceNo);
        InvoiceHeader.Validate("I9G Line Export", true);
        InvoiceHeader.Modify(false);

        InvoiceLine.SetLoadFields(InvoiceLine."I9G Line Export");
        InvoiceLine.SetRange(InvoiceLine."Document No.", InvoiceNo);
        if InvoiceLine.Findset() then begin
            repeat
                InvoiceLine.Validate("I9G Line Export", true);
                InvoiceLine.Modify(false)
            until InvoiceLine.Next() = 0;
        end;
    end;

}
