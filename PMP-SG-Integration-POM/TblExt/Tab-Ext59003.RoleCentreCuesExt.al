tableextension 59003 POMRoleCentreCueExt extends RoleCentreCues
{
    fields
    {
        // Add changes to table fields here
        field(59000; "POM SO Not Created"; Integer)
        {
            Caption = 'POM SO Pending Create';

            FieldClass = FlowField;
            CalcFormula = count(POM2HeaderTbl where("Created" = const(false)));
        }

        field(59001; "POM SO Error"; Integer)
        {
            Caption = 'POM SO Errors';

            FieldClass = FlowField;
            CalcFormula = count(POM2HeaderTbl where("Process Remarks" = filter(<> '')));
        }
        field(59002; "POM SO Line Error"; Integer)
        {
            Caption = 'POM SO Line Errors';

            FieldClass = FlowField;
            CalcFormula = count(POM2DetailsTbl where(Created = const(false)));
        }

    }

}