report 57132 ResetILE
{
    Caption = 'ResetILE';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = tabledata "Item Ledger Entry" = rm;

    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                // ResEntry: Record "Reservation Entry";
                ILE: Record "Item Ledger Entry";
            begin
                if UserId <> 'YFPANG' then begin
                    if UserId <> 'BCADMIN' then
                        if UserId <> 'RICHMONDLIM' then
                            Error('Not allowed');
                end;

                HasFilters := false;


                ILE.Reset();

                if (EntryNo <> 0) And (endEntryNo <> 0) then begin
                    ILE.SetFilter("Entry No.", '%1..%2', EntryNo, endEntryNo);
                    HasFilters := true;
                end;

                // if SourceID <> '' then begin
                //     ResEntry.SetRange("Source ID", SourceID);
                //     HasFilters := true;
                // end;

                // if ItemNo <> '' then begin
                //     ResEntry.SetRange("Item No.", ItemNo);
                //     HasFilters := true;
                // end;

                if HasFilters then begin
                    if ILE.FindSet() then
                        repeat
                            ILE."Invoiced Quantity" := InvoiceQty;
                            ILE.Modify(false);
                            Myint += 1;
                        until ILE.next = 0;
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
                    field(InvoiceQty; InvoiceQty)
                    {
                        ApplicationArea = all;
                    }

                    // field(SourceType; SourceType)
                    // {
                    //     ApplicationArea = All;
                    //     Visible = false;
                    // }

                    // field(SourceSubtype; SourceSubtype)
                    // {
                    //     ApplicationArea = All;
                    //     Visible = false;
                    // }

                    // field(SourceID; SourceID)
                    // {
                    //     ApplicationArea = All;
                    // }

                    // field(ItemNo; ItemNo)
                    // {
                    //     ApplicationArea = All;
                    // }
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
        InvoiceQty: Decimal;
}
