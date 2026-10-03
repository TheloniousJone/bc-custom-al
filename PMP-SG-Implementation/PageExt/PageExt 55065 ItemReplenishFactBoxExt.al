pageextension 55065 ItemReplenishFactBoxExt extends "Item Replenishment FactBox"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = Planning;
            }
            field("Wholesale Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
            }
            //DX        30 Aug 2021
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            //DX        30 Aug 2021
            field("Reorder Point"; Rec."Reorder Point")
            {
                ApplicationArea = all;
                Caption = 'Reorder Point';
            }
            field("Reorder Quantity"; Rec."Reorder Quantity")
            {
                ApplicationArea = all;
                Caption = 'Reorder Qty';
            }

            field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
            {
                ApplicationArea = all;
                Caption = 'Minimum Qty';
            }
            field("Maximum Inventory"; Rec."Maximum Inventory")
            {
                ApplicationArea = all;
                Caption = 'Maximum Qty';
            }
            field("Inventory"; Rec.Inventory)
            {
                ApplicationArea = all;
                Caption = 'Stock Balance';
                Editable = false;
                BlankZero = true;
            }
            field(Qty; Rec.Inventory - Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
                Caption = 'Available Qty';
                Visible = false; // YF 12 Nov 2021
            }

            // YF 12 Nov 2021
            field(AvailPMPWHQty; PMPWHAvailQty)
            {
                ApplicationArea = All;
                Caption = 'Avail. Qty in PMP-WH';
            }
            // YF 12 Nov 2021

            field(PMPItem; PMPItem)
            {
                ApplicationArea = all;
                Caption = 'PMP Balance';
            }
            field(WellItem; WellItem)
            {
                ApplicationArea = all;
                Caption = 'Wellaway Balance';
            }
            field(PLItem; PLItem)
            {
                ApplicationArea = all;
                Caption = '3PL Balance';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ILEREc: Record "Item Ledger Entry";
    begin
        PMPItem := 0;
        WellItem := 0;
        PLItem := 0;
        ILEREc.reset;
        ILEREc.SetRange("Item No.", Rec."No.");
        ILEREc.SetFilter("Location Code", 'PMP-WH');
        ILEREc.SetFilter("Remaining Quantity", '<>0');
        if ILEREc.FindSet() then
            repeat
                PMPItem += ILEREc."Remaining Quantity";
            until ILEREc.next = 0;
        ILEREc.reset;
        ILEREc.SetRange("Item No.", Rec."No.");
        ILEREc.SetFilter("Location Code", 'WELLAWAY');
        ILEREc.SetFilter("Remaining Quantity", '<>0');
        if ILEREc.FindSet() then
            repeat
                WellItem += ILEREc."Remaining Quantity";
            until ILEREc.next = 0;
        ILEREc.reset;
        ILEREc.SetRange("Item No.", Rec."No.");
        ILEREc.SetFilter("Location Code", '3PL-WH');
        ILEREc.SetFilter("Remaining Quantity", '<>0');
        if ILEREc.FindSet() then
            repeat
                PLItem += ILEREc."Remaining Quantity";
            until ILEREc.next = 0;

        PMPWHAvailQty := CalculateAvailableQtyPMPWH(); // YF 12 Nov 2021
    end;

    // YF 12 Nov 2021
    local procedure CalculateAvailableQtyPMPWH(): Decimal
    var
        PMPWHInventoryQty: Decimal;
        PMPWHQtySO: Decimal;
        ILERec: Record "Item Ledger Entry";
        SalesLineRec: Record "Sales Line";
    begin
        // Get Inventory Amount in PMP-WH Qty
        // YF 15 Nov 2021
        ILERec.Reset;
        ILERec.SetRange("Item No.", Rec."No.");
        ILERec.SetFilter("Location Code", 'PMP-WH');
        ILERec.SetFilter("Remaining Quantity", '<>0');
        if ILERec.FindSet() then
            repeat
                PMPWHInventoryQty += ILERec."Remaining Quantity";
            until ILERec.next = 0;
        /*
        ILERec.Reset;
        ILERec.SetRange("Item No.", Rec."No.");
        ILERec.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Filter");
        ILERec.SetRange("Global Dimension 2 Code", Rec."Global Dimension 2 Filter");
        ILERec.SetRange("Location Code", 'PMP-WH');
        ILERec.SetRange("Drop Shipment", Rec."Drop Shipment Filter");
        ILERec.SetRange("Variant Code", Rec."Variant Filter");
        ILERec.SetRange("Lot No.", Rec."Lot No. Filter");
        ILERec.SetRange("Serial No.", Rec."Serial No. Filter");
        ILERec.SetRange("Unit of Measure Code", Rec."Unit of Measure Filter");
        ILERec.SetRange("Package No.", Rec."Package No. Filter");
        ILERec.CalcSums(Quantity);
        PMPWHInventoryQty := ILERec.Quantity;
        */
        // YF 15 Nov 2021

        // Get Qty on Sales Order in PMP-WH Qty
        SalesLineRec.Reset;
        SalesLineRec.SetRange("Document Type", SalesLineRec."Document Type"::Order);
        SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
        SalesLineRec.SetRange("No.", Rec."No.");
        // SalesLineRec.SetRange("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Filter");  // YF 15 Nov 2021
        // SalesLineRec.SetRange("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Filter");  // YF 15 Nov 2021
        SalesLineRec.SetRange("Location Code", 'PMP-WH');
        // SalesLineRec.SetRange("Drop Shipment", Rec."Drop Shipment Filter");  // YF 15 Nov 2021
        // SalesLineRec.SetRange("Variant Code", Rec."Variant Filter");  // YF 15 Nov 2021
        // SalesLineRec.SetRange("Shipment Date", Rec."Date Filter");  // YF 15 Nov 2021
        // SalesLineRec.SetRange("Unit of Measure Code", Rec."Unit of Measure Filter");  // YF 15 Nov 2021
        SalesLineRec.CalcSums("Outstanding Qty. (Base)");
        PMPWHQtySO := SalesLineRec."Outstanding Qty. (Base)";

        exit(PMPWHInventoryQty - PMPWHQtySO);
    end;
    // YF 12 Nov 2021

    var
        Qty: Decimal;
        PMPItem: Decimal;
        WellItem: Decimal;
        PLItem: Decimal;
        PMPWHAvailQty: Decimal; // YF 12 Nov 2021
}
