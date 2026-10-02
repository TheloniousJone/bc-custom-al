tableextension 59005 POMSalesInvHdrExt extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(59000; "Amount Collected by POM"; Decimal)
        {
            Caption = 'Amount Collected by POM';
            DataClassification = ToBeClassified;
        }

        // YF 15 Sep 2022
        field(59001; "Processed by POM"; Boolean)
        {
            Caption = 'Processed by POM';
            DataClassification = ToBeClassified;
        }
        // YF 15 Sep 2022

        // YF 21 Sep 2022
        field(59002; "Last Posted Invoice in Order"; Boolean)
        {
            Caption = 'Last Posted Invoice in Order';
            DataClassification = ToBeClassified;
        }
        // YF 21 Sep 2022
        field(59003; "Refund Amount"; decimal)
        {
            Caption = 'Refund Amount';
            DataClassification = ToBeClassified;
        }
        field(59004; "Refund Date"; Date)
        {
            Caption = 'Refund Date';
            DataClassification = ToBeClassified;
        }


    }

}