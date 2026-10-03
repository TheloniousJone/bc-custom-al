report 57128 DeleteResEntryExtended
{
    Caption = 'Delete Reservation Entry V2';
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
                if UserId <> 'YFPANG' then begin
                    if UserId <> 'BCADMIN' then
                        if UserId <> 'RICHMONDLIM' then
                            Error('Not allowed');
                end;

                HasFilters := false;

                ResEntry.Reset();

                if (EntryNo <> 0) And (endEntryNo <> 0) then begin
                    ResEntry.SetFilter("Entry No.", '%1..%2', EntryNo, endEntryNo);
                    HasFilters := true;
                end;

                if SourceID <> '' then begin
                    ResEntry.SetRange("Source ID", SourceID);
                    HasFilters := true;
                end;

                if ItemNo <> '' then begin
                    ResEntry.SetRange("Item No.", ItemNo);
                    HasFilters := true;
                end;

                if HasFilters then begin
                    if ResEntry.FindSet() then
                        repeat
                            ResEntry.Delete(TRUE);
                            Myint += 1;
                        until ResEntry.next = 0;
                    Message(StrSubstNo('%1 Updated', Myint));
                end
                else
                    Message('No filters set');
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

                    field(SourceType; SourceType)
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }

                    field(SourceSubtype; SourceSubtype)
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }

                    field(SourceID; SourceID)
                    {
                        ApplicationArea = All;
                    }

                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        endEntryNo: Integer;
        EntryNo: Integer;
        Myint: Integer;
        SourceID: Code[20];
        ItemNo: Code[20];
        SourceType: Integer;
        SourceSubtype: Integer;
        HasFilters: Boolean;
}
