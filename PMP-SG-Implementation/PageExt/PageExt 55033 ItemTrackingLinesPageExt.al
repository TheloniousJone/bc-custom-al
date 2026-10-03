pageextension 55033 ItemTrackingLinesPageExt extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {

            //DX        17 Aug 2021
            // field(Exchangeable; Rec.Exchangeable)
            // {
            //     ApplicationArea = all;
            // }
            //DX        17 Aug 2021
        }
        modify("Expiration Date")
        {
            Visible = true;

            trigger OnBeforeValidate()
            var
                ILERec: Record "Item Ledger Entry";
                EarliestInvExpDate: Date;
            begin
                // Message('Before ' + Format("Expiration Date") + ' | ' + Format(CurrentSourceType) + ' | ' + Format(Rec."Item No."));
                EarliestInvExpDate := 0D;

                if (Rec."Expiration Date" <> 0D) And (CurrentSourceType = 39) then begin
                    // Get the earliest inventory expiry date from ILE
                    ILERec.Reset;
                    ILERec.SetRange("Item No.", Rec."Item No.");
                    ILERec.SetFilter("Remaining Quantity", '<>0');
                    ILERec.SetCurrentKey("Expiration Date");
                    ILERec.SetAscending("Expiration Date", true);
                    if ILERec.FindFirst() then begin
                        EarliestInvExpDate := ILERec."Expiration Date";
                        if Rec."Expiration Date" < EarliestInvExpDate then
                            Message('Entered expiry date is earlier than earliest current inventory. Please investigate.');
                    end;
                end;
            end;

            trigger OnAfterValidate()
            var
                EnhanceCU: Codeunit "PMP-Enhancements";
            begin
                //DX        17 Aug 2021     Obselete
                // if Rec."Expiration Date" <> 0D then begin
                //     Rec.Exchangeable := EnhanceCU.IsExchangeable(Rec);
                // end else begin
                //     rec.Exchangeable := false;
                // end;
                // rec.Modify(true);
            end;
        }
        modify("Lot No.")
        {
            Visible = true;
        }

        modify("Serial No.")
        {
            Visible = false;
        }
        modify(AvailabilitySerialNo)
        {
            Visible = false;
        }
        addafter("ItemTrackingCode.Code")
        {
            field("Base Unit Of Measure"; Item."Base Unit of Measure")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }




}
