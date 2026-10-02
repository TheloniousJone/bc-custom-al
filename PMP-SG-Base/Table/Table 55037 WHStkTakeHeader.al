table 55037 "WH Stk Take Header"
{
    Caption = 'WH Stk Take Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Stock Take Doc No."; Code[20])
        {
            Caption = 'Stock Take Doc No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Register Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Processing,Completed;
        }
        field(5; "Assigned User"; Code[20])
        {
            Caption = 'Assigned User';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Employee"."User ID";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        SSSetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
    begin
        SSSetup.RESET;
        SSSetup.GET;
        SSSetup.TESTFIELD("Def. Stock Take No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."Def. Stock Take No. Series", SSSetup."Def. Stock Take No. Series", WORKDATE(), "No.", SSSetup."Def. Stock Take No. Series");
        if NoSeries.AreRelated(SSSetup."Def. Stock Take No. Series", SSSetup."Def. Stock Take No. Series") then;
        "No." := NoSeries.GetNextNo(SSSetup."Def. Stock Take No. Series", WorkDate());
    end;
}
