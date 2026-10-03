table 55029 "Customer Specialties"
{
    Caption = 'Customer Specialties';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cust No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

        }
        field(10; "Specialty Code"; Code[20])
        {
            Caption = 'Specialty Code';
            DataClassification = ToBeClassified;
            TableRelation = Specialties."No.";
        }
        field(20; Remarks; text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Cust No.", "Specialty Code")
        {
            Clustered = true;
        }
    }

}
