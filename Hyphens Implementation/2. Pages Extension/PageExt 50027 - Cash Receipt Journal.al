pageextension 50027 HyphensCashRcptJL extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Amount)
        {
            field("Peg Rate of Invoice"; Rec."Peg Rate of Invoice")
            {
                ApplicationArea = All;
                Editable = true;
                Visible = ShowPegFeature;
            }

            field("VND Paid Rate"; Rec."VND Paid Rate")
            {
                ApplicationArea = All;
                Caption = 'Paid Rate';
                Visible = ShowPegFeature;
            }

            field("Paid VND"; Rec."Paid VND")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("Difference VND"; Rec."Difference VND")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("Exchange Variable"; Rec."Exchange Variable")
            {
                ApplicationArea = All;
                Editable = true;
                Visible = ShowPegFeature;
            }

            field("Exchange Variable Settlement"; Rec."Exchange Variable Settlement")
            {
                ApplicationArea = All;
                Editable = true;
                Visible = ShowPegFeature;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addbefore("P&osting")
        {
            action("Exchange Settlement")
            {
                ApplicationArea = All;
                Image = AdjustExchangeRates;
                Caption = 'Exchange Settlement';
                Visible = ShowPegFeature;

                trigger OnAction()
                var
                    HyphensCU: Codeunit "Hyphens CU";
                begin
                    Clear(HyphensCU);
                    CurrPage.SetSelectionFilter(GenJnlRec);
                    if HyphensCU.ProcessExchangeSettlementLines(GenJnlRec) then begin
                        CurrPage.Update(true);
                        Message('Exchange Settlement Done');
                    end;
                end;
            }
            action("Print CN")
            {
                ApplicationArea = All;
                Image = AdjustExchangeRates;
                Caption = 'Print CN/Invoice';
                Visible = ShowPegFeature;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    // CLERec: Record "Cust. Ledger Entry";
                    CRJREC: Record "Gen. Journal Line";
                begin

                    CurrPage.SetSelectionFilter(CRJREC);
                    report.Run(50022, true, true, CRJREC);
                    // Report.Run(50014);
                end;
            }

        }

        /*
        modify("Apply Entries")
        {
            ApplicationArea = All;

            trigger OnAfterAction()
            var
                CLERec: Record "Cust. Ledger Entry";
            begin
                // YF 08 Dec 2021 
                // make sure peg rate from invoice is updated
                if Rec."Peg Rate of Invoice" = 0 then begin
                    CLERec.Reset;
                    CLERec.SetRange("Document Type", Rec."Applies-to Doc. Type");
                    CLERec.SetRange("Document No.", Rec."Applies-to Doc. No.");
                    if CLERec.FindFirst() then begin
                        Rec."Peg Rate of Invoice" := CLERec."Peg Rate";
                        if CLERec."Peg Rate" = 0 then
                            Rec."Peg Rate of Invoice" := CLERec."Peg Rate of Invoice";
                    end;
                end;
                // make sure peg rate from invoice is updated

                Rec.CalculateVNDPaidRate(); // trigger calculations again

                // YF 08 Dec 2021 
            end;
        }
        */
    }

    trigger OnOpenPage()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        ShowPegFeature := CompanyInfoRec."Enable Peg Rate Module";
    end;

    var
        ShowPegFeature: Boolean;
        GenJnlRec: Record "Gen. Journal Line";

}