page 55071 CheckStockAvail
{

    ApplicationArea = All;
    Caption = 'Check Stock Availability';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Warehouse; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field(ItemDesc; ItemDesc)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }

                field("Physical Inv."; PhysStock)
                {
                    ApplicationArea = all;
                }
                field("Physical Reserved."; ResStock)
                {
                    ApplicationArea = all;
                }
                field("Available Stock"; AvailStock)
                {
                    ApplicationArea = all;
                }
                field(SOStock; SOStock)
                {
                    ApplicationArea = all;
                    Caption = 'SO. Stock';
                }
                field(POStock; POStock)
                {
                    ApplicationArea = all;
                    Caption = 'PO. Stock';
                }
                field("Total Avail"; TotalAvail)
                {
                    ApplicationArea = all;
                    Style = Attention;
                    StyleExpr = StyleExp;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Check All Inventory")
            {
                Caption = 'Check All Inventory.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    myInt: Integer;
                    EnhaceCU: Codeunit "PMP-Enhancements";
                begin
                    Loaddata(false);
                end;
            }
            action("Check By Item.")
            {
                Caption = 'Check By Item';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    myInt: Integer;
                    EnhaceCU: Codeunit "PMP-Enhancements";
                begin
                    Loaddata(true);

                end;
            }
        }
    }


    local procedure Loaddata(ByItem: Boolean)
    var
        myInt: Integer;
        ItemList: page "Item List";
        ItemRec: Record item;
        ItemFilter: code[300];
        RecRun: integer;
        RecordCount: Integer;
    begin
        if Rec.IsTemporary then
            Rec.DeleteAll();
        if TempILE2.IsTemporary then
            TempILE2.DeleteAll();
        IF ByItem THEN BEGIN
            ItemList.LOOKUPMODE := TRUE;
            RecRun := 1;
            IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ItemList.SetSelection(ItemRec);
                RecordCount := ItemRec.COUNT;
                IF RecordCount > 20 THEN
                    ERROR('Please select up to a maximum of 20 items only');
                IF ItemRec.FINDSET THEN
                    REPEAT

                        IF RecRun < RecordCount THEN
                            ItemFilter := ItemFilter + ItemRec."No." + '|'
                        ELSE
                            ItemFilter := ItemFilter + ItemRec."No.";
                        RecRun += 1;
                    UNTIL ItemRec.NEXT = 0;

            END;
        END;



        ILERec.RESET;
        ILERec.SETFILTER("Remaining Quantity", '>0');
        // ILERec.SETFILTER("Lot No.",'<>%1','');
        IF ItemFilter <> '' THEN
            ILERec.SETFILTER("Item No.", ItemFilter);
        ProgressWindow.OPEN('Processing item #1##################');

        IF ILERec.FINDSET THEN
            REPEAT

                ProgressWindow.UPDATE(1, ILERec."Item No.");
                CLEAR(TempILE2);
                TempILE2.RESET;
                TempILE2.SETRANGE("Item No.", ILERec."Item No.");
                TempILE2.SETRANGE("Lot No.", ILERec."Lot No.");
                TempILE2.SETRANGE("Location Code", ILERec."Location Code");
                IF NOT (TempILE2.FINDFIRST) THEN BEGIN
                    Rec.RESET;
                    Rec.INIT;
                    Rec."Entry No." := EntryNo;
                    Rec."Item No." := ILERec."Item No.";
                    Rec."Lot No." := ILERec."Lot No.";
                    Rec."Expiration Date" := ILERec."Expiration Date";
                    Rec."Location Code" := ILERec."Location Code";
                    //Rec."Remaining Quantity" := ILERec."Remaining Quantity";                    
                    ItemRec.RESET;
                    IF ItemRec.GET(ILERec."Item No.") THEN
                        Rec.Description := ItemRec.Description;
                    Rec.INSERT(FALSE);
                    EntryNo += 1;
                    TempILE2.RESET;
                    TempILE2.INIT;
                    TempILE2.COPY(Rec);
                    TempILE2.INSERT(FALSE);
                END;
            UNTIL ILERec.NEXT = 0;

        ProgressWindow.CLOSE;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.IsTemporary then
            Rec.DeleteAll();
    end;



    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
    begin
        ItemRec.reset;
        ItemRec.SetRange("No.", Rec."Item No.");
        ItemRec.SetFilter("Location Filter", Rec."Location Code");
        ItemRec.SetFilter("Lot No. Filter", Rec."Lot No.");
        ItemRec.CalcFields(ItemRec."Qty. on Sales Order", ItemRec."Qty. on Purch. Order", ItemRec.Inventory);
        PhysStock := ItemRec.Inventory;
        SOStock := ItemRec."Qty. on Sales Order";
        POStock := ItemRec."Qty. on Purch. Order";
        if ItemRec.FindFirst() then begin
            ItemDesc := ItemRec.Description;
        end;

        WHActLine.reset;
        WHActLine.SetRange("Lot No.", Rec."Lot No.");
        WHActLine.SetRange("Item No.", Rec."Item No.");
        WHActLine.SetRange("Action Type", WHActLine."Action Type"::Take);
        WHActLine.SetRange("Activity Type", WHActLine."Activity Type"::Pick);
        WHActLine.LoadFields("Qty. (Base)");
        WHActLine.CalcSums("Qty. (Base)");
        ResStock := WHActLine."Qty. (Base)";
        AvailStock := PhysStock - ResStock;
        TotalAvail := AvailStock - SOStock + POStock;
        if TotalAvail < 0 then
            StyleExp := true
        else
            StyleExp := false;
    end;

    var
        TempILE: Record "Item Ledger Entry" temporary;
        TempILE2: Record "Item Ledger Entry" temporary;
        ProgressWindow: Dialog;
        ILERec: Record "Item Ledger Entry";
        EntryNo: integer;
        ItemRec: Record item;
        PhysStock: Decimal;
        SOStock: Decimal;
        POStock: Decimal;
        ResStock: Decimal;
        AvailStock: Decimal;
        TotalAvail: Decimal;
        ItemDesc: Text[100];

        StyleExp: Boolean;
}

