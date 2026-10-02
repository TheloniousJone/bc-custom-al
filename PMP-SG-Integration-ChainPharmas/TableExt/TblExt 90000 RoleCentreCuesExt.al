tableextension 90000 RoleCentreCueExt extends RoleCentreCues
{
    fields
    {
        // Add changes to table fields here
        field(90000; "ChainPharma SO Not Created"; Integer)
        {
            Caption = 'Chain Pharma SO Pending Create';

            FieldClass = FlowField;
            CalcFormula = count("Chain PO Header" where("SO Created" = const(false)));
        }

        field(90001; "ChainPharma SO Error"; Integer)
        {
            Caption = 'Chain Pharma SO Errors';

            FieldClass = FlowField;
            CalcFormula = count("Chain PO Header" where("SO Error" = const(true)));
        }

    }

}