tableextension 80141 ActivitiesCueTblExt extends "Activities Cue"
{
    fields
    {
        field(80130; "No. Of Warehouse SO Sent"; Integer)
        {
            Caption = 'No. Of Warehouse SO Sent';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where(I9G_SONo = filter('<>''''')));
        }
        field(80131; "No. Of Warehouse PO Sent"; Integer)
        {
            Caption = 'No. Of Warehouse PO Sent';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(I9G_PONo = filter('<>''''')));
        }
        field(80132; "I9G_NoOfOpenWarehouseSO"; Integer)
        {
            Caption = 'No. Of Open Warehouse SO';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where(I9G_SONo = filter('<>'''''), Status = const(Open)));
        }
        field(80133; "I9G_NoOfOpenWarehousePO"; Integer)
        {
            Caption = 'No. Of Open Warehouse PO';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(I9G_PONo = filter('<>'''''), Status = const(Open)));
        }
    }
}
