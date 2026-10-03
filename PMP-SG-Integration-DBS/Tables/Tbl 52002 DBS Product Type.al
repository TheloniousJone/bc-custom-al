table 52002 "DBS Product Type"
{
    DataClassification = ToBeClassified;
    Caption = 'DBS Product Type';
    DataCaptionFields = "DBS Product Type", "DBS Product Description";
    DrillDownPageID = "DBS Product Type List";
    LookupPageID = "DBS Product Type List";

    fields
    {
        field(1; "DBS Product Type"; Code[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'DBS Product Type';
        }

        // Header
        field(10; "DBS Product Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'DBS Product Description';
        }
    }

    keys
    {
        key(PK; "DBS Product Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "DBS Product Type", "DBS Product Description")
        {
        }
    }

}