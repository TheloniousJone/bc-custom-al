report 56201 DeleteResEntry
{
    ApplicationArea = All;
    Caption = 'DeleteResEntry';
    ProcessingOnly = true;
    UsageCategory = Administration;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if UserId <> 'BCADMIN' then begin
                    Error('Only BCADMIN can use this');
                end;
                if EndEntryNo < EntryNo then
                    Error('Please ensure ending entry no is bigger than entry no.');

                resEntry.reset;
                resEntry.SetFilter("Entry No.", '%1..%2', EntryNo, EndEntryNo);
                if resEntry.FindSet() then
                    repeat
                        resEntry.Delete(FALSE);
                    until resEntry.next = 0;

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
                    field(EntryNo; EntryNo)
                    {
                        ApplicationArea = all;
                    }
                    field(EndEntryNo; EndEntryNo)
                    {
                        ApplicationArea = all;
                    }
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
        EntryNo: Integer;
        resEntry: Record "Reservation Entry";
        EndEntryNo: Integer;
}
