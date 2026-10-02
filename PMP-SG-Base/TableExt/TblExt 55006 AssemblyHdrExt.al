tableextension 55006 AssemblyHdrExt extends "Assembly Header"
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Customer Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55001; "Picking Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "Delivery Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021
        field(55003; "Packing Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55004; Remarks; text[500])
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021

        //RL        20 Dec 2021
        field(55005; "Vendor No"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(55006; "PO No."; Code[20])
        { }
        //RL        20 Dec 2021

        // YF 13 Dec 2021
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get("Item No.") then
                    "Packing Instructions" := ItemRec."Packing Instructions"
                else
                    "Packing Instructions" := '';
            end;
        }
        // YF 13 Dec 2021

    }

}