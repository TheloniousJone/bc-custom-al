tableextension 52100 RoleCentreCueExt extends RoleCentreCues
{
    fields
    {
        // PO Not Processed
        field(52100; "DKSH PO Not Processed"; Integer)
        {
            Caption = 'DKSH PO Not Processed';

            FieldClass = FlowField;
            CalcFormula = count("DKSH Staging Purch. Order Hdr." where(Closed = const(false)));
        }

        // PO Has Error
        field(52101; "DKSH PO Error"; Integer)
        {
            Caption = 'DKSH PO Error';

            FieldClass = FlowField;
            CalcFormula = count("DKSH Staging Purch. Order Hdr." where("Has Error" = const(true)));
        }

        // PR not Updated
        field(52102; "DKSH Rcpt. Not Processed"; Integer)
        {
            Caption = 'DKSH Rcpt. Not Processed';

            FieldClass = FlowField;
            CalcFormula = count("DKSH Staging Purch. Rcpt. Hdr." where(Closed = const(false)));
        }

        // PR Error
        field(52103; "DKSH Rcpt. Error"; Integer)
        {
            Caption = 'DKSH Rcpt. Error';

            FieldClass = FlowField;
            CalcFormula = count("DKSH Staging Purch. Rcpt. Hdr." where("Has Error" = const(true)));
        }

    }

}