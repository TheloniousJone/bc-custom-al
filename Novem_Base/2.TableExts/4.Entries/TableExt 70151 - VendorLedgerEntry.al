tableextension 70151 VendorLedgerEntryTableExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(70000; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
            Editable = false;
        }
        field(70001; "I9G_ChequeDetails"; Text[250])
        {
            Caption = 'Cheque Details';
        }
    }
}