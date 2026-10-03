report 99002 UpdateSalesTradeAgtFindNext
{
    Caption = 'UpdateSalesTradeAgtFindNext';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    // Permissions = TableData "Sales Invoice Header" = rimd;

    dataset
    {
        dataitem("Pharma Sales Price"; "Pharma Sales Price")
        {

            trigger OnAfterGetRecord()
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                "Pharma Sales Price"."Find Next" := true;
                "Pharma Sales Price".Modify(false);
            end;

        }
    }

    trigger OnPostReport()
    begin
        Message('Report Ran');
    end;

    /*
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(DocNoFilter; DocNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Invoice Document No. Filter';
                    }
                }
            }
        }
    }

    var
        DocNoFilter: Text;
    */
}
