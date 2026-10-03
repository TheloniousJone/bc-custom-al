report 90001 CreateChainOrders
{
    ApplicationArea = All;
    Caption = 'CreateChainOrders';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Chain PO Header"; "Chain PO Header")
        {
            DataItemTableView = where("SO Created" = const(false));
            trigger OnAfterGetRecord()
            begin
                ChainPharmaCU.CreateOrder("Chain PO Header"."Entry No.", "Chain PO Header".Chain, "Chain PO Header"."PO Number");
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
        ChainPharmaCU: Codeunit ChainPharmaCU;
}
