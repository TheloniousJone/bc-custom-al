tableextension 60104 WellSalesLineTblExt extends "Sales Line"
{
    fields
    {
        //DX        15 July 2021
        field(60100; "Invoiced In PMP"; Boolean)
        {
            Caption = 'Invoiced In PMP';
            DataClassification = ToBeClassified;
        }
        //DX        15 July 2021
        //DX        25 July 2021
        field(60101; "Presc. Desc"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prescription 1';
        }

        field(60102; "Presc. Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prescription 2';
        }
        //DX        25 July 2021
    }

    trigger OnAfterInsert()
    var
        ItemRec: Record item;
    begin
        if "No." <> '' then begin//DX       25 July 2021        To add prescription information after inserting to the card form
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then begin
                Rec."Presc. Desc" := ItemRec."Prescription 1";
                rec."Presc. Desc 2" := ItemRec."Prescription 2";
            end;
        end;
    end;
}
