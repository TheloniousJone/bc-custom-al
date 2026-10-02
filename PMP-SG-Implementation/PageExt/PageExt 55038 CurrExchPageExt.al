pageextension 55038 CurrExchPageExt extends "Currency Exchange Rates"
{
    layout
    {


    }
    actions
    {
        addfirst(Processing)
        {
            action("Sync Curreny Rate")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = OutlookSyncFields;
                ApplicationArea = all;

                trigger OnAction()
                var
                    lexchRate: Record "Currency Exchange Rate";
                    EnhanceCU: Codeunit "PMP-Enhancements";
                begin
                    if Confirm('Are you sure you wish to synchronize these exchange rates?') then begin
                        CurrPage.SetSelectionFilter(lexchRate);
                        if lexchRate.FindSet() then
                            repeat
                                Clear(EnhanceCU); // YF 09 Jan 2022
                                EnhanceCU.SyncCurrencies(lexchRate);
                            until lexchRate.next = 0;
                        Message('Sync completed'); // YF 09 Jan 2022
                    end;
                end;
            }
        }
    }
}
