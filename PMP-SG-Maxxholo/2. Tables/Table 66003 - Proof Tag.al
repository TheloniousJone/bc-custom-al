table 66003 "Proof Tag"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "EN"; Code[50])
        {
            Caption = 'EN';
        }
        field(3; "EV_DATE"; Date)
        {
            Caption = 'EV_DATE';
        }
        field(4; "TARGET_SITE_ID"; Code[50])
        {
            Caption = 'TARGET_SITE_ID';
        }
        field(5; "REFERENCE"; Code[100])
        {
            Caption = 'REFERENCE';

            trigger OnValidate()
            var
                CheckingProofTagLine: Record "Checking Proof Tag Line";
            begin
                if REFERENCE <> '' then begin
                    CheckingProofTagLine.Reset();
                    CheckingProofTagLine.SetRange("Doc No.", EVT_DATA1);
                    CheckingProofTagLine.SetRange("Proof Tag Reference", REFERENCE);
                    if CheckingProofTagLine.FindFirst() then
                        Error('Prooftag Reference %1 is already existing in this Document No. %2.', REFERENCE, EVT_DATA1);
                end;
            end;
        }
        field(6; "EVT_DATA1"; Text[100])
        {
            Caption = 'EVT_DATA1';
        }
        field(7; "EVT_DATA2"; Text[100])
        {
            Caption = 'EVT_DATA2';
        }
        field(8; "EVT_DATA3"; Text[100])
        {
            Caption = 'EVT_DATA3';
        }
        field(9; "EVT_DATA4"; Text[100])
        {
            Caption = 'EVT_DATA4';
        }
        field(10; "EVT_DATA5"; Text[100])
        {
            Caption = 'EVT_DATA5';
        }
        field(11; "EVT_DATA6"; Text[100])
        {
            Caption = 'EVT_DATA6';
        }
        field(96; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(97; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(98; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(99; "EXPORTED"; Boolean)
        {
            Caption = 'Exported';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}