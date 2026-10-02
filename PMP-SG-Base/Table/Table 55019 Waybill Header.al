table 55019 "Waybill Header"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Checking,Error,Completed;
        }
        field(100; "Shipping Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 May 2021     Additional field to record shipping packages
        field(120; "Shipping Packages"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Checking Line"."Shipping Packacges" where("Doc No." = field("No.")));
        }
        //DX        11 May 2021     Additional field to record shipping packages 
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        detLineRec: Record "Checking Line";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;


    trigger OnDelete()
    begin
        DetLineRec.reset;
        DetLineRec.SetRange("Doc No.", Rec."No.");
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not detLineRec.IsEmpty then
            DetLineRec.Deleteall(TRUE);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
    end;

    trigger OnRename()
    begin

    end;

}