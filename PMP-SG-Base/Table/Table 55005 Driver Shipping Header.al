table 55005 "Driver Shipping Header"
{
    //DX        29/04/21 : for assigning of pickers based on algorithm when picking list is created
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
            OptionMembers = Open,Checking,Error,Acknowledged,Delivering,Completed;
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
        }
        field(110; "Order Checked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Shipping Packages"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Driver Shipping Line"."Shipping Packacges" where("Driver Doc No." = field("No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        SSSetup: Record "Sales & Receivables Setup";
        DetLineRec: Record "Driver Shipping Line";

    trigger OnInsert()
    begin
        SSSetup.RESET;
        SSSetup.GET;
        SSSetup.TESTFIELD("Def. Driver Ship. No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."Def. Driver Ship. No. Series", SSSetup."Def. Driver Ship. No. Series", WORKDATE(), "No.", SSSetup."Def. Driver Ship. No. Series");
        "No." := NoSeries.GetNextNo(SSSetup."Def. Driver Ship. No. Series", WorkDate());
    end;


    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if Rec."Start Time" <> 0DT then
            Error('Unable to delete a driver record that has started already.');
        DetLineRec.reset;
        DetLineRec.SetRange("Doc No.", Rec."No.");
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not DetLineRec.IsEmpty then
            DetLineRec.Deleteall(TRUE);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
    end;

    trigger OnRename()
    begin

    end;

}