tableextension 59001 POMSalesHeaderTblExt extends "Sales Header"
{
    fields
    {
        field(57000; "Placed By"; Text[50])
        {
            Caption = 'Placed By';
            DataClassification = ToBeClassified;
        }

        // YF 07 Sep 2022
        field(59000; "Amount Collected by POM"; Decimal)
        {
            Caption = 'Amount Collected by POM';
            DataClassification = ToBeClassified;
        }
        // YF 07 Sep 2022

        // Field 59001 Reserved - See Sales Invoice Header // YF 15 Sep 2022

        // Field 59002 Reserved - See Sales Invoice Header // YF 21 Sep 2022
    }
}
