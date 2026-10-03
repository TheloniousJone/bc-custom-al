codeunit 71997 "I9G_UpdateLicenseStatus"
{
    Description = 'Job Queue - Update Customer Record License Status.';
    Permissions = tabledata Customer = rimd;
    trigger OnRun()
    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
    begin
        I9G_NovemEventSubscribersCodeUnit.I9G_CustomerLicenseStatusCheck();
    end;
}