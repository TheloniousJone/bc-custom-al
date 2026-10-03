tableextension 55070 WarehouseWMSCueExt extends "Warehouse WMS Cue"
{
    fields
    {
        field(50000; "Open Transfer Order"; Integer)
        {
            Caption = 'Open Transfer Order';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where(Status = const(Open)));
            AccessByPermission = TableData "Transfer Header" = R;
        }
        field(50010; "Released Transfer Order"; Integer)
        {
            Caption = 'Released Transfer Order';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where(Status = const(Released)));
            AccessByPermission = TableData "Transfer Header" = R;
        }
    }
}
