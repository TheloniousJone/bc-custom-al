tableextension 55052 ItemUnitofMeasureTblExt extends "Item Unit of Measure"
{
    fields
    {
        field(55000; "Alternate Description"; Text[100])
        {
            Caption = 'Alternate Description';
            DataClassification = ToBeClassified;
        }
        //DX        21 May 2025 
        field(55001; I9G_BlockUOM; Boolean)
        {
            Caption = 'Block Sale UOM';
        }

    }
}
