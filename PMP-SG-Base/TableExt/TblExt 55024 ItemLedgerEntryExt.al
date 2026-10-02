tableextension 55024 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        field(55000; Exchangeable; Boolean)
        {
            Caption = 'Exchangeable';
            DataClassification = ToBeClassified;
        }
        //RL    12 Jan 2022
        field(55001; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        //RL    12 Jan 2022
    }
}
