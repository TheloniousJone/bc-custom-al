pageextension 55151 WhseShipmentSubform extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Bin Code")
        {
            field(MinShelf; VarMinShelf)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Favorable;
            }
        }
    }

    var
        VarMinShelf: Date;
        Cust: Record Customer;
        MiniShelf: Record MinimumShelf;
        SalesInvHdr: Record "Sales Invoice Header";
        WhMoveHdr: Record "Warehouse Shipment Header";


    trigger OnAfterGetRecord()
    begin
        Clear(VarMinShelf);

        SalesInvHdr.Reset();
        SalesInvHdr.SetRange("Order No.", Rec."Source No.");
        if SalesInvHdr.FindFirst() then begin
            Cust.Reset();
            Cust.SetRange("No.", SalesInvHdr."Sell-to Customer No.");
            if Cust.FindFirst() then begin
                MiniShelf.Reset();
                MiniShelf.SetRange("No.", Rec."Item No.");
                MiniShelf.SetRange(Code, Cust."Customer Price Group");
                if MiniShelf.FindFirst() then begin
                    WhMoveHdr.Reset();
                    WhMoveHdr.SetRange("No.", Rec."No.");
                    if WhMoveHdr.FindFirst() then
                        VarMinShelf := CalcDate(MiniShelf.MinShelf, WhMoveHdr."Posting Date");
                end;

            end;

        end;

    end;
}