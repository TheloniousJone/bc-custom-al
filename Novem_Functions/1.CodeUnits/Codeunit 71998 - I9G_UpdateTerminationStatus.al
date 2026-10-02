codeunit 71998 "I9G_UpdateTerminationStatus"
{
    Description = 'Job Queue - Check if today exceeds the End Date.';
    Permissions = tabledata "Sales Header" = rimd;
    trigger OnRun()
    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
    begin
        I9G_NovemEventSubscribersCodeUnit.I9G_TerminationDateStatusCheck();
    end;
}