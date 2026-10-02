tableextension 56100 RoleCentreCueExt extends RoleCentreCues
{
    fields
    {
        // PO Not Processed
        field(56100; "ZP PO PRO Not Processed"; Integer)
        {
            Caption = 'ZP PO and PRO Not Processed';

            FieldClass = FlowField;
            CalcFormula = count("Outgoing ZP PO Header" where(Processed = const(false)));
        }

        // PO Has Error
        field(56101; "ZP PO PRO Error"; Integer)
        {
            Caption = 'ZP PO and PRO Errors';

            FieldClass = FlowField;
            CalcFormula = count("Outgoing ZP PO Header" where("Has Error" = const(true)));
        }

        // ASN not Updated
        field(56102; "ZP ASN Not Processed"; Integer)
        {
            Caption = 'ZP PO Batch Not Processed';

            FieldClass = FlowField;
            CalcFormula = count("Zuellig Invoice ASN Import Log" where("PO Updated" = const(false)));
        }

        // ASN Error
        field(56103; "ZP ASN Error"; Integer)
        {
            Caption = 'ZP PO Batch Errors';

            FieldClass = FlowField;
            CalcFormula = count("Zuellig Invoice ASN Import Log" where("PO Error" = const(true)));
        }

    }

}