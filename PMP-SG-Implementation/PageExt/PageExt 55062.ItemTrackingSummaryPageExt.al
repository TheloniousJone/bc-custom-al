pageextension 55062 ItemTrackingSummaryPageExt extends "Item Tracking Summary"
{
    layout
    {
        addafter("Total Available Quantity")
        {
            field(PickQty; PickQty)
            {
                Caption = 'Warehouse Allocated Pick Qty';
                ApplicationArea = all;
                Editable = false;
                Style = Attention;
            }
            field(NetQty; NetQty)
            {
                Caption = 'Net Quantity';
                ApplicationArea = all;
                Editable = false;
                Style = Attention;
            }

        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;

    begin
        PickQty := 0;
        NetQty := 0;
        WHActLine.reset;
        WHActLine.SetRange("Action Type", WHActLine."Action Type"::Take);
        WHActLine.SetRange("Expiration Date", Rec."Expiration Date");
        WHActLine.SetRange("Lot No.", Rec."Lot No.");
        if WHActLine.FindSet() then
            repeat
                PickQty += WHActLine."Qty. (Base)";
            until WHActLine.next = 0;

        NetQty := rec."Total Available Quantity" - PickQty;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        /*
        if Rec.FindSet() then
            repeat
                if Rec."Selected Quantity" <> 0 then begin
                    PickQty := 0;
                    NetQty := 0;
                    WHActLine.reset;
                    WHActLine.SetRange("Action Type", WHActLine."Action Type"::Take);
                    WHActLine.SetRange("Expiration Date", Rec."Expiration Date");
                    WHActLine.SetRange("Lot No.", Rec."Lot No.");
                    if WHActLine.FindSet() then
                        repeat
                            PickQty += WHActLine."Qty. (Base)";
                        until WHActLine.next = 0;

                    NetQty := rec."Total Available Quantity" - PickQty;

                    //RL     29 Oct 2021
                    /* 
                                        if NetQty < Rec."Selected Quantity" then
                                            Error('Net Quantity is lesser than selected quantity, please check again.');
                                    
                end;

            //if NetQty < Rec."Selected Quantity" then
            //    Message('Selected quantity is more than net quantity.');
            until Rec.next = 0;
            */
    end;

    var
        PickQty: Decimal;
        NetQty: Decimal;
        WHActLine: Record "Warehouse Activity Line";

}
