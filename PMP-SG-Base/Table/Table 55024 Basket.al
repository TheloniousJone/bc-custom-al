table 55024 Basket
{
    Caption = 'Basket';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; Available; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
        }
        //DX        03 Sept 2021
        field(30; "Cold Room"; Boolean)
        {
            Caption = 'Cold Room Basket';
            DataClassification = ToBeClassified;
        }
        //DX        03 Sept 2021
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

}
