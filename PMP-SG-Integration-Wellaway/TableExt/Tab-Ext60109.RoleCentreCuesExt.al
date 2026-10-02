tableextension 60109 RoleCentreCueExt extends RoleCentreCues
{
    fields
    {
        // Add changes to table fields here
        field(60100; "Wellaway SO Not Created"; Integer)
        {
            Caption = 'Wellaway SO Pending Create';

            FieldClass = FlowField;
            CalcFormula = count("Incoming Wellaway PO Header" where("SO Created" = const(false)));
        }

        field(60101; "Wellaway SO Error"; Integer)
        {
            Caption = 'Wellaway SO Errors';

            FieldClass = FlowField;
            CalcFormula = count("Incoming Wellaway PO Header" where("SO Error" = const(true)));
        }

    }

}