pageextension 50040 SalesQuoteArchiveExt extends "Sales Quote Archive"
{
    layout
    {
        addafter("Status")
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