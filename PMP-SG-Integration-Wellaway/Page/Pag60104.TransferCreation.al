page 60104 "Transfer Creation"
{

    Caption = 'Transfer Stock Creation';
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    Editable = true;
    //SourceTableView = where("Invoiced In PMP" = const(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    Caption = 'Ordered Qty';
                    ToolTip = 'Customer Ordered Qty';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(StockBalLoose; StockBalLoose)
                {
                    ApplicationArea = all;
                    Caption = 'Current Stock Balance (Loose)';
                    Editable = false;
                }
                field(StockBal; StockBal)
                {
                    ApplicationArea = all;
                    Caption = 'Current Stock Balance (Base)';
                    Editable = false;
                }
                field(StockDiff; StockDiff)
                {
                    ApplicationArea = all;
                    Style = Attention;
                    StyleExpr = StyleType;
                    Caption = 'Proj. Stock Balance';
                    Editable = false;
                    Visible = false;
                }
                field(PMPBal; PMPBal)
                {
                    ApplicationArea = all;
                    Caption = 'Stock Balance in PMP WH.';
                    Editable = false;
                    Visible = true;
                }
                field(QtyOnTransfer; QtyOnTransfer)
                {
                    ApplicationArea = all;
                    Caption = 'Stock On Transfer';
                    Editable = false;
                }
                field(QtyToOrder; Rec.Amount)
                {
                    ApplicationArea = all;
                    Caption = 'Qty to Order from PMP';
                    StyleExpr = StyleType;
                    Editable = true;
                }
                field(ReOrder; Rec."Drop Shipment")
                {
                    ApplicationArea = all;
                    Caption = 'To Create Transfer';
                    Visible = false;
                }

            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Create Journals")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Create;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you wish to create this transfer journals?') then begin
                        if rec.FindSet() then
                            repeat
                                if (Rec."Drop Shipment" = true) AND (Rec.Amount > 0) then
                                    WellCU.CreateTransferJournal(Rec."No.", Rec.Amount);
                            until Rec.next = 0;
                        WellCU.CreateOrder();
                        Message('Transfer Journals Created to PMP.');

                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ItemRec: Record item;
        IJRec: Record "Item Journal Line";
        SSSetup: Record "Sales & Receivables Setup";
        CompRec: Record "Company Information";
    begin
        if Rec."No." <> '' then begin
            QtyOnTransfer := 0;
            SSSetup.reset;
            SSSetup.get;
            SSSetup.TestField("Def Item. Journal Batch");
            IJRec.reset;
            IJRec.SetRange("Journal Template Name", 'ITEM');
            IJRec.SetRange("Journal Batch Name", SSSetup."Def Item. Journal Batch");
            IJRec.SetRange("Item No.", Rec."No.");
            IJRec.SetFilter("Quantity (Base)", '<>0');
            IJRec.LoadFields("Quantity (Base)");
            if IJRec.FindSet() then
                repeat
                    QtyOnTransfer += IJRec."Quantity (Base)";
                until IJRec.next = 0;
            ItemRec.reset;
            ItemRec.get(Rec."No.");
            ItemRec.CalcFields(Inventory);

            StockBal := ItemRec.Inventory;
            //DX        08 Aug 2021
            StockBalLoose := WellCU.GetTotalLooseQty(Rec."No.");
            //DX        08 Aug 2021
            StockDiff := Rec."Quantity (Base)" - (StockBal + QtyOnTransfer);
            //DX        16 Aug 2021
            Rec.Amount := round(Rec."Quantity (Base)" - (StockBal + QtyOnTransfer), 1, '>');
            //DX        16 Aug 2021

            if Rec.Amount > 0 then begin
                StyleType := true;
                Rec."Drop Shipment" := true;
            end else begin
                StyleType := false;
                Rec."Drop Shipment" := false;
                Rec.Amount := 0;
            end;
            Rec.Modify(FALSE);


            CompRec.reset;
            CompRec.ChangeCompany(WellCU.GetPMPCompanyName());
            CompRec.get;
            ItemRec.reset;
            ItemRec.ChangeCompany(WellCU.GetPMPCompanyName());
            ItemRec.Get(Rec."No.");
            ItemRec.SetFilter("Location Filter", CompRec."Location Code");
            ItemRec.CalcFields(Inventory);
            PMPBal := ItemRec.Inventory;

        end;


    end;

    trigger OnOpenPage()
    var
    begin
        LoadDataFromSOLine();
    end;

    local procedure LoadDataFromSOLine()
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        WellCU: Codeunit "Wellaway CU";
        ItemRec: Record item;
        ItemLoop: Record "Item" temporary;
        ItemLoop2: Record item temporary;
        SLLoopChec: Record "Sales Line" temporary;
        TotalQty: Decimal;
    begin

        if Rec.IsTemporary then
            Rec.DeleteAll();

        SLRec.reset;
        SLRec.ChangeCompany(WellCU.GetWellawayCompany());
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter("No.", '<>%1', '');
        SLRec.SetFilter("Quantity (Base)", '<>0');
        SLRec.SetRange("Invoiced In PMP", false);
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetFilter("Outstanding Quantity", '<>0'); //DX        03 Apr 2023
        if SLRec.FindSet() then     //DX        25 July 2021        Get total unique combination of all item orders
            repeat

                ItemRec.reset;
                ItemRec.SetRange("No.", SLRec."No.");
                if itemrec.Type = ItemRec.Type::Inventory then begin
                    ItemLoop.reset;
                    ItemLoop.SetRange("No.", SLRec."No.");
                    if not ItemLoop.FindFirst() then begin
                        ItemLoop2.reset;
                        ItemLoop2.Init();
                        ItemLoop2."No." := SLRec."No.";
                        ItemLoop2.Insert(false);
                        ItemLoop.Init();
                        ItemLoop.Copy(ItemLoop2);
                        ItemLoop.Insert(false);
                    end;
                end;

            until SLRec.next = 0;

        if ItemLoop2.count <> 0 then begin
            if itemloop2.FindSet() then
                repeat
                    SLRec.reset;
                    SLRec.ChangeCompany(WellCU.GetWellawayCompany());
                    SLRec.SetRange(Type, SLRec.Type::Item);
                    SLRec.SetFilter("No.", ItemLoop2."No.");
                    SLRec.SetFilter(Quantity, '<>0');
                    SLRec.SetRange("Invoiced In PMP", false);
                    SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
                    SLRec.SetLoadFields("Quantity (Base)", "Qty. Shipped (Base)");
                    if SLRec.FindSet() then
                        repeat
                            // TotalQty += SLRec."Quantity (Base)" - Rec."Qty. Shipped (Base)"; // YF 08 Nov 2021 // Bug fix
                            TotalQty += SLRec."Quantity (Base)" - SLRec."Qty. Shipped (Base)"; // YF 08 Nov 2021 // Bug fix
                        until SlRec.next = 0;
                    //DX        create temporary data.

                    Rec."Document No." := 'Data';
                    Rec."Line No." := myInt;
                    Rec."No." := ItemLoop2."No.";
                    if ItemLoop2."No." <> '' then begin
                        ItemRec.reset;
                        ItemRec.get(ItemLoop2."No.");
                        Rec."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                        Rec.Description := ItemRec.Description;
                    end;
                    rec."Quantity (Base)" := TotalQty;

                    // YF 08 Nov 2021 // Filter Changes
                    if TotalQty > 0 then
                        Rec.insert(FALSE);
                    // YF 08 Nov 2021 // Filter Changes

                    TotalQty := 0;
                    myInt += 10000;
                until ItemLoop2.next = 0;

        end;
    end;



    var
        WellCU: Codeunit "Wellaway CU";
        StockBal: Decimal;
        StockBalLoose: Decimal;
        StockDiff: Decimal;
        PMPBal: Decimal;
        StyleType: Boolean;
        ReOrder: Boolean;
        QtyToOrder: Decimal;
        QtyOnTransfer: Decimal;

        PMPStock: Decimal;
}
