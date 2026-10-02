tableextension 55064 WarehouseEntryExt extends "Warehouse Entry"
{
    fields
    {
        //RL    12 Jan 2022
        field(55000; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        //RL    12 Jan 2022

        //RL    15 Jan 2022
        field(55001; "Qty. Calculated"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "Qty. Phy Count"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    //DX        13 Jun 2023
    keys
    {
        key(I9Key1; "Item No.", "Lot No.")
        {

        }
        key(I9key2; "Item No.")
        {

        }
    }
    //DX        13 Jun 2023
}
