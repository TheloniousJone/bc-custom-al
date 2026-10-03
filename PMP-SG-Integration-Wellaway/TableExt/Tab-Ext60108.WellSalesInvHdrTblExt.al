tableextension 60108 WellSalesInvHdrTblExt extends "Sales Invoice Header"
{
    fields
    {
        field(60100; "Patient No."; Code[20])
        {
            Caption = 'Patient No.';
            DataClassification = ToBeClassified;
        }
        field(60101; "Order Sent to PMP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60102; "Order Invoiced in PMP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 July 2021
        field(60103; "Wellaway Picker"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = picker."User ID";
        }
        field(60104; "Wellaway Checker"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = picker."User ID";
        }
        //DX        11 July 2021
        Field(60109; "Well. Basket No."; Code[10])
        {
            Caption = 'Wellaway Basket No.';
            DataClassification = ToBeClassified;
        }

    }
}
