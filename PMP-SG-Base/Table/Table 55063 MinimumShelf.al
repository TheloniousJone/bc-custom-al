table 55063 MinimumShelf
{
    Caption = 'To be able to store the minimum shelf life data in the system and extra it to the document lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Item;


        }
        field(2; Description; Text[100])
        {
            Caption = 'Product Name';


        }
        field(3; Code; Code[10])
        {
            Caption = 'Chain Pharmcy';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Customer Price Group";
        }
        field(55084; MinShelf; DateFormula)
        {
            Caption = 'Min Shelf Life';
            Editable = true;

        }

    }

    keys
    {
        key(Primary; "No.", Code)
        {
            Clustered = true;
        }
    }


}
