tableextension 80142 WarehouseActivities extends "Warehouse WMS Cue"
{
    fields
    {
        field(80130; "No. Of Warehouse SO Received"; Integer)
        {
            Caption = 'No. Of Warehouse SO Received';

            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where(I9G_SONo = filter('<>'''''), "Sell-to Customer No." = const('N071')));
        }
        field(80131; "No. Of Warehouse PO Received"; Integer)
        {
            Caption = 'No. Of Warehouse PO Received';

            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(I9G_PONo = filter('<>'''''), "Buy-from Vendor No." = const('NOVEM')));
        }
    }
}
