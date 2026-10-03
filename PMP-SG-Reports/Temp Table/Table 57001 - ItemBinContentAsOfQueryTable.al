table 57001 ItemBinContentAsQueryTable
{
    TableType = Temporary;

    fields
    {
        field(1; I9G_Row; Integer)
        {
            Caption = 'Row';
        }
        field(2; I9G_ItemNo; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; I9G_ItemDescr; Text[100])
        {
            Caption = 'Item Descr';
        }
        field(4; I9G_LocationCode; Code[20])
        {
            Caption = 'Location Code';
        }
        field(5; I9G_BinCode; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(6; I9G_LotNo; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(7; I9G_ExpiryDate; Date)
        {
            Caption = 'Expiry Date';
        }
        field(8; I9G_QtyBaseAmount; Decimal)
        {
            Caption = 'Qty Base';
        }
    }

    keys
    {
        key(key1; I9G_Row)
        {
            Clustered = true;
        }
    }
}