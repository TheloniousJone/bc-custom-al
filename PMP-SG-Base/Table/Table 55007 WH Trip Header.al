table 55007 "WH Trip Header"
{
    Caption = 'WH Trip Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Trolley No."; Code[20])
        {
            Caption = 'Trolley No.';
            DataClassification = ToBeClassified;
            TableRelation = Trolley."No.";
        }
        field(20; "Trip Start"; DateTime)
        {
            Caption = 'Start';
            DataClassification = ToBeClassified;
        }
        field(30; "Trip End"; DateTime)
        {
            Caption = 'End';
            DataClassification = ToBeClassified;
        }
        field(40; Picker; Code[20])
        {
            Caption = 'Picker';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Employee"."User ID";
        }
        field(50; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        SSSetup: Record "Sales & Receivables Setup";
        DetLineRec: Record "WH Trip Line";

    trigger OnInsert()
    begin
        SSSetup.RESET;
        SSSetup.GET;
        SSSetup.TESTFIELD("Def. WH. Trip No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."Def. WH. Trip No. Series", SSSetup."Def. WH. Trip No. Series", WORKDATE(), "No.", SSSetup."Def. WH. Trip No. Series");
        "No." := NoSeries.GetNextNo(SSSetup."Def. WH. Trip No. Series", WorkDate());
    end;

    trigger OnDelete()
    begin
        DetLineRec.reset;
        DetLineRec.SetRange("Doc No.", Rec."No.");
        if DetLineRec.Count > 0 then
            Error('Picking for trip has started, unable to delete the trip.')
        else begin
            DetLineRec.reset;
            DetLineRec.SetRange("Doc No.", Rec."No.");
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not DetLineRec.IsEmpty then
                DetLineRec.Deleteall(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
        end;

    end;

}
