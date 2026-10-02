tableextension 60102 WellSalesOrderTblExt extends "Sales Header"
{
    fields
    {
        field(60100; "Patient No."; Code[20])
        {
            Caption = 'Patient No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Patientrec: Record Patient;
                stagingRec: Record "Incoming Wellaway PO Header";
            begin
                //DX        18 Aug 2021
                // if Rec."Patient No." <> xRec."Patient No." then begin
                //     Patientrec.reset;
                //     Patientrec.SetRange("No.", Rec."Patient No.");
                //     if Patientrec.FindFirst() then begin
                //         Rec."Patient Name" := Patientrec.Name;
                //     end;
                // end;
                //DX        18 Aug 2021
                //DX        29 Oct 2025
                if Rec."Patient No." <> xRec."Patient No." then begin
                    // Patientrec.reset;
                    // Patientrec.SetRange("No.", Rec."Patient No.");
                    // if Patientrec.FindFirst() then begin
                    //     Rec."Patient Name" := Patientrec.Name;
                    // end;
                    stagingRec.reset;
                    stagingRec.SetRange("Sales Order No.", Rec."No.");
                    stagingRec.SetCurrentKey("Sales Order No.");
                    stagingRec.SetLoadFields("Customer Name", "Sales Order No.");
                    if stagingRec.FindFirst() then begin
                        Rec."Patient Name" := stagingRec."Customer Name";
                    end;
                end;
                //DX        29 Oct 2025
            end;
        }
        field(60101; "Order Sent to PMP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60102; "Order Invoiced in PMP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 July 2021
        field(60103; "Wellaway Picker"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = picker."User ID";
        }
        field(60104; "Wellaway Checker"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = picker."User ID" where(Wellaway = const(true));
        }
        field(60105; "Patient Name"; text[250])

        {
            DataClassification = ToBeClassified;
        }
        //DX        11 July 2021
        //DX        18 Sept 2021
        field(60106; NRIC; Code[15])
        {
            Caption = 'NRIC';
            DataClassification = ToBeClassified;
        }
        field(60107; DOB; Date)
        {
            Caption = 'DOB';
            DataClassification = ToBeClassified;
        }
        field(60108; "Drug Allergy"; Text[250])
        {
            Caption = 'Drug Allergy';
            DataClassification = ToBeClassified;
        }
        //DX        18 Sept 2021
        Field(60109; "Well. Basket No."; Code[10])
        {
            Caption = 'Wellaway Basket No.';
            DataClassification = ToBeClassified;
        }

    }
    trigger OnBeforeInsert()
    var
        PatientRec: Record Patient;
        StagingRec: Record "Incoming Wellaway PO Header";
    begin
        //DX        18 Sept 2021
        // if "Patient Name" <> '' then begin
        //     PatientRec.reset;
        //     // PatientRec.SetFilter(Name, "Patient Name"); // YF 01 Nov 2021 // Patch because BC filter goes wonky with ( )
        //     PatientRec.SetFilter(Name, '%1', Rec."Patient Name"); // YF 01 Nov 2021 // Patch because BC filter goes wonky with ( )
        //     PatientRec.SetRange("No.", Rec."Patient No.");//RL 28 Aug 2023 add another unique key for better filtering.
        //     if PatientRec.FindFirst() then begin
        //         Rec.DOB := PatientRec.DOB;
        //         Rec.NRIC := PatientRec.NRIC;
        //         Rec."Drug Allergy" := PatientRec."Drug Allergy";
        //     end;
        // end;1

        //DX        18 Sept 2021

        // YF 31 Oct 2025 
        /*
        //DX        29 Oct 2025
        stagingRec.reset;
        stagingRec.SetRange("Sales Order No.", Rec."No.");
        stagingRec.SetCurrentKey("Sales Order No.");
        stagingRec.SetLoadFields("Customer Name", "Sales Order No.", "Patient Date of Birth", "Patient NRIC/FIN/Passport No.", "Drug Allergies");
        if stagingRec.FindFirst() then begin
            Rec.DOB := stagingRec."Patient Date of Birth";
            Rec.NRIC := stagingRec."Patient NRIC/FIN/Passport No.";
            Rec."Drug Allergy" := stagingRec."Drug Allergies";
        end;
        //DX        29 Oct 2025
        */
        // YF 31 Oct 2025 
    end;
}
