tableextension 56215 SalesRecSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(56200; "Default PMP Customer Code"; Code[20])
        {
            Caption = 'Default PMP Customer Code';
            DataClassification = ToBeClassified;
        }
        field(56201; "Default OH Vendor Code"; Code[20])
        {
            Caption = 'Default OH Vendor Code';
            DataClassification = ToBeClassified;
        }
        field(56202; "Def. OH Item Gen Prod"; Code[20])
        {
            Caption = 'Default OH Item Gen Prod. Posting Group';
            DataClassification = ToBeClassified;
        }
        field(56203; "Def PMP WH Location"; Code[20])
        {
            Caption = 'Def. PMP WH Location';
            DataClassification = ToBeClassified;
        }
        field(56204; "Def PMP Clearing Account"; Code[20])
        {
            Caption = 'Def PMP Clearing Account';
        }
    }
}
