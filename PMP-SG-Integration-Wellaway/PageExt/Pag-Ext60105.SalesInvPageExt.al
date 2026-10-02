pageextension 60105 WellSalesInvPageExt extends "Sales Invoice"
{
    actions
    {
        addafter(Release)
        {
            action("Generate Wellaway Inv.")
            {
                ApplicationArea = All;
                Visible = false;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    WellCU: Codeunit "Wellaway CU";
                    CustList: Page "Customer List";
                    CustRec: Record customer;
                    selCustRec: Record customer;

                begin
                    if WellCU.IsPMPCompany() then begin
                        if Confirm('Are you sure you wish to generate the Wellaway invoices?') then begin

                            //WellCU.GenConsolidatedInv(Rec);
                            //DX        18 Aug 2021
                            //    trigger OnAction()
                            //                     var
                            //                         LSList: Page "LS Ledger Entry";
                            //                         LSRecFilter: Record "LS Ledger Entry";
                            //                         LSSelRec: Record "LS Ledger Entry";
                            //                         LSCU: Codeunit ls;
                            //                         CUstRec: Record customer;
                            //                         TotalAmt: Decimal;
                            //                     begin
                            //                         LSRecFilter.RESET;
                            //                         LSRecFilter.SETRANGE("Customer No.", Rec."Sell-to Customer No.");
                            //                         LSRecFilter.SetRange(Closed, false);
                            //                         Clear(LSList);
                            //                         LSList.SETTABLEVIEW(LSRecFilter);
                            //                         LSList.LOOKUPMODE := TRUE;
                            //                         LSList.CAPTION := 'Select list of LS lines to invoice';
                            //                         if LSList.RunModal() = action::LookupOK then begin
                            //                             LSList.SetSelectionFilter(LSSelRec);
                            //                             CUstRec.reset;
                            //                             CUstRec.SetRange("No.", Rec."Sell-to Customer No.");
                            //                             if CUstRec.FindFirst() then begin
                            //                                 //DX        Check if customer LS is charged by what method
                            //                                 if CustRec.FindFirst() then begin
                            //                                     if CustRec."LS Percentage" = 0 then
                            //                                         Error('LS Percentage is currently set at 0, please set correctly before executing this process.');
                            //                                 end;
                            //                             end;
                            //                             if LSSelRec.FindSet() then
                            //                                 repeat
                            //                                     TotalAmt += LSSelRec."Commission Amount";
                            //                                     LSSelRec.Closed := true;    //DX Set to closed so that it will not trigger for invoicing again.
                            //                                     LSSelRec."Closed By" := Rec."No.";
                            //                                     LSSelRec.Modify(false);
                            //                                 until LSSelRec.next = 0;
                            //                             LSCU.CreateLSInvLine(TotalAmt, rec);
                            //                             Message('Transactions retrieved.');
                            //                         end;
                            //                     end;
                            //DX        18 Aug 2021

                        end;
                    end else begin
                        Error('Please only execute this function in the PMP company.');
                    end;

                end;
            }
        }
    }
}
