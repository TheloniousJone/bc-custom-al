pageextension 52002 DBSPaymentJnlPageExt extends "Payment Journal"
{
    layout
    {
        // add fields here
        addafter("Bal. Account No.")
        {
            field("DBS Product Type"; Rec."DBS Product Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            group(DBSHost2Host)
            {

                Caption = 'DBS Host to Host Integration';

                action("Send to DBS Host to Host Staging")
                {
                    Caption = 'Send to DBS Host to Host Staging';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category4;
                    Image = SendTo;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        DBSH2HCU: Codeunit "DBS Host to Host Codeunit";
                        SelectedPaytJournal: Record "Gen. Journal Line";
                    begin
                        Clear(DBSH2HCU);
                        Clear(SelectedPaytJournal);
                        CurrPage.SetSelectionFilter(SelectedPaytJournal);

                        // YF 11 Mar 2022
                        // check the payment journal to have only 1 product type, 1 posting date, 1 originating bank 
                        if ViolateFilterRestrictions(SelectedPaytJournal) then
                            Error('Selected lines to have only 1 product type, 1 posting date, 1 originating bank');
                        // YF 11 Mar 2022

                        DBSH2HCU.AddToStaging(SelectedPaytJournal);
                    end;
                }

                action("View DBS Host to Host Staging List")
                {
                    Caption = 'View DBS Host to Host Staging List';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category4;
                    Image = ViewDocumentLine;
                    ApplicationArea = All;
                    RunObject = Page "DBS H2H Staging List";
                }

            }
        }
    }

    // YF 11 Mar 2022
    // check the payment journal to have only 1 product type, 1 posting date, 1 originating bank 
    local procedure ViolateFilterRestrictions(var SelPaytJnl: Record "Gen. Journal Line"): Boolean
    var
        SourceRecCounter: Integer;
        FilterRecCounter: Integer;
        FilterRec: Record "Gen. Journal Line";
        TempRec: Record "Gen. Journal Line";
    begin
        SourceRecCounter := SelPaytJnl.Count;
        TempRec.Copy(SelPaytJnl);
        TempRec.FindFirst();

        FilterRec.Copy(SelPaytJnl);
        FilterRec.SetRange("Posting Date", TempRec."Posting Date");
        FilterRec.SetRange("DBS Product Type", TempRec."DBS Product Type");
        FilterRec.SetRange("Bal. Account No.", TempRec."Bal. Account No.");
        FilterRecCounter := FilterRec.Count;

        if SourceRecCounter <> FilterRecCounter then
            exit(true);

        exit(false);
    end;
    // YF 11 Mar 2022
}