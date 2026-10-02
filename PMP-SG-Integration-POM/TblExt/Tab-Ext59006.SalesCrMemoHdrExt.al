tableextension 59006 POMSalesCrMemoHdrExt extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(59000; "Amount Collected by POM"; Decimal)
        {
            Caption = 'Amount Collected by POM';
            DataClassification = ToBeClassified;
        }

        // Field 59001 Reserved - See Sales Invoice Header // YF 15 Sep 2022

        // Field 59002 Reserved - See Sales Invoice Header // YF 21 Sep 2022
    }

}