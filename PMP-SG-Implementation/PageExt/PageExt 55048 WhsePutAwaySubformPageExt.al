pageextension 55048 WhsePutAwaySubformPageExt extends "Whse. Put-away Subform"
{
    layout
    {
        modify("Item No.")
        {
            Style = Attention;
            StyleExpr = StyleType;
        }
        modify("Qty. to Handle")
        {
            Style = Attention;
            StyleExpr = StyleType;
        }
        modify(Description)
        {
            Style = Attention;
            StyleExpr = StyleType;
        }
        modify("Lot No.")
        {
            Style = Attention;
            StyleExpr = StyleType;
        }
        modify("Expiration Date")
        {
            Style = Attention;
            StyleExpr = StyleType;
        }

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
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if Rec."Qty. to Handle" = 0 then
            StyleType := true
        else
            StyleType := FAlse;

        Clear(VarMinShelf);

        WhShipeLine.Reset();
        WhShipeLine.SetRange("Source No.", Rec."Source No.");
        if WhShipeLine.FindFirst() then begin
            WhShipeHdr.Reset();
            WhShipeHdr.SetRange("No.", WhShipeLine."No.");
            if WhShipeHdr.FindFirst() then begin
                WhActyHdr.Reset();
                WhActyHdr.SetRange("No.", Rec."No.");
                if WhActyHdr.FindFirst() then begin
                    Cust.Reset();
                    Cust.SetRange("No.", WhActyHdr."Source Vend/Cust No.");
                    if Cust.FindFirst() then begin
                        MiniShelf.Reset();
                        MiniShelf.SetRange("No.", Rec."Item No.");
                        MiniShelf.SetRange(Code, Cust."Customer Price Group");
                        if MiniShelf.FindFirst() then begin
                            VarMinShelf := CalcDate(MiniShelf.MinShelf, WhShipeHdr."Posting Date");
                        end;
                    end;

                end;
            end;
        end;
    end;

    var
        StyleType: Boolean;
        VarMinShelf: Date;
        Cust: Record Customer;
        MiniShelf: Record MinimumShelf;
        SalesShipHdr: Record "Sales Shipment Header";
        WhShipeLine: Record "Warehouse Shipment Line";
        WhShipeHdr: Record "Warehouse Shipment Header";
        WhActyHdr: Record "Warehouse Activity Header";

}
