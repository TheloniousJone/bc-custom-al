pageextension 55037 BankAccReconLinePageExt extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addfirst(Control1)
        {
            //DX        19 July 2021
            field(Checked; Rec.Checked)
            {
                ApplicationArea = all;
            }
            //DX        19 July 2021
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        Rec.Checked := true;

    end;
}
