report 52101 "Email PO PDF EDI Job Queue"
{
    ApplicationArea = All;
    Caption = 'Email PO PDF EDI Job Queue';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("DKSH Staging Purch. Order Hdr."; "DKSH Staging Purch. Order Hdr.")
        {
            DataItemTableView = where(Closed = const(true), "PO Emailed" = const(false));

            trigger OnAfterGetRecord()
            begin
                IntegrationCU.SendPOPDFEDIEmail("DKSH Staging Purch. Order Hdr."."Entry No."); // Send PO PDF EDI Email
            end;
        }
    }

    var
        IntegrationCU: Codeunit "DKSH Integrations";
}
