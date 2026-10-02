tableextension 50017 HyphensPurchaseHeaderTblExt extends "Purchase Header"
{

    fields
    {
        field(50000; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Requirement Template"."Template Code";

            trigger OnValidate()
            var
                ReqTemplateRec: Record "Requirement Template";
            begin
                Rec."Shelf Life Requirement" := '';
                Rec."Marking Requirement" := '';
                Rec."Packing Requirement" := '';
                Rec."Document Requirement" := '';

                if ReqTemplateRec.Get(Rec."Template Code") then begin
                    Rec."Shelf Life Requirement" := ReqTemplateRec."Shelf Life Requirement";
                    Rec."Marking Requirement" := ReqTemplateRec."Marking Requirement";
                    Rec."Packing Requirement" := ReqTemplateRec."Packing Requirement";
                    Rec."Document Requirement" := ReqTemplateRec."Document Requirement";
                end;
            end;
        }

        field(50001; "Shelf Life Requirement"; Text[500])
        {
            Caption = 'Shelf Life Requirement';
        }

        field(50002; "Marking Requirement"; Text[500])
        {
            Caption = 'Marking Requirement';
        }

        field(50003; "Packing Requirement"; Text[500])
        {
            Caption = 'Packing Requirement';
        }

        field(50004; "Document Requirement"; Text[500])
        {
            Caption = 'Document Requirement';
        }
        field(50005; Remarks; text[500])
        {
            Caption = 'Remarks';
        }
        field(50006; "Shipment Remarks"; Text[250])
        {
            Caption = 'Shipment Remarks';
        }
        modify("Shipment Method Code")
        {
            trigger OnAfterValidate()
            begin
                UpdatePurchLinesByFieldNo(FieldNo("Shipment Method Code"), CurrFieldNo <> 0);
            end;
        }
    }

}