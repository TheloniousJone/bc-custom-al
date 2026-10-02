report 57029 DeleteResEntry
{
    Caption = 'DeleteResEntry';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                ResEntry: Record "Reservation Entry";
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');
                if EntryNo <> 0 then begin

                    ResEntry.reset;
                    ResEntry.SetFilter("Entry No.", '%1..%2', EntryNo, endEntryNo);
                    if ResEntry.FindSet() then
                        repeat
                            ResEntry.Delete(TRUE);
                            Myint += 1;
                        until ResEntry.next = 0;
                    /*
                    if ResEntry.FindFirst() then begin
                        ResEntry.Delete(TRUE);
                        Myint += 1;

                    end;
                    */
                    Message(StrSubstNo('%1 Updated', Myint));
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
                    field(EntryNo; EntryNo)
                    {
                        ApplicationArea = all;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            endEntryNo := EntryNo;
                        end;
                    }
                    field(endEntryNo; endEntryNo)
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
        endEntryNo: Integer;
        EntryNo: Integer;
        Myint: Integer;
}
