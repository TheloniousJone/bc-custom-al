report 99004 DeleteDimSetEntry
{
    Caption = 'Delete Dim Set Entry';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = TableData "Dimension Set Entry" = rimd;

    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                DimSetEntry: Record "Dimension Set Entry";
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                if (DimSetIDFilter <> 0) Or (DimValCodeFilter <> '') then begin

                    DimSetEntry.Reset;
                    DimSetEntry.SetRange("Dimension Set ID", DimSetIDFilter);
                    DimSetEntry.SetRange("Dimension Value Code", DimValCodeFilter);
                    // YF 10 Aug 2022 // To avoid unnecessary table lock
                    if not DimSetEntry.IsEmpty then
                        DimSetEntry.DeleteAll();
                    // YF 10 Aug 2022 // To avoid unnecessary table lock

                    Message('Report Ran');
                end;


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
                    field(DimSetIDFilter; DimSetIDFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Dimension Set ID';
                    }

                    field(DimValCodeFilter; DimValCodeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Dimension Value Code';
                    }
                }
            }
        }
    }

    var
        DimSetIDFilter: Integer;
        DimValCodeFilter: Code[20];
}
