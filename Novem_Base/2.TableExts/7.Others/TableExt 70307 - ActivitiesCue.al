tableextension 70307 ActivitiesCueExt extends "Activities Cue"
{
    fields
    {
        field(70000; I9G_OngoingPostedSalesInvoices; Integer)
        {
            CalcFormula = count("Sales Invoice Header");
            Caption = 'Ongoing Posted Sales Invoices';
            FieldClass = FlowField;
        }
        field(70001; I9G_OngoingPostedPurchInv; Integer)
        {
            CalcFormula = count("Purch. Inv. Header");
            Caption = 'Ongoing Posted Purchase Invoices';
            FieldClass = FlowField;
        }
    }
}