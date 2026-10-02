pageextension 55152 WarehouseMovementSubform extends "Warehouse Movement Subform"
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
        SalesShipHdr: Record "Sales Shipment Header";
        WhShipeLine: Record "Warehouse Shipment Line";
        WhShipeHdr: Record "Warehouse Shipment Header";
        WhActyHdr: Record "Warehouse Activity Header";


    trigger OnAfterGetRecord()
    begin
        Clear(VarMinShelf);

        WhShipeLine.Reset();
        WhShipeLine.SetRange("Source No.", Rec."Source No.");
        if WhShipeLine.FindFirst() then begin
            WhShipeHdr.Reset();
            WhShipeHdr.SetRange("No.", Rec."No.");
            if WhShipeHdr.FindFirst() then begin
                WhActyHdr.Reset();
                WhActyHdr.SetRange("No.", Rec."No.");
                if WhActyHdr.FindFirst() then begin
                    Cust.Reset();
                    Cust.SetRange("No.", WhActyHdr."Source Vend/Cust Name");
                    if Cust.FindFirst() then begin
                        MiniShelf.Reset();
                        MiniShelf.SetRange("No.", Rec."Item No.");
                        MiniShelf.SetRange(Code, Cust."Customer Price Group");
                        if MiniShelf.FindFirst() then begin
                            WhShipeLine.Reset();
                            WhShipeLine.SetRange("No.", Rec."No.");
                            if WhShipeLine.FindFirst() then
                                VarMinShelf := CalcDate(MiniShelf.MinShelf, WhShipeHdr."Posting Date");
                        end;
                    end;

                end;
            end;
        end;
    end;
}