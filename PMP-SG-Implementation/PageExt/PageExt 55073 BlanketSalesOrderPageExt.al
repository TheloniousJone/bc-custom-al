pageextension 55073 BlanketSalesOrderPageExt extends "Blanket Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Customer Instructions"; Rec."Customer Instructions")
            {
                ApplicationArea = all;
            }
            field("Picking Instructions"; Rec."Picking Instructions")
            {
                ApplicationArea = all;
            }
            field("Delivery Instructions"; Rec."Delivery Instructions")
            {
                ApplicationArea = all;
            }
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = All;
            }
            field(I9G_ContractRef; Rec.I9G_ContractRef)
            {
                ApplicationArea = All;
            }
        }
    }

}