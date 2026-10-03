codeunit 52002 EventSubscriber
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnGenJnlLineGetVendorAccount', '', false, false)]
    local procedure OnGenJnlLineGetVendorAccount(var Sender: Record "Gen. Journal Line"; Vendor: Record Vendor);
    begin
        Sender."DBS Product Type" := Vendor."Bank Payment Type";
    end;

}
