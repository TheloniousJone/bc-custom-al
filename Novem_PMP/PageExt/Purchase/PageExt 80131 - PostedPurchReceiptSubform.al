pageextension 80131 PostedPurchRcptSubformExt3PL extends "Posted Purchase Rcpt. Subform"
{
    actions
    {
        modify("&Undo Receipt")
        {
            trigger OnAfterAction()
            var
                I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
            begin
                /*Disable Undo Receipt functionality for 3PL
                I9G_ThirdPartyLogisticCodeUnit.UndoReceipt(Rec);
                */
            end;
        }
    }
}