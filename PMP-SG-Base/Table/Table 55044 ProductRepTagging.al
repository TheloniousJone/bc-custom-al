table 55044 "Product Rep Tagging"
{
    Caption = 'Product Rep Tagging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Relation"; Option)
        {
            Caption = 'Item Relation';
            DataClassification = ToBeClassified;
            OptionMembers = Specific,Group;
        }
        field(10; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
            // TableRelation = Item."No.";
            TableRelation = if ("Item Relation" = const(Specific)) Item."No."
            else
            if ("Item Relation" = const(Group)) "Item Commission Group".Code;
        }
        field(20; "Customer Relation"; Option)
        {
            Caption = 'Customer Relation';
            DataClassification = ToBeClassified;
            OptionMembers = All,Specific,Group;
        }
        field(30; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = ToBeClassified;
            // TableRelation = Customer."No.";
            TableRelation = if ("Customer Relation" = const(Specific)) Customer."No." else
            if ("Customer Relation" = const(Group)) "Customer Commission Group".Code;
        }
        field(40; "Sales Rep. Relation"; Option)
        {
            Caption = 'Sales Rep. Relation';
            DataClassification = ToBeClassified;
            OptionMembers = Specific,Group;
        }
        field(50; "Sales Rep. Code"; Code[20])
        {
            Caption = 'Sales Rep. Code';
            DataClassification = ToBeClassified;
        }
        field(60; Exclusive; Boolean)
        {
            Caption = 'Exclusive';
            DataClassification = ToBeClassified;
        }
        field(70; From; Date)
        {
            Caption = 'From';
            DataClassification = ToBeClassified;
        }
        field(80; "To"; Date)
        {
            Caption = 'To';
            DataClassification = ToBeClassified;
        }
        field(90; Discount; Text[50])
        {
            Caption = 'Discount';
            DataClassification = ToBeClassified;
        }
        field(100; Basic; Text[250])
        {
            Caption = 'Basic';
            DataClassification = ToBeClassified;
        }
        field(110; "Find Next"; Boolean)
        {
            Caption = 'Find Next';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Item Relation", "Item Code", "Customer Relation", "Customer Code", "Sales Rep. Relation", "Sales Rep. Code", Exclusive, From)
        {
            Clustered = true;
        }
    }

}
