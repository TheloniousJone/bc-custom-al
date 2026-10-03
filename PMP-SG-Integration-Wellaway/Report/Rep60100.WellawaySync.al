report 60100 WellawaySync
{
    ApplicationArea = All;
    Caption = 'WellawaySync';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {

        dataitem(Integer; "Integer")
        {
            DataItemTableView = Sorting(Number) where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                SyncCU: Codeunit WellawaySync;
            begin
                SyncCU.SyncSetups();
                SyncCU.SyncPMPItemRec('');
                SyncCU.SyncCustRec('');
                SyncCU.SyncWellItemUOMRec('', '');
                SyncCU.SyncSalesTradeAgreement();
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
        WellCU: Codeunit "Wellaway CU";
}
