table 60100 Patient
{
    Caption = 'Patient';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Address 1"; Text[250])
        {
            Caption = 'Address 1';
            DataClassification = ToBeClassified;
        }
        field(4; "Address 2"; Text[250])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(5; NRIC; Code[15])
        {
            Caption = 'NRIC';
            DataClassification = ToBeClassified;
        }
        field(6; DOB; Date)
        {
            Caption = 'DOB';
            DataClassification = ToBeClassified;
        }
        field(7; "Mobile No."; Text[50])
        {
            Caption = 'Mobile No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Drug Allergy"; Text[250])
        {
            Caption = 'Drug Allergy';
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

    trigger OnInsert()
    var
        myInt: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
    begin
        SSSetup.RESET;
        SSSetup.GET;
        SSSetup.TESTFIELD("Def. Patient No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."Def. Patient No. Series", SSSetup."Def. Patient No. Series", WORKDATE(), "No.", SSSetup."Def. Patient No. Series");
        "No." := NoSeries.GetNextNo(SSSetup."Def. Patient No. Series", WorkDate());
    end;

}
