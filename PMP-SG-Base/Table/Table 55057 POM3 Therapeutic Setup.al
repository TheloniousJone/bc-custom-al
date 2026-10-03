table 55057 "POM3 Therapeutic Setup"
{
    Caption = 'POM3 Therapeutic Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                UpdateItemDetails();
            end;
        }

        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }

        field(20; "Forensic Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Forensic Group";
        }

        field(30; "Generic Name"; Text[300])
        {
            DataClassification = ToBeClassified;
        }

        field(40; "Therapeutic Category 1"; Code[100])
        {
            Caption = 'Therapeutic Category 1';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Category 1"."No.";
        }

        field(50; "Therapeutic Category 2"; Code[100])
        {
            Caption = 'Therapeutic Category 2';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Category 2"."No.";
        }

        field(60; "Therapeutic Category 3"; Code[100])
        {
            Caption = 'Therapeutic Category 3';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Category 3"."No.";
        }

        field(70; "Therapeutic Category 4"; Code[100])
        {
            Caption = 'Therapeutic Category 4';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Category 4"."No.";
        }


    }
    keys
    {
        key(PK; "Item No.", "Therapeutic Category 1", "Therapeutic Category 2", "Therapeutic Category 3", "Therapeutic Category 4")
        {
            Clustered = true;
        }
    }

    local procedure UpdateItemDetails()
    var
        ItemRec: Record Item;
    begin
        Rec."Item Description" := '';
        Rec."Forensic Group" := '';
        Rec."Generic Name" := '';

        if ItemRec.Get(Rec."Item No.") then begin
            Rec."Item Description" := ItemRec.Description;
            Rec."Forensic Group" := ItemRec."Forensic Group";
            Rec."Generic Name" := ItemRec."Generic Name";
        end;
    end;

}
