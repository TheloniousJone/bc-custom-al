tableextension 60105 TransferHeaderTblExt extends "Transfer Header"
{
    fields
    {
        //DX        15 July 2021        To determine if the Transfer order has retrieved the details from Wellaway BC entity
        field(60100; "Retrieved SO from Wellaway"; Boolean)
        {
            Caption = 'Retrieved SO from Wellaway';
            DataClassification = ToBeClassified;
        }
        //DX        15 July 2021
    }
}
