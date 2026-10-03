table 66004 "Checking Proof Tag Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Doc Line No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Proof Tag Reference"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                CheckingProofTagLine: Record "Checking Proof Tag Line";
            begin
                if "Proof Tag Reference" <> '' then begin
                    CheckingProofTagLine.Reset();
                    CheckingProofTagLine.SetRange("Doc No.", "Doc No.");
                    CheckingProofTagLine.SetRange("Proof Tag Reference", "Proof Tag Reference");
                    if CheckingProofTagLine.FindFirst() then
                        Error('Prooftag Reference %1 is already existing in this Document No. %2.', "Proof Tag Reference", "Doc No.");
                end;
            end;
        }
        field(5; "Scan URL"; Text[100])
        {
            trigger OnValidate()
            var
                Position: Integer;
            begin
                Position := "Scan URL".LastIndexOf('/');

                Validate("Proof Tag Reference", "Scan URL".Substring(Position + 1));
            end;
        }
    }

    keys
    {
        key(Key1; "Doc No.", "Doc Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
}