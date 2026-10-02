tableextension 60101 SSSetupTblExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(60100; "Def. Patient No. Series"; Code[20])
        {
            Caption = 'Patient No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        //DX        25 July 2021
        field(60101; "Def Item. Journal Batch"; Code[20])
        {
            Caption = 'Default Item Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = const('ITEM'));
        }
        //DX        25 July 2021
        //DX        23 Sept 2021
        field(60102; "Def. Wellaway Inv. No. Series"; Code[20])
        {
            Caption = 'Def. Wellaway Sales Inv. No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        //DX        23 Sept 2021
    }
}
