report 59000 CreatePOM2Orders
{
    ApplicationArea = All;
    Caption = 'CreatePOM2Orders';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(POM2HeaderTbl; POM2HeaderTbl)
        {
            DataItemTableView = where("Created" = const(false));
            trigger OnAfterGetRecord()
            begin
                POMCU.CreateOrder(POM2HeaderTbl.PurchaseOrderID);
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
        POMCU: Codeunit pom2;
}
