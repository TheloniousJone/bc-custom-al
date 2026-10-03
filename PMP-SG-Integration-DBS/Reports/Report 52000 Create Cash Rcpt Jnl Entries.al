report 52000 "Create CRH Entries"
{
    ApplicationArea = All;
    Caption = 'Autocreate CRH Entries';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("DBS Incoming"; "DBS Incoming")
        {
            DataItemTableView = where("Journals Created" = const(false));

            trigger OnAfterGetRecord()
            begin
                Commit();
                IntegrationCU.CreateCRJournal("DBS Incoming"."Entry No.");
            end;
        }
    }

    var
        IntegrationCU: Codeunit "DBS-Incoming Codeunit";
}
