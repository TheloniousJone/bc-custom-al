reportextension 50000 GLRegRepExt extends "G/L Register"
{

    RDLCLayout = './ReportLayouts/ReportExtLayout 50000 - GLRegister.rdl';

    dataset
    {
        add("G/L Entry")
        {
            column(SourceCurr; SourceCurr) { }
            column(SourceAmt; SourceAmt) { }
        }

        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                PostGenJnlLineRec: Record "Posted Gen. Journal Line";
            begin
                SourceCurr := '';
                SourceAmt := 0;

                PostGenJnlLineRec.Reset;
                PostGenJnlLineRec.SetRange("G/L Register No.", "G/L Register"."No.");
                PostGenJnlLineRec.SetRange("Document No.", "G/L Entry"."Document No.");
                PostGenJnlLineRec.SetRange("Source Code", "G/L Entry"."Source Code");
                PostGenJnlLineRec.SetRange("Journal Batch Name", "G/L Entry"."Journal Batch Name");
                PostGenJnlLineRec.SetRange("Amount (LCY)", "G/L Entry".Amount); //RL 17 Feb 2022
                if PostGenJnlLineRec.FindFirst() then begin
                    SourceCurr := PostGenJnlLineRec."Currency Code";
                    SourceAmt := PostGenJnlLineRec.Amount;
                end;
            end;
        }

    }

    var
        SourceCurr: Code[20];
        SourceAmt: Decimal;


}
