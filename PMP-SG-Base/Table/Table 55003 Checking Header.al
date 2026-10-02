table 55003 "Checking Header"
{
    //DX        29/04/21 : for assigning of pickers based on algorithm when picking list is created
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Basket No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Basket."No.";
        }
        field(10; "2nd Basket No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Basket."No.";
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
        field(60; "Start Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Picker"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Employee"."User ID";
        }
        field(90; "Checker"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Shipping Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Zone";
        }
        //DX        11 May 2021     Additional field to record shipping packages
        field(120; "Shipping Packacges"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Checking Line"."Shipping Packacges" where("Doc No." = field("No.")));
        }
        //DX        11 May 2021     Additional field to record shipping packages
        field(110; "Assigned to Driver Card"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX    18 July 2021
        field(130; "2nd Checker ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(140; "Delivery Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Charge";
        }
        //DX    18 July 2021
        //DX        25 July 2021
        field(150; "2nd Checker Start Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(160; "2nd Checker End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "Non-Cold Shipping Packages"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(180; "Cold Shipping Packages"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(190; "Picking Instruction"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        //DX        25 July 2021
        field(200; "Picker Error"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PickerChecker Error".Code;

        }
        field(210; "Checker Error"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PickerChecker Error".Code;

        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(key2; "Basket No.", Status)
        {

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
        if Rec."Start Time" <> 0DT then
            Error('Cannot delete a check that has started.');
        if Rec.Status = Rec.Status::Completed then
            Error('Cannot delete a completed check.');
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