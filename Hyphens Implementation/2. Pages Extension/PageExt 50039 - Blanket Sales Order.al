pageextension 50039 BlanketSalesOrder extends "Blanket Sales Order"
{
    layout
    {
        addafter("Branch/Subsidiary")
        {
            field(I9_ContractDate; Rec.I9_ContractDate)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractNo; Rec.I9_ContractNo)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractAmount; Rec.I9_ContractAmount)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }
}