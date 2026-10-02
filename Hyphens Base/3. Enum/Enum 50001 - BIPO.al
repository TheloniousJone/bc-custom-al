enum 50001 BIPO
{
    Extensible = true;

    value(0; RowID)
    {
        Caption = 'BIPO Row ID';
    }
    value(1; ColumnID)
    {
        Caption = 'BIPO Column';
    }
    //KM20210405 - Start
    value(2; FixedDim)
    {
        Caption = 'Fixed Dimension';
    }
    //KM20210405 - End
}