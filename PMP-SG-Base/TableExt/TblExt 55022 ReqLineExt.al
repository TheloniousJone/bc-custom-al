tableextension 55022 ReqLineExt extends "Requisition Line"
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Min Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55001; "Unit Cost Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55003; "Revised FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55004; "Line Discount Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        // YF 17 Feb 2022
        field(55005; "Ad Hoc Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // YF 17 Feb 2022
        // YF 02 Mar 2025
        field(55006; "Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

}