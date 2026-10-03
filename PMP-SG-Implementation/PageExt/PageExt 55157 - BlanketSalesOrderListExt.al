pageextension 55157 BlanketSalesOrderListExt extends "Blanket Sales Orders"
{
    layout
    {
        addafter("External Document No.")
        {
            field(I9G_ContractRef; Rec.I9G_ContractRef)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}