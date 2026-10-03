page 60105 ItemWellyway
{

    ApplicationArea = All;
    Caption = 'ItemWellyway';
    PageType = List;
    SourceTable = ItemWellyway;
    UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field';
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Producte Name")
                {
                    ToolTip = 'Specifies the value of the Producte Name field';
                    ApplicationArea = All;
                }
                field("Base UOM"; Rec."Base UOM")
                {
                    ToolTip = 'Specifies the value of the Base UOM field';
                    ApplicationArea = All;
                }
                field("Item Status"; Rec."Item Status")
                {
                    ToolTip = 'Specifies the value of the Item Status field';
                    ApplicationArea = All;
                }
                field("Sales UOM"; Rec."Sales UOM")
                {
                    ToolTip = 'Specifies the value of the Sales UOM field';
                    ApplicationArea = All;
                }
                field("Generic Name"; Rec."Generic Name")
                {
                    ToolTip = 'Specifies the value of the Generic Name field';
                    ApplicationArea = All;
                }
                /*
                field("Available Status"; Rec."Available Status")
                {
                    ToolTip = 'Specifies the value of the Available Status field';
                    ApplicationArea = All;
                }
                */
                field("Available Status"; AvailStatusText)
                {
                    ToolTip = 'Specifies the value of the Available Status field';
                    ApplicationArea = All;
                }
                field("Expiry Date"; FORMAT(Rec."Expiry Date", 0, '<Year4>/<Month,2>/<Day,2>'))
                {
                    ToolTip = 'Specifies the value of the Expiry Date field';
                    ApplicationArea = All;
                }
                field("Forensic Group"; Rec."Forensic Group")
                {
                    ToolTip = 'Specifies the value of the Forensic Group field';
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field';
                    ApplicationArea = All;
                }
                field("Storage Condition"; Rec."Storage Condition")
                {
                    ToolTip = 'Specifies the value of the Storage Condition field';
                    ApplicationArea = All;
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ToolTip = 'Specifies the value of the Manufacturer field';
                    ApplicationArea = All;
                }
                field(Principal; Rec.Principal)
                {
                    ToolTip = 'Specifies the value of the Principal field';
                    ApplicationArea = All;
                }
                field("WholeSales Price"; Rec."WholeSales Price")
                {
                    ToolTip = 'Specifies the value of the WholeSales Price field';
                    ApplicationArea = All;
                }
                field("Item Group"; Rec."Item Group")
                {
                    ToolTip = 'Specifies the value of the Item Group field';
                    ApplicationArea = All;
                }
                field("Base Unit Description"; Rec."Base Unit Description")
                {
                    ToolTip = 'Specifies the value of the Base Unit Description field';
                    ApplicationArea = All;
                }
                field(WareHouse; Rec.WareHouse)
                {
                    ToolTip = 'Specifies the value of the WareHouse field';
                    ApplicationArea = All;
                }
                field("Instruction For Use"; Rec."Instruction For Use")
                {
                    ToolTip = 'Specifies the value of the Instruction For Use field';
                    ApplicationArea = All;
                }
                field(Precautions; Rec.Precautions)
                {
                    ToolTip = 'Specifies the value of the Precautions field';
                    ApplicationArea = All;
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    ToolTip = 'Specifies the value of the Pack Size field';
                    ApplicationArea = All;
                }
                field("Purchase UOM"; Rec."Purchase UOM")
                {
                    ToolTip = 'Specifies the value of the Purchase UOM field';
                    ApplicationArea = All;
                }
                field("Purchase Lead Time"; Rec."Purchase Lead Time")
                {
                    ToolTip = 'Specifies the value of the Purchase Lead Time field';
                    ApplicationArea = All;
                }
                field("Sales Lead Time"; Rec."Sales Lead Time")
                {
                    ToolTip = 'Specifies the value of the Sales Lead Time field';
                    ApplicationArea = All;
                }
                field("Item GST Group"; Rec."Item GST Group")
                {
                    ToolTip = 'Specifies the value of the Item GST Group field';
                    ApplicationArea = All;
                }
                field("Default Vendor"; Rec."Default Vendor")
                {
                    ToolTip = 'Specifies the value of the Default Vendor field';
                    ApplicationArea = All;
                }
                field("Item Model Group"; Rec."Item Model Group")
                {
                    ToolTip = 'Specifies the value of the Item Model Group field';
                    ApplicationArea = All;
                }
                field("Dimension Group"; Rec."Dimension Group")
                {
                    ToolTip = 'Specifies the value of the Dimension Group field';
                    ApplicationArea = All;
                }
                field("Dimension [1]"; Rec."Dimension [1]")
                {
                    ToolTip = 'Specifies the value of the Dimension [1] field';
                    ApplicationArea = All;
                }
                field("Dimension [2]"; Rec."Dimension [2]")
                {
                    ToolTip = 'Specifies the value of the Dimension [2] field';
                    ApplicationArea = All;
                }
                field("Dimension [3]"; Rec."Dimension [3]")
                {
                    ToolTip = 'Specifies the value of the Dimension [3] field';
                    ApplicationArea = All;
                }
                field("From Unit"; Rec."From Unit")
                {
                    ToolTip = 'Specifies the value of the From Unit field';
                    ApplicationArea = All;
                }
                field("From Unit Description"; Rec."From Unit Description")
                {
                    ToolTip = 'Specifies the value of the From Unit Description field';
                    ApplicationArea = All;
                }
                field(Factor; Rec.Factor)
                {
                    ToolTip = 'Specifies the value of the Factor field';
                    ApplicationArea = All;
                }
                field("To Unit"; Rec."To Unit")
                {
                    ToolTip = 'Specifies the value of the To Unit field';
                    ApplicationArea = All;
                }
                field("To Unit Description"; Rec."To Unit Description")
                {
                    ToolTip = 'Specifies the value of the To Unit Description field';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                }
                //DX    24 Aug 2023
                field(theraGroup; theraGroup)
                {
                    Caption = 'Therapuetic Group Code';
                    ApplicationArea = All;
                }
                field(ImageURL; ImageURL)
                {
                    Caption = 'ImageURL';
                    ApplicationArea = All;
                }
                //DX    24 Aug 2023

            }

        }
    }

    trigger OnOpenPage()
    begin
        LoadData();
    end;

    local procedure LoadData()
    var
        ItemRec: Record item;
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        BinContentRec: Record "Bin Content";
        WarehouseEntryRec: Record "Warehouse Entry";
        Quantity: Decimal;
        IntLeadTime: Integer;
    begin
        ItemRec.reset;
        //DX    24 Aug 2023
        ItemRec.SetLoadFields("No.", Description, "Base Unit of Measure", "Item Status", "Sales Unit of Measure", "Generic Name", Inventory, "Forensic Group",
        "Product Type", "Storage Condition", Manufacturer, Principal, "Unit Price", "Wellaway Item", "Purch. Unit of Measure", "VAT Prod. Posting Group", "Vendor No.");
        //DX    24 Aug 2023
        ItemRec.SetRange("Wellaway Item", true);
        if ItemRec.FindSet() then
            repeat
                Clear(Rec);
                Clear(Quantity);

                Rec."Product Code" := ItemRec."No.";
                Rec."Producte Name" := ItemRec.Description;
                Rec."Base UOM" := ItemRec."Base Unit of Measure";
                Rec."Item Status" := ItemRec."Item Status";
                Rec."Sales UOM" := ItemRec."Sales Unit of Measure";
                Rec."Generic Name" := ItemRec."Generic Name";
                //RL    28 Mar 2022
                if CompanyName = 'PMP' then
                    ItemRec.SetFilter("Location Filter", 'PMP-WH');
                if CompanyName = 'WELLAWAY' then
                    ItemRec.SetFilter("Location Filter", 'Wellaway');
                //RL    28 Mar 2022
                ItemRec.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Transfer Outbound");
                Quantity := ItemRec.Inventory;
                Quantity := Quantity - ItemRec."Qty. on Sales Order" - ItemRec."Qty. on Transfer Outbound";

                if (CompanyName = 'PMP') or (CompanyName = 'WELLAWAY') then begin
                    BinContentRec.Reset();
                    //DX    19 Mar 2025
                    if CompanyName = 'PMP' then
                        BinContentRec.SetFilter("Location Code", 'PMP-WH');
                    if CompanyName = 'WELLAWAY' then
                        BinContentRec.SetFilter("Location Code", 'Wellaway');
                    //DX    19 Mar 2025
                    BinContentRec.SetRange("Item No.", ItemRec."No.");
                    BinContentRec.SetFilter("Bin Code", '%1|%2', 'CLEARANCE', '*WRITE*');
                    if BinContentRec.FindSet() then
                        repeat
                            BinContentRec.CalcFields("Quantity (Base)");
                            Quantity -= BinContentRec."Quantity (Base)";
                        until BinContentRec.Next() = 0;


                    if CompanyName = 'PMP' then begin

                        BinContentRec.Reset();
                        //DX    19 Mar 2025
                        if CompanyName = 'PMP' then
                            BinContentRec.SetFilter("Location Code", 'PMP-WH');
                        if CompanyName = 'WELLAWAY' then
                            BinContentRec.SetFilter("Location Code", 'Wellaway');
                        //DX    19 Mar 2025
                        BinContentRec.SetRange("Item No.", ItemRec."No.");
                        BinContentRec.SetFilter("Bin Code", '<>%1&<>%2', 'CLEARANCE', '*WRITE*');
                        BinContentRec.SetFilter("Zone Code", '<>%1', 'PICK');

                        if BinContentRec.FindSet() then
                            repeat
                                BinContentRec.CalcFields("Quantity (Base)");
                                Quantity -= BinContentRec."Quantity (Base)";
                            until BinContentRec.Next() = 0;
                    end;
                end;

                if Quantity > 0 then
                    Rec."Available Status" := true
                else
                    Rec."Available Status" := false;
                //RL    28 Mar 2022
                if CompanyName = 'PMP' then
                    Rec."Expiry Date" := PMPCU.GetItemEarliestExpiration(ItemRec."No.", 'PMP-WH');
                if CompanyName = 'WELLAWAY' then
                    Rec."Expiry Date" := PMPCU.GetItemEarliestExpiration(ItemRec."No.", 'Wellaway');
                //RL    28 Mar 2022
                Rec."Forensic Group" := ItemRec."Forensic Group";
                Rec."Product Type" := FORMAT(ItemRec."Product Type");
                Rec."Storage Condition" := ItemRec."Storage Condition";
                Rec.Manufacturer := ItemRec.Manufacturer;
                Rec.Principal := ItemRec.Principal;
                Rec."WholeSales Price" := ItemRec."Unit Price";
                if ItemRec."Wellaway Item" = true then              //To be visisted
                    rec."Item Group" := rec."Item Group"::ITEM
                else
                    if ItemRec."Logistics Service" = true then
                        rec."Item Group" := rec."Item Group"::LS;
                Rec."Base Unit Description" := ItemRec.Description;
                Rec.WareHouse := 'Main';
                Rec."Instruction For Use" := '';
                Rec.Precautions := '';
                Rec."Pack Size" := 0;
                Rec."Purchase UOM" := ItemRec."Purch. Unit of Measure";
                IntLeadTime := 0;
                //if StrLen(ItemRec."Lead Time Calculation") <> 0 then
                //    EVALUATE(IntLeadTime, FORMAT(ItemRec."Lead Time Calculation"));
                rec."Purchase Lead Time" := IntLeadTime;
                //EVALUATE(IntLeadTime, FORMAT(ItemRec."Lead Time Calculation"));
                Rec."Sales Lead Time" := IntLeadTime;
                rec."Item GST Group" := ItemRec."VAT Prod. Posting Group";
                Rec."Default Vendor" := ItemRec."Vendor No.";
                if ItemRec."Wellaway Item" = true then              //to  be visited
                    Rec."Item Model Group" := 'WA'
                else
                    if ItemRec."Logistics Service" = true then
                        Rec."Item Model Group" := 'LS'
                    else
                        if ItemRec.Type <> ItemRec.Type::Inventory then
                            Rec."Item Model Group" := 'Non-Item';
                Rec."Dimension Group" := '';
                Rec."Dimension [1]" := '';
                Rec."Dimension [2]" := '';
                Rec."Dimension [3]" := '';
                Rec."From Unit" := '';
                Rec."From Unit Description" := '';
                Rec.Factor := 0;
                Rec."To Unit" := '';
                Rec."To Unit Description" := '';
                Rec.Insert(false);
            until ItemRec.next = 0;

    end;

    trigger OnAfterGetRecord()
    var
        ItemRec: Record item;
        TheraSetup: Record "POM3 Therapeutic Setup";
    begin
        if Rec."Available Status" then
            AvailStatusText := 'Yes'
        else
            AvailStatusText := 'No';
        //DX    24 Aug 2023
        clear(theraGroup);
        Clear(ImageURL);
        if Rec."Product Code" <> '' then begin
            ItemRec.reset;
            ItemRec.SetLoadFields("Therapeutic Code", ImageURL);
            ItemRec.Get(Rec."Product Code");
            TheraSetup.reset;
            TheraSetup.SetRange("Item No.", Rec."Product Code");
            TheraSetup.SetLoadFields("Therapeutic Category 3");
            if TheraSetup.FindFirst() then
                theraGroup := TheraSetup."Therapeutic Category 3";
            ImageURL := ItemRec.ImageURL;
        end;
        //DX    24 Aug 2023

    end;

    var
        PMPCU: Codeunit "PMP-Enhancements";
        AvailStatusText: Text;
        //DX    24 Aug 2023
        // theraGroup: Code[20];  // YF 04 Sep 2023
        theraGroup: Code[100]; // YF 04 Sep 2023
        ImageURL: Text[500];
    //DX    24 Aug 2023
}
