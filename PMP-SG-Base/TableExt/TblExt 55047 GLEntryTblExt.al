tableextension 55047 GLEntryTblExt extends "G/L Entry"
{
    fields
    {
        field(55000; "Journal Batch Description"; Text[100])
        {
            Caption = 'Journal Batch Description';
            DataClassification = ToBeClassified;
        }

        // YF 18 May 2022
        field(55001; "Foreign Currency Code"; Code[10])
        {
            Caption = 'Foreign Currency Code';
            DataClassification = ToBeClassified;
        }

        field(55002; "Foreign Currency Amount"; Decimal)
        {
            Caption = 'Foreign Currency Amount';
            DataClassification = ToBeClassified;
        }

        field(55003; "Foreign Currency Exchange Rate"; Decimal)
        {
            Caption = 'Foreign Currency Exchange Rate';
            DataClassification = ToBeClassified;
        }
        // YF 18 May 2022
        field(55004; "I9G_YourReference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
    }
}
