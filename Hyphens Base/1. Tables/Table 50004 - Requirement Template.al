table 50004 "Requirement Template"
{
    Caption = 'Requirement Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
        }

        field(10; "Shelf Life Requirement"; Text[500])
        {
            Caption = 'Shelf Life Requirement';
        }

        field(20; "Marking Requirement"; Text[500])
        {
            Caption = 'Marking Requirement';
        }

        field(30; "Packing Requirement"; Text[500])
        {
            Caption = 'Packing Requirement';
        }

        field(40; "Document Requirement"; Text[500])
        {
            Caption = 'Document Requirement';
        }
    }

    keys
    {
        key(PK; "Template Code")
        {
        }
    }

}

