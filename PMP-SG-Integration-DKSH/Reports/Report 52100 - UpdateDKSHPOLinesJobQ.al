report 52100 "Update DKSH PO Lines Job Queue"
{
    ApplicationArea = All;
    Caption = 'Update DKSH PO Lines Job Queue';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("DKSH Staging Purch. Rcpt. Hdr."; "DKSH Staging Purch. Rcpt. Hdr.")
        {
            DataItemTableView = where(Closed = const(false));

            trigger OnAfterGetRecord()
            begin
                IntegrationCU.UpdatePOLinesFromDKSH("DKSH Staging Purch. Rcpt. Hdr."."Entry No.");
            end;
        }
    }

    var
        IntegrationCU: Codeunit "DKSH Integrations";
}
