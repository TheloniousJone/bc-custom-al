report 56100 "Create PO Item Batch Job Queue"
{
    ApplicationArea = All;
    Caption = 'Create PO Item Batch Job Queue';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Zuellig Invoice ASN Import Log"; "Zuellig Invoice ASN Import Log")
        {
            DataItemTableView = where("PO Updated" = const(false));

            trigger OnAfterGetRecord()
            begin
                IntegrationCU.CreatePOBatch("Zuellig Invoice ASN Import Log"."Entry No");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        IntegrationCU: Codeunit "Zuellig Integrations";
}
