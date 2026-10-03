tableextension 55055 WHRecptHdrTblExt extends "Warehouse Receipt Header"
{
    fields
    {
        field(55000; "PMP Remarks"; Text[200])
        {
            Caption = 'PMP Remarks';
            DataClassification = ToBeClassified;
        }
        field(55001; "PMP Remarks 2"; Text[200])
        {
            Caption = 'PMP Remarks 2';
            DataClassification = ToBeClassified;
        }

        // YF 08 Nov 2021
        field(55002; "Source Doc Type"; Enum "Warehouse Activity Source Document")
        {
            Caption = 'Source Document Type';
            DataClassification = ToBeClassified;
        }

        field(55003; "Source Doc No."; Code[20])
        {
            Caption = 'Source Document No.';
            DataClassification = ToBeClassified;
        }

        field(55004; "Source Ext Doc No."; Code[35])
        {
            Caption = 'Source External Document No.';
            DataClassification = ToBeClassified;
        }

        field(55005; "Source Vend/Cust No."; Code[20])
        {
            Caption = 'Source Vendor/Customer No.';
            DataClassification = ToBeClassified;
        }

        field(55006; "Source Vend/Cust Name"; Text[100])
        {
            Caption = 'Source Vendor/Customer Name';
            DataClassification = ToBeClassified;
        }

        field(55007; "Source Branch"; Text[250])
        {
            Caption = 'Source Branch';
            DataClassification = ToBeClassified;
        }
        // YF 08 Nov 2021
    }
}
