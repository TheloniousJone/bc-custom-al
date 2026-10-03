report 99006 PatchResEntry
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata 337 = rimd;

    dataset
    {
        dataitem("Reservation Entry"; "Reservation Entry")
        {
            trigger OnPreDataItem()
            begin
                Setfilter("Item No.", '%1|%2', 'DISPFEE', 'CHARGES');
            end;

            trigger OnAfterGetRecord()
            begin
                Delete();
            end;
        }
    }


    var
        myInt: Integer;
}