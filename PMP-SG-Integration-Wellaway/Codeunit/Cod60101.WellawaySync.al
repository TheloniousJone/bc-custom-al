codeunit 60101 WellawaySync
{
    procedure SyncSetups()
    var
        myInt: Integer;

        InvPostRec: Record "Inventory Posting Group";
        CustPostRec: Record "Customer Posting Group";
        GenBusPG: Record "Gen. Business Posting Group";
        GenProdPG: Record "Gen. Product Posting Group";
        GSTBusPG: Record "VAT Business Posting Group";
        GSTProdPG: Record "VAT Product Posting Group";
        ItemCat: Record "Item Category";
        UOM: Record "Unit of Measure";
        PrincipalRec: Record Principal;


        WellCustPostRec: Record "Customer Posting Group";
        WellInvPostRec: Record "Inventory Posting Group";
        WellGenBusPG: Record "Gen. Business Posting Group";
        WellGenProdPG: Record "Gen. Product Posting Group";
        WellGSTBusPG: Record "VAT Business Posting Group";
        WellGSTProdPG: Record "VAT Product Posting Group";
        WellItemCat: Record "Item Category";
        WellItemUOM: Record "Item Unit of Measure";
        WellUOM: Record "Unit of Measure";
        WellPrinciple: Record Principal;
    begin
        //DX        01 Aug 2021 Sync Setup Records
        GenBusPG.reset;
        GenBusPG.ChangeCompany(WellCU.GetPMPCompanyName());
        if GenBusPG.FindSet() then
            repeat
                WellGenBusPG.reset;
                WellGenBusPG.ChangeCompany(WellCU.GetWellawayCompany());
                WellGenBusPG.SetRange(Code, GenBusPG.Code);
                if not (WellGenBusPG.FindFirst()) then begin
                    WellGenBusPG.reset;
                    WellGenBusPG.Init();
                    WellGenBusPG.Copy(GenBusPG);
                    WellGenBusPG.Insert(TRUE);
                end;
            until GenBusPG.next = 0;

        GenProdPG.reset;
        GenProdPG.ChangeCompany(WellCU.GetPMPCompanyName());
        if GenProdPG.FindSet() then
            repeat
                WellGenProdPG.reset;
                WellGenProdPG.ChangeCompany(WellCU.GetWellawayCompany());
                WellGenProdPG.SetRange(Code, GenProdPG.Code);
                if not (WellGenProdPG.FindFirst()) then begin
                    WellGenProdPG.reset;
                    WellGenProdPG.Init();
                    WellGenProdPG.Copy(GenProdPG);
                    WellGenProdPG.Insert(TRUE);
                end;
            until GenProdPG.next = 0;
        GSTProdPG.reset;
        GSTProdPG.ChangeCompany(WellCU.GetPMPCompanyName());
        if GSTProdPG.FindSet() then
            repeat
                WellGSTProdPG.reset;
                WellGSTProdPG.ChangeCompany(WellCU.GetWellawayCompany());
                WellGSTProdPG.SetRange(Code, GSTProdPG.Code);
                if not (WellGenProdPG.FindFirst()) then begin
                    WellGSTProdPG.reset;
                    WellGSTProdPG.Init();
                    WellGSTProdPG.Copy(GSTProdPG);
                    WellGSTProdPG.Insert(TRUE);
                end;
            until GSTProdPG.next = 0;

        GSTBusPG.reset;
        GSTBusPG.ChangeCompany(WellCU.GetPMPCompanyName());
        if GSTBusPG.FindSet() then
            repeat
                WellGSTBusPG.reset;
                WellGSTBusPG.ChangeCompany(WellCU.GetWellawayCompany());
                WellGSTBusPG.SetRange(Code, GSTBusPG.Code);
                if not (WellGSTBusPG.FindFirst()) then begin
                    WellGSTBusPG.reset;
                    WellGSTBusPG.Init();
                    WellGSTBusPG.Copy(GSTProdPG);
                    WellGSTBusPG.Insert(TRUE);
                end;
            until GSTBusPG.next = 0;

        CustPostRec.reset;
        CustPostRec.ChangeCompany(WellCU.GetPMPCompanyName());
        if CustPostRec.FindSet() then
            repeat
                WellCustPostRec.reset;
                WellCustPostRec.ChangeCompany(WellCU.GetWellawayCompany());
                WellCustPostRec.SetRange(Code, CustPostRec.Code);
                if not (WellCustPostRec.FindFirst()) then begin
                    WellCustPostRec.reset;
                    WellCustPostRec.Init();
                    WellCustPostRec.Copy(CustPostRec);
                    WellCustPostRec.Insert(TRUE);
                end;
            until CustPostRec.next = 0;
        InvPostRec.reset;
        InvPostRec.ChangeCompany(WellCU.GetPMPCompanyName());
        if InvPostRec.FindSet() then
            repeat
                WellInvPostRec.reset;
                WellInvPostRec.ChangeCompany(WellCU.GetWellawayCompany());
                WellInvPostRec.SetRange(Code, InvPostRec.Code);
                if not (WellInvPostRec.FindFirst()) then begin
                    WellInvPostRec.reset;
                    WellInvPostRec.Init();
                    WellInvPostRec.Copy(InvPostRec);
                    WellInvPostRec.Insert(TRUE);
                end;
            until InvPostRec.next = 0;

        UOM.reset;
        UOM.ChangeCompany(WellCU.GetPMPCompanyName());
        if UOM.FindSet() then
            repeat
                WellUOM.reset;
                WellUOM.ChangeCompany(WellCU.GetWellawayCompany());
                WellUOM.SetRange(Code, UOM.Code);
                if not (WellUOM.FindFirst()) then begin
                    WellUOM.reset;
                    WellUOM.Init();
                    WellUOM.Copy(UOM);
                    WellUOM.Insert(TRUE);
                end;
            until UOM.next = 0;
        UOM.reset;
        UOM.ChangeCompany(WellCU.GetPMPCompanyName());
        if UOM.FindSet() then
            repeat
                WellUOM.reset;
                WellUOM.ChangeCompany(WellCU.GetWellawayCompany());
                WellUOM.SetRange(Code, UOM.Code);
                if not (WellUOM.FindFirst()) then begin
                    WellUOM.reset;
                    WellUOM.Init();
                    WellUOM.Copy(UOM);
                    WellUOM.Insert(TRUE);
                end;
            until UOM.next = 0;

        ItemCat.reset;
        ItemCat.ChangeCompany(WellCU.GetPMPCompanyName());
        if ItemCat.FindSet() then
            repeat
                WellItemCat.reset;
                WellItemCat.ChangeCompany(WellCU.GetWellawayCompany());
                WellItemCat.SetRange(Code, ItemCat.Code);
                if not (WellItemCat.FindFirst()) then begin
                    WellItemCat.reset;
                    WellItemCat.Init();
                    WellItemCat.Copy(ItemCat);
                    WellItemCat.Insert(TRUE);
                end;
            until ItemCat.next = 0;
        //DX        01 Aug 2021                

        PrincipalRec.reset;
        PrincipalRec.ChangeCompany(WellCU.GetPMPCompanyName());
        if PrincipalRec.FindSet() then
            repeat
                WellPrinciple.reset;
                WellPrinciple.ChangeCompany(WellCU.GetWellawayCompany());
                WellPrinciple.SetRange(Code, PrincipalRec.Code);
                if not (WellPrinciple.FindFirst()) then begin
                    WellPrinciple.reset;
                    WellPrinciple.Init();
                    WellPrinciple.Copy(PrincipalRec);
                    WellPrinciple.Insert(TRUE);
                end;
            until PrincipalRec.next = 0;
    end;

    procedure SyncPMPItemRec(ItemNo: Code[20])
    var
        myInt: Integer;
        ItemRec: Record item;
        WellItemRec: Record item;
        ItemUOM: Record "Item Unit of Measure";
        WellItemUom: Record "Item Unit of Measure";
    begin
        ItemRec.reset;
        ItemRec.ChangeCompany(WellCU.GetPMPCompanyName());
        ItemRec.SetRange("Wellaway Item", true);
        if ItemNo <> '' then
            ItemRec.SetRange("No.", ItemNo);
        if ItemRec.FindSet() then
            repeat
                WellItemRec.reset;
                WellItemRec.ChangeCompany(WellCU.GetWellawayCompany());
                WellItemRec.SetRange("No.", ItemRec."No.");
                if not (WellItemRec.FindFirst()) then begin
                    WellItemRec.reset;
                    WellItemRec.Init();
                    WellItemRec.Copy(ItemRec);
                    WellItemRec.Insert(TRUE);

                    ItemUOM.reset;
                    ItemUOM.ChangeCompany(WellCU.GetPMPCompanyName());
                    ItemUOM.SetRange("Item No.", ItemRec."No.");
                    if ItemUOM.FindSet() then
                        repeat
                            WellItemUOM.reset;
                            WellItemUom.ChangeCompany(WellCU.GetWellawayCompany());
                            WellItemUOM.Init();
                            WellItemUOM.Copy(ItemUOM);
                            WellItemUOM.Insert(FALSE);
                        until ItemUOM.next = 0;

                end else begin

                    WellItemRec."Prescription 1" := ItemRec."Prescription 1";
                    WellItemRec."Prescription 2" := ItemRec."Prescription 2";
                    WellItemRec.Description := ItemRec.Description;
                    WellItemRec."Packaging Description" := ItemRec."Packaging Description";
                    WellItemRec."Packing Instructions" := ItemRec."Packing Instructions";
                    WellItemRec."Customer Information" := ItemRec."Customer Information";
                    WellItemRec."Commission Group" := ItemRec."Commission Group";
                    WellItemRec."Generic Name" := ItemRec."Generic Name";
                    WellItemRec."Item Status" := ItemRec."Item Status";
                    WellItemRec.Principal := ItemRec.Principal;
                    WellItemRec."Principal Exchange Policy" := ItemRec."Principal Exchange Policy";
                    WellItemRec."Status Remarks" := ItemRec."Status Remarks";
                    WellItemRec."Wellaway Item" := ItemRec."Wellaway Item"; //RL 04 Jul 2022
                    //WellItemRec.Copy(ItemRec);
                    WellItemRec.Modify(false);
                    //Commit();
                end;
            until ItemRec.next = 0;
    end;

    procedure SyncWellItemUOMRec(ItemNo: Code[20]; ItemUOMCode: Code[20])
    var
        myInt: Integer;
        ItemRec: Record item;
        WellItemRec: Record item;
        ItemUOM: Record "Item Unit of Measure";
        WellItemUom: Record "Item Unit of Measure";
    begin
        WellItemRec.reset;
        WellItemRec.ChangeCompany(WellCU.GetWellawayCompany());
        WellItemRec.SetRange("Wellaway Item", true);
        if ItemNo <> '' then
            WellItemRec.SetRange("No.", ItemNo);
        if WellItemRec.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.ChangeCompany(WellCU.GetPMPCompanyName());
                ItemRec.SetLoadFields("No.", "Wellaway Item"); //DX        17 May 2023
                ItemRec.SetRange("No.", WellItemRec."No.");
                ItemRec.SetRange("Wellaway Item", true);
                if ItemRec.FindFirst() then begin
                    WellItemUOM.reset;
                    WellItemUOM.ChangeCompany(WellCU.GetWellawayCompany());
                    if ItemUOMCode <> '' then
                        WellItemUom.SetRange(Code, ItemUOMCode);
                    WellItemUOM.SetRange("Item No.", ItemRec."No.");
                    if WellItemUOM.FindSet() then
                        repeat
                            ItemUOM.reset;
                            ItemUom.ChangeCompany(WellCU.GetPMPCompanyName());
                            ItemUOM.SetRange("Item No.", WellItemUom."Item No.");
                            ItemUOM.SetRange(Code, WellItemUom.Code);
                            if not (ItemUOM.FindFirst()) then begin
                                ItemUOM.Init();
                                ItemUOM.Copy(WellItemUOM);
                                ItemUOM.Insert(TRUE);
                            end else begin
                                ItemUOM."Qty. per Unit of Measure" := WellItemUom."Qty. per Unit of Measure";
                                ItemUOM.Modify(TRUE);
                            end;
                        until WellItemUOM.next = 0;
                end;
            until WellItemRec.next = 0;
        if GuiAllowed then
            Message('Sync completed');
    end;

    procedure SyncCustRec(CustNo: Code[20])
    var
        myInt: Integer;
        CUstRec: Record customer;
        WellCustRec: Record customer;
    begin
        CustRec.reset;
        CustRec.ChangeCompany(WellCU.GetPMPCompanyName());
        CustRec.SetRange("Wellaway Customer", true);
        if CustNo <> '' then
            CUstRec.SetRange("No.", CustNo);
        if CustRec.FindSet() then
            repeat
                WellCustRec.reset;
                WellCustRec.ChangeCompany(WellCU.GetWellawayCompany());
                WellCustRec.SetRange("No.", CustRec."No.");
                if not (WellCustRec.FindFirst()) then begin
                    WellCustRec.reset;
                    WellCustRec.Init();
                    // WellCustRec.Copy(CustRec);
                    WellCustRec.TransferFields(CUstRec);
                    WellCustRec.Insert(FALSE);

                end else begin
                    //WellCustRec := CUstRec;
                    WellCustRec.Name := CustRec.Name;
                    WellCustRec.Address := CUstRec.Address;
                    WellCustRec."Address 2" := CUstRec."Address 2";
                    WellCustRec."Phone No." := CUstRec."Phone No.";
                    WellCustRec."Mobile Phone No." := CUstRec."Mobile Phone No.";
                    WellCustRec."Post Code" := CUstRec."Post Code";
                    WellCustRec."Delivery Instructions" := CUstRec."Delivery Instructions";
                    WellCustRec."Picking Instructions" := CUstRec."Picking Instructions";
                    WellCustRec."Delivery Zone" := CUstRec."Delivery Zone";
                    WellCustRec."Delivery Charge" := CUstRec."Delivery Charge";
                    WellCustRec."Customer Instructions" := CUstRec."Customer Instructions";
                    WellCustRec."Branch/Subsidiary" := CUstRec."Branch/Subsidiary";
                    WellCustRec."MOH License No." := CUstRec."MOH License No.";
                    WellCustRec."Corporate  Sales Rep (HYP)" := CUstRec."Corporate  Sales Rep (HYP)";
                    WellCustRec."Corporate  Sales Rep (4)" := CUstRec."Corporate  Sales Rep (4)";
                    WellCustRec."Corporate  Sales Rep (5)" := CUstRec."Corporate  Sales Rep (5)";
                    WellCustRec."Corporate  Sales Rep (HB)" := CUstRec."Corporate  Sales Rep (HB)";
                    WellCustRec."Corporate  Sales Rep (WS)" := CUstRec."Corporate  Sales Rep (WS)";
                    WellCustRec."Commercial Permission Group" := CUstRec."Commercial Permission Group";
                    WellCustRec."Forensic Permmission Group" := CUstRec."Forensic Permmission Group";
                    WellCustRec.Comment := CUstRec.Comment;
                    WellCustRec.Modify(false);
                end;
            until CustRec.next = 0;
    end;


    procedure SyncSalesTradeAgreement()
    var
        myInt: Integer;
        CUstRec: Record customer;
        WellCustRec: Record customer;

        PharmaSalePrice: Record "Pharma Sales Price";
        WellPharmaSalePrice: Record "Pharma Sales Price";
        PMPItemRec: Record item;
    begin

        PharmaSalePrice.reset;
        PharmaSalePrice.ChangeCompany(WellCU.GetPMPCompanyName());
        PharmaSalePrice.SetRange("Sales Type", PharmaSalePrice."Sales Type"::"Customer Price Group");
        PharmaSalePrice.SetFilter("Sales Code", 'C2');
        if PharmaSalePrice.FindSet() then
            repeat
                PMPItemRec.reset;
                PMPItemRec.ChangeCompany(wellcu.GetPMPCompanyName());
                PMPItemRec.SetLoadFields("No.", "Wellaway Item"); //DX        17 May 2023
                PMPItemRec.SetRange("No.", PharmaSalePrice."Item No.");
                PMPItemRec.SetRange("Wellaway Item", true);
                if PMPItemRec.FindFirst() then begin
                    WellPharmaSalePrice.reset;
                    WellPharmaSalePrice.ChangeCompany(WellCU.GetWellawayCompany());
                    WellPharmaSalePrice.SetRange("Item No.", PharmaSalePrice."Item No.");
                    WellPharmaSalePrice.SetRange("Starting Date", PharmaSalePrice."Starting Date");
                    WellPharmaSalePrice.SetRange("Sales Type", PharmaSalePrice."Sales Type");
                    WellPharmaSalePrice.SetRange("Sales Code", PharmaSalePrice."Sales Code");
                    WellPharmaSalePrice.SetRange("Unit Of Measure Code", PharmaSalePrice."Unit Of Measure Code");
                    WellPharmaSalePrice.SetRange("Minimum Quantity", PharmaSalePrice."Minimum Quantity");
                    if not (WellPharmaSalePrice.FindFirst()) then begin
                        WellPharmaSalePrice.Init();
                        WellPharmaSalePrice.TransferFields(PharmaSalePrice);
                        WellPharmaSalePrice.Insert(true);

                    end else begin
                        //WellPharmaSalePrice.Init();
                        //WellPharmaSalePrice.TransferFields(PharmaSalePrice);
                        WellPharmaSalePrice."Currency Code" := PharmaSalePrice."Currency Code";
                        WellPharmaSalePrice."Ending Date" := PharmaSalePrice."Ending Date";
                        WellPharmaSalePrice."Starting Date" := PharmaSalePrice."Starting Date";
                        WellPharmaSalePrice."Unit Price" := PharmaSalePrice."Unit Price";
                        WellPharmaSalePrice."Unit Of Measure Code" := PharmaSalePrice."Unit Of Measure Code";
                        WellPharmaSalePrice."Sales Code" := PharmaSalePrice."Sales Code";
                        WellPharmaSalePrice."Sales Type" := PharmaSalePrice."Sales Type";
                        WellPharmaSalePrice."Item No." := PharmaSalePrice."Item No.";
                        WellPharmaSalePrice."Minimum Quantity" := PharmaSalePrice."Minimum Quantity";
                        WellPharmaSalePrice."TA Type" := PharmaSalePrice."TA Type";
                        WellPharmaSalePrice.Modify(true);
                    end;

                end;
            until PharmaSalePrice.next = 0;

        PharmaSalePrice.reset;
        PharmaSalePrice.ChangeCompany(WellCU.GetPMPCompanyName());
        PharmaSalePrice.SetRange("Sales Type", PharmaSalePrice."Sales Type"::"Customer");
        if PharmaSalePrice.FindSet() then
            repeat
                PMPItemRec.reset;
                PMPItemRec.ChangeCompany(WellCU.GetPMPCompanyName());
                PMPItemRec.SetLoadFields("No.", "Wellaway Item"); //DX        17 May 2023
                PMPItemRec.SetRange("No.", PharmaSalePrice."Item No.");
                PMPItemRec.SetRange("Wellaway Item", true);
                if PMPItemRec.FindFirst() then begin
                    WellPharmaSalePrice.reset;
                    WellPharmaSalePrice.ChangeCompany(wellcu.GetWellawayCompany());
                    WellPharmaSalePrice.SetRange("Item No.", PharmaSalePrice."Item No.");
                    WellPharmaSalePrice.SetRange("Starting Date", PharmaSalePrice."Starting Date");
                    WellPharmaSalePrice.SetRange("Sales Type", PharmaSalePrice."Sales Type");
                    WellPharmaSalePrice.SetRange("Sales Code", PharmaSalePrice."Sales Code");
                    WellPharmaSalePrice.SetRange("Unit Of Measure Code", PharmaSalePrice."Unit Of Measure Code");
                    WellPharmaSalePrice.SetRange("Minimum Quantity", PharmaSalePrice."Minimum Quantity");
                    if not (WellPharmaSalePrice.FindFirst()) then begin
                        WellPharmaSalePrice.Init();
                        WellPharmaSalePrice.TransferFields(PharmaSalePrice);
                        WellPharmaSalePrice.Insert(true);
                    end else begin
                        //WellPharmaSalePrice.Init();
                        //WellPharmaSalePrice.TransferFields(PharmaSalePrice);
                        WellPharmaSalePrice."Currency Code" := PharmaSalePrice."Currency Code";
                        WellPharmaSalePrice."Ending Date" := PharmaSalePrice."Ending Date";
                        WellPharmaSalePrice."Starting Date" := PharmaSalePrice."Starting Date";
                        WellPharmaSalePrice."Unit Price" := PharmaSalePrice."Unit Price";
                        WellPharmaSalePrice."Unit Of Measure Code" := PharmaSalePrice."Unit Of Measure Code";
                        WellPharmaSalePrice."Sales Code" := PharmaSalePrice."Sales Code";
                        WellPharmaSalePrice."Sales Type" := PharmaSalePrice."Sales Type";
                        WellPharmaSalePrice."Item No." := PharmaSalePrice."Item No.";
                        WellPharmaSalePrice."Minimum Quantity" := PharmaSalePrice."Minimum Quantity";
                        WellPharmaSalePrice."TA Type" := PharmaSalePrice."TA Type";
                        WellPharmaSalePrice.Modify(true);
                    end;

                end;
            until PharmaSalePrice.next = 0;
    end;


    var
        WellCU: Codeunit "Wellaway CU";
}
