codeunit 80130 I9G_ThirdPartyLogisticCU
{
    Permissions = tabledata "Value Entry" = rimd, tabledata "Job Queue Entry" = rimd, tabledata "Sales Invoice Header" = RIMD, tabledata "Sales Shipment Header" = RIMD, tabledata "Assignment Ledger Entry" = RIMD, tabledata "Item Ledger Entry" = RIMD, tabledata "Reservation Entry" = RIMD, tabledata "Tracking Specification" = RIMD, tabledata "Sales Header" = RIMD, tabledata "Sales Line" = RIMD, tabledata "Warehouse Entry" = RIMD, tabledata "Dimension Set Entry" = RIMD, tabledata "Dimension Set Tree Node" = RIMD;

    /*Functions*/
    procedure GetUserNameFromSecurityID(UserSecurityID: Guid): Code[50]
    var
        UserRec: Record User;
    begin
        UserRec.Reset();
        UserRec.SetRange("User Security ID", UserSecurityID);
        if UserRec.FindFirst() then
            exit(UserRec."User Name");
    end;

    procedure CheckCompanyName(): Boolean
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany <> '') and (CompanyName <> I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany) then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    procedure GetSelectionFilter(var TempRecRef: RecordRef; SelectionFieldID: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    begin
        if TempRecRef.IsTemporary then begin
            RecRef := TempRecRef.Duplicate();
            RecRef.Reset();
        end else
            RecRef.Open(TempRecRef.Number, false, TempRecRef.CurrentCompany);

        TempRecRef.Ascending(true);
        if TempRecRef.FindSet() then begin
            repeat
                RecRef.SetPosition(TempRecRef.GetPosition());
                RecRef.Find();
                FieldRef := RecRef.Field(SelectionFieldID);
                if SelectionFilter <> '' then begin
                    SelectionFilter := SelectionFilter + '|' + Format(FieldRef.Value);
                end else begin
                    SelectionFilter := Format(FieldRef.Value);
                end;
            until TempRecRef.Next() = 0;
        end;
        exit(SelectionFilter);
    end;

    /*Functions - Purchase Order*/
    procedure CreatePurchaseDocument(par_PurchaseHeaderRec: Record "Purchase Header")
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        FromCompanyName: Text[30];
    begin
        I9G_ThirdPartyLogisticSetupRec.Get();
        Clear(FromCompanyName);
        FromCompanyName := CompanyName();
        if I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true then begin
            CheckPurchaseLinesBeforeSend(par_PurchaseHeaderRec);
            if IsPurchaseDocumentExsits(par_PurchaseHeaderRec, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany) then begin
                UpdatePurchaseDocument(par_PurchaseHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end else begin
                CreateNewPurchaseDocument(par_PurchaseHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end;
        end else begin
            Message('Please enable the internal third party logistic function before proceed.');
        end;
    end;

    procedure IsPurchaseDocumentExsits(par_PurchaseHeaderRec: Record "Purchase Header"; par_WarehouseCompanyName: Text[250]): Boolean
    var
        WarehousePurchaseHeaderRec: Record "Purchase Header";
    begin
        WarehousePurchaseHeaderRec.Reset();
        if WarehousePurchaseHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehousePurchaseHeaderRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
            WarehousePurchaseHeaderRec.SetRange("No.", par_PurchaseHeaderRec."No.");
            if WarehousePurchaseHeaderRec.FindFirst() then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    procedure CreateNewPurchaseDocument(par_PurchaseHeaderRec: Record "Purchase Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        PurchaseLineRec: Record "Purchase Line";
        WarehousePurchaseHeaderRec: Record "Purchase Header";
        WarehousePurchaseLineRec: Record "Purchase Line";
        PurchasesPayablesSetupRec: Record "Purchases & Payables Setup";
        VendorRec: Record Vendor;
        ItemRec: Record Item;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
    begin
        PurchaseLineRec.Reset();
        PurchaseLineRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
        PurchaseLineRec.SetRange("Document No.", par_PurchaseHeaderRec."No.");
        PurchaseLineRec.SetFilter(Type, '<>%1', PurchaseLineRec.Type::"Charge (Item)");
        if PurchaseLineRec.FindSet() then begin
            WarehousePurchaseHeaderRec.Reset();
            if WarehousePurchaseHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
                I9G_ThirdPartyLogisticSetupRec.Reset();
                I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName);
                I9G_ThirdPartyLogisticSetupRec.Get();
                if I9G_ThirdPartyLogisticSetupRec.I9G_VendorCode <> '' then begin
                    if PurchasesPayablesSetupRec.ChangeCompany(par_WarehouseCompanyName) then begin
                        PurchasesPayablesSetupRec.Get();
                        WarehousePurchaseHeaderRec.Init();
                        WarehousePurchaseHeaderRec.TransferFields(par_PurchaseHeaderRec);
                        WarehousePurchaseHeaderRec."Document Type" := WarehousePurchaseHeaderRec."Document Type"::Order;
                        WarehousePurchaseHeaderRec."No." := par_PurchaseHeaderRec."No.";
                        WarehousePurchaseHeaderRec."Buy-from Vendor No." := I9G_ThirdPartyLogisticSetupRec.I9G_VendorCode;
                        VendorRec.Reset();
                        if VendorRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            VendorRec.SetRange("No.", I9G_ThirdPartyLogisticSetupRec.I9G_VendorCode);
                            if VendorRec.FindFirst() then;
                        end;
                        WarehousePurchaseHeaderRec."Buy-from Vendor Name" := VendorRec.Name;
                        WarehousePurchaseHeaderRec."Buy-from Vendor Name 2" := VendorRec."Name 2";
                        WarehousePurchaseHeaderRec."Buy-from Address" := VendorRec.Address;
                        WarehousePurchaseHeaderRec."Buy-from Address 2" := VendorRec."Address 2";
                        WarehousePurchaseHeaderRec."Buy-from City" := VendorRec.City;
                        WarehousePurchaseHeaderRec."Buy-from Country/Region Code" := VendorRec."Country/Region Code";
                        WarehousePurchaseHeaderRec."Buy-from Post Code" := VendorRec."Post Code";
                        WarehousePurchaseHeaderRec."Buy-from Contact" := VendorRec.Contact;
                        WarehousePurchaseHeaderRec."Buy-from Contact No." := VendorRec."Primary Contact No.";
                        WarehousePurchaseHeaderRec."Pay-to Vendor No." := VendorRec."No.";
                        WarehousePurchaseHeaderRec."Pay-to Name" := VendorRec.Name;
                        WarehousePurchaseHeaderRec."Pay-to Name 2" := VendorRec."Name 2";
                        WarehousePurchaseHeaderRec."Pay-to Address" := VendorRec.Address;
                        WarehousePurchaseHeaderRec."Pay-to Address 2" := VendorRec."Address 2";
                        WarehousePurchaseHeaderRec."Pay-to City" := VendorRec.City;
                        WarehousePurchaseHeaderRec."Pay-to Country/Region Code" := VendorRec."Country/Region Code";
                        WarehousePurchaseHeaderRec."Pay-to Post Code" := VendorRec."Post Code";
                        WarehousePurchaseHeaderRec."Pay-to Contact" := VendorRec.Contact;
                        WarehousePurchaseHeaderRec."Pay-to Contact No." := VendorRec."Primary Contact No.";
                        //DX        05 Dec 2025
                        if (par_PurchaseHeaderRec."Document Type" = par_PurchaseHeaderRec."Document Type"::"Credit Memo") OR
                        (par_PurchaseHeaderRec."Document Type" = par_PurchaseHeaderRec."Document Type"::"Return Order") then begin
                            WarehousePurchaseHeaderRec."Posting No. Series" := PurchasesPayablesSetupRec."Posted Credit Memo Nos.";
                            WarehousePurchaseHeaderRec."Receiving No. Series" := PurchasesPayablesSetupRec."Posted Return Shpt. Nos.";
                            WarehousePurchaseHeaderRec."Posting No." := '';
                            WarehousePurchaseHeaderRec."Receiving No." := '';
                        end else begin
                            WarehousePurchaseHeaderRec."Receiving No. Series" := PurchasesPayablesSetupRec."Posted Receipt Nos.";
                            WarehousePurchaseHeaderRec."Posting No. Series" := PurchasesPayablesSetupRec."Posted Invoice Nos.";
                            WarehousePurchaseHeaderRec."Receiving No." := '';
                            WarehousePurchaseHeaderRec."Posting No." := '';
                        end;
                        //DX        05 Dec 2025

                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation <> '') then begin
                            WarehousePurchaseHeaderRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation;
                        end;
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchasePaymentTermsCode <> '') then begin
                            WarehousePurchaseHeaderRec."Payment Terms Code" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchasePaymentTermsCode;
                            WarehousePurchaseHeaderRec."Prepmt. Payment Terms Code" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchasePaymentTermsCode;
                        end;
                        WarehousePurchaseHeaderRec.Insert();
                    end;
                end else begin
                    Error('Please indicate a Buy-From Vendor No. in the warehouse company.');
                end;
            end;
            repeat
                WarehousePurchaseLineRec.Reset();
                if WarehousePurchaseLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                    if PurchaseLineRec.Type = PurchaseLineRec.Type::Item then begin
                        ItemRec.Reset();
                        if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            ItemRec.SetRange("No.", PurchaseLineRec."No.");
                            if ItemRec.FindFirst() then begin
                                ItemUnitOfMeasureRec.Reset();
                                if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                    ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                    ItemUnitOfMeasureRec.SetRange(Code, PurchaseLineRec."Unit of Measure Code");
                                    if not ItemUnitOfMeasureRec.FindFirst() then
                                        Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', PurchaseLineRec."No.", PurchaseLineRec."Unit of Measure Code"));
                                end;
                            end else begin
                                Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), PurchaseLineRec."No.");
                            end;
                        end;
                    end;
                    WarehousePurchaseLineRec.Init();
                    WarehousePurchaseLineRec.TransferFields(PurchaseLineRec);
                    WarehousePurchaseLineRec."Document Type" := WarehousePurchaseHeaderRec."Document Type";
                    WarehousePurchaseLineRec."Document No." := WarehousePurchaseHeaderRec."No.";
                    WarehousePurchaseLineRec."Buy-from Vendor No." := WarehousePurchaseHeaderRec."Buy-from Vendor No.";
                    WarehousePurchaseLineRec."Buy-from Vendor Name" := WarehousePurchaseHeaderRec."Buy-from Vendor Name";
                    WarehousePurchaseLineRec."Purchase Price" := 0;
                    if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation <> '') then begin
                            WarehousePurchaseLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation;
                            WarehousePurchaseLineRec."Direct Unit Cost" := PurchaseLineRec."Direct Unit Cost";
                            WarehousePurchaseLineRec."Qty. to Receive" := PurchaseLineRec."Qty. to Receive";
                        end;
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp <> '') then begin
                            WarehousePurchaseLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp;
                        end;
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenBusPostingGrp <> '') then begin
                            WarehousePurchaseLineRec."Gen. Bus. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenBusPostingGrp;
                        end;
                    end;
                    WarehousePurchaseLineRec.Insert();
                end;
            until PurchaseLineRec.Next() = 0;

            par_PurchaseHeaderRec.I9G_POCreated := true;
            par_PurchaseHeaderRec.I9G_PONo := WarehousePurchaseHeaderRec."No.";
            par_PurchaseHeaderRec.I9G_POCreatedBy := UserId();
            par_PurchaseHeaderRec.I9G_POCreatedDateTime := CurrentDateTime();
            par_PurchaseHeaderRec.I9G_NeedToCreatePO := false;
            par_PurchaseHeaderRec.Modify();

            WarehousePurchaseHeaderRec.I9G_POCreated := true;
            WarehousePurchaseHeaderRec.I9G_PONo := par_PurchaseHeaderRec."No.";
            WarehousePurchaseHeaderRec.I9G_POCreatedBy := UserId();
            WarehousePurchaseHeaderRec.I9G_POCreatedDateTime := CurrentDateTime();
            WarehousePurchaseHeaderRec.I9G_FromCompanyName := par_FromCompanyName;
            WarehousePurchaseHeaderRec.I9G_CustVendCode := par_PurchaseHeaderRec."Buy-from Vendor No.";
            WarehousePurchaseHeaderRec.I9G_CustVendName := par_PurchaseHeaderRec."Buy-from Vendor Name";
            WarehousePurchaseHeaderRec.I9G_3PLRemarks := par_PurchaseHeaderRec.I9G_3PLRemarks;
            WarehousePurchaseHeaderRec.I9G_NeedToCreatePO := false;
            WarehousePurchaseHeaderRec.Modify();

            CreateJobQueueToCreatePurchWhseReceipt(par_WarehouseCompanyName, WarehousePurchaseHeaderRec.RecordId);

            Message('Purchase Order Created.');
        end else begin
            Error('There is nothing to send and create for purchase order.');
        end;
    end;

    procedure UpdatePurchaseDocument(par_PurchaseHeaderRec: Record "Purchase Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        PurchaseLineRec: Record "Purchase Line";
        WarehousePurchaseHeaderRec: Record "Purchase Header";
        WarehousePurchaseLineRec: Record "Purchase Line";
        ItemRec: Record Item;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
    begin
        WarehousePurchaseHeaderRec.Reset();
        if WarehousePurchaseHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehousePurchaseHeaderRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
            WarehousePurchaseHeaderRec.SetRange("No.", par_PurchaseHeaderRec."No.");
            if WarehousePurchaseHeaderRec.FindFirst() then begin
                if WarehousePurchaseHeaderRec.Status <> WarehousePurchaseHeaderRec.Status::Open then
                    Error('The purchase document is being processed in the warehouse company, no changes will be made.');
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
                PurchaseLineRec.SetRange("Document No.", par_PurchaseHeaderRec."No.");
                PurchaseLineRec.SetFilter(Type, '<>%1', PurchaseLineRec.Type::"Charge (Item)");
                if PurchaseLineRec.FindSet() then begin
                    repeat
                        if PurchaseLineRec.Type = PurchaseLineRec.Type::Item then begin
                            ItemRec.Reset();
                            if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                ItemRec.SetRange("No.", PurchaseLineRec."No.");
                                if ItemRec.FindFirst() then begin
                                    ItemUnitOfMeasureRec.Reset();
                                    if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                        ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                        ItemUnitOfMeasureRec.SetRange(Code, PurchaseLineRec."Unit of Measure Code");
                                        if not ItemUnitOfMeasureRec.FindFirst() then
                                            Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', PurchaseLineRec."No.", PurchaseLineRec."Unit of Measure Code"));
                                    end;
                                end else begin
                                    Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), PurchaseLineRec."No.");
                                end;
                            end;
                        end;

                        WarehousePurchaseLineRec.Reset();
                        if WarehousePurchaseLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            WarehousePurchaseLineRec.SetRange("Document Type", PurchaseLineRec."Document Type");
                            WarehousePurchaseLineRec.SetRange("Document No.", PurchaseLineRec."Document No.");
                            WarehousePurchaseLineRec.SetRange("Line No.", PurchaseLineRec."Line No.");
                            if WarehousePurchaseLineRec.FindSet() then
                                WarehousePurchaseLineRec.DeleteAll(true);
                            WarehousePurchaseLineRec.Init();
                            WarehousePurchaseLineRec.TransferFields(PurchaseLineRec);
                            WarehousePurchaseLineRec."Document Type" := WarehousePurchaseHeaderRec."Document Type";
                            WarehousePurchaseLineRec."Document No." := WarehousePurchaseHeaderRec."No.";
                            WarehousePurchaseLineRec."Buy-from Vendor Name" := WarehousePurchaseHeaderRec."Buy-from Vendor Name";
                            WarehousePurchaseLineRec."Buy-from Vendor No." := WarehousePurchaseHeaderRec."Buy-from Vendor No.";
                            WarehousePurchaseLineRec."Purchase Price" := 0;
                            if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                                I9G_ThirdPartyLogisticSetupRec.Get();
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation <> '') then begin
                                    WarehousePurchaseLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderLocation;
                                    WarehousePurchaseLineRec."Direct Unit Cost" := PurchaseLineRec."Direct Unit Cost";
                                    WarehousePurchaseLineRec."Qty. to Receive" := PurchaseLineRec."Qty. to Receive";
                                end;
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp <> '') then begin
                                    WarehousePurchaseLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp;
                                end;
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenBusPostingGrp <> '') then begin
                                    WarehousePurchaseLineRec."Gen. Bus. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenBusPostingGrp;
                                end;
                            end;
                            WarehousePurchaseLineRec.Insert();
                        end;
                    until PurchaseLineRec.Next() = 0;
                end;
            end else begin
                Error('There is nothing to send and update for purchase order.');
            end;

            par_PurchaseHeaderRec.I9G_POLastModifiedDateTime := CurrentDateTime();

            WarehousePurchaseHeaderRec.I9G_3PLRemarks := par_PurchaseHeaderRec.I9G_3PLRemarks;
            WarehousePurchaseHeaderRec.I9G_POLastModifiedDateTime := CurrentDateTime();
            WarehousePurchaseHeaderRec.Modify();

            CreateJobQueueToCreatePurchWhseReceipt(par_WarehouseCompanyName, WarehousePurchaseHeaderRec.RecordId);

            Message('Purchase Order Updated.');
        end;
    end;

    procedure UndoReceipt(par_PurchRcptLineRec: Record "Purch. Rcpt. Line")
    var
        PurchRcptHeaderRec: Record "Purch. Rcpt. Header";
        FromCompanyPurchRcptHeaderRec: Record "Purch. Rcpt. Header";
        FromCompanyPurchRcptLineRec: Record "Purch. Rcpt. Line";
    begin
        PurchRcptHeaderRec.Reset();
        PurchRcptHeaderRec.SetRange("No.", par_PurchRcptLineRec."Document No.");
        PurchRcptHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
        if PurchRcptHeaderRec.FindFirst() then begin
            FromCompanyPurchRcptHeaderRec.Reset();
            if FromCompanyPurchRcptHeaderRec.ChangeCompany(PurchRcptHeaderRec.I9G_FromCompanyName) then begin
                FromCompanyPurchRcptHeaderRec.SetRange(I9G_ReceiptNo, PurchRcptHeaderRec."No.");
                if FromCompanyPurchRcptHeaderRec.FindFirst() then begin
                    FromCompanyPurchRcptLineRec.Reset();
                    if FromCompanyPurchRcptLineRec.ChangeCompany(PurchRcptHeaderRec.I9G_FromCompanyName) then begin
                        FromCompanyPurchRcptLineRec.SetRange("Document No.", FromCompanyPurchRcptHeaderRec."No.");
                        FromCompanyPurchRcptLineRec.SetRange("Line No.", par_PurchRcptLineRec."Line No.");
                        FromCompanyPurchRcptLineRec.SetRange("No.", par_PurchRcptLineRec."No.");
                        if FromCompanyPurchRcptLineRec.FindFirst() then begin
                            CreateJobQueueForUndoPurchaseReceipt(PurchRcptHeaderRec.I9G_FromCompanyName, FromCompanyPurchRcptLineRec.RecordId);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure CheckPurchaseLinesBeforeSend(par_PurchaseHeaderRec: Record "Purchase Header")
    var
        PurchaseLineRec: Record "Purchase Line";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        ShortcutDimensionCode: array[8] of Code[20];
    begin
        PurchaseLineRec.Reset();
        PurchaseLineRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
        PurchaseLineRec.SetRange("Document No.", par_PurchaseHeaderRec."No.");
        PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::Item);
        if PurchaseLineRec.FindSet() then begin
            repeat
                if PurchaseLineRec."Location Code" = '' then
                    Error('%1 must have a value for %2 [%3]', PurchaseLineRec.FieldCaption("Location Code"), PurchaseLineRec.Type, PurchaseLineRec."No.");
                if PurchaseLineRec.Quantity = 0 then
                    Error('%1 must have a value for %2 [%3]', PurchaseLineRec.FieldCaption(Quantity), PurchaseLineRec.Type, PurchaseLineRec."No.");
            until PurchaseLineRec.Next() = 0;
        end;
    end;

    procedure CheckPurchaseLineBeforeCreateWarehouseReceipt(par_PurchaseHeaderRec: Record "Purchase Header")
    var
        PurchaseLineRec: Record "Purchase Line";
        I9G_ThirdPartyLogisticSetup: Record I9G_ThirdPartyLogisticSetup;
    begin
        if I9G_ThirdPartyLogisticSetup.Get() then begin
            if (I9G_ThirdPartyLogisticSetup.I9G_EnableThirdPartyLogistic = true) and (CheckCompanyName() = false) then begin
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetRange("Document Type", par_PurchaseHeaderRec."Document Type");
                PurchaseLineRec.SetRange("Document No.", par_PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::Item);
                PurchaseLineRec.SetFilter("Purchase Price", '<>%1', 0);
                if PurchaseLineRec.FindFirst() then begin
                    Error('Purchase Price must be empty for %1 [%2]', PurchaseLineRec.Type, PurchaseLineRec."No.");
                end;
            end;
        end;
    end;

    /*Functions - Sales Order*/
    procedure CreateSalesDocument(par_SalesHeaderRec: Record "Sales Header")
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        FromCompanyName: Text[30];
        ShipCU: Codeunit I9G_CreateSalesWhseShipAndPick;
    begin
        I9G_ThirdPartyLogisticSetupRec.Get();
        Clear(FromCompanyName);
        FromCompanyName := CompanyName();
        if I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true then begin
            CheckSalesLinesBeforeSend(par_SalesHeaderRec);
            //DX        06 Oct 2025     Check for stock balance at PMP
            //ShipCU.CheckSOEnoughStockPickArea(par_SalesHeaderRec, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            ShipCU.CheckSOEnoughStockPickAreaByLot(par_SalesHeaderRec, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            //DX        06 Oct 2025     Check for stock balance at PMP

            if IsSalesDocumentExsits(par_SalesHeaderRec, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany) then begin
                UpdateSalesDocument(par_SalesHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end else begin
                CreateNewSalesDocument(par_SalesHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end;
        end else begin
            Message('Please enable the internal third party logistic function before proceed.');
        end;
    end;

    procedure IsSalesDocumentExsits(par_SalesHeaderRec: Record "Sales Header"; par_WarehouseCompanyName: Text[250]): Boolean
    var
        WarehouseSalesHeaderRec: Record "Sales Header";
        DocumentType: Enum "Sales Document Type";
    begin
        Clear(DocumentType);
        case par_SalesHeaderRec."Document Type" of
            par_SalesHeaderRec."Document Type"::"Credit Memo":
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::"Return Order";
                end;
            par_SalesHeaderRec."Document Type"::Invoice:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Invoice;
                end;
            par_SalesHeaderRec."Document Type"::Order:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Order;
                end;
        end;
        WarehouseSalesHeaderRec.Reset();
        if WarehouseSalesHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehouseSalesHeaderRec.SetRange("Document Type", DocumentType);
            WarehouseSalesHeaderRec.SetRange("No.", par_SalesHeaderRec."No.");
            if WarehouseSalesHeaderRec.FindFirst() then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    procedure CreateNewSalesDocument(par_SalesHeaderRec: Record "Sales Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        SalesLineRec: Record "Sales Line";
        ReservationEntryRec: Record "Reservation Entry";
        ReservationEntryLineNoRec: Record "Reservation Entry";
        WarehouseSalesHeaderRec: Record "Sales Header";
        WarehouseSalesLineRec: Record "Sales Line";
        WarehouseReservationEntryRec: Record "Reservation Entry";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        CustomerRec: Record Customer;
        BillToCustomerRec: Record Customer;
        ItemRec: Record Item;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        DocumentType: Enum "Sales Document Type";
        ShipToAddressRec: Record "Ship-to Address";
        LineNo: Integer;
    begin
        Clear(DocumentType);
        case par_SalesHeaderRec."Document Type" of
            par_SalesHeaderRec."Document Type"::"Credit Memo":
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::"Return Order";
                end;
            par_SalesHeaderRec."Document Type"::Invoice:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Invoice;
                end;
            par_SalesHeaderRec."Document Type"::Order:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Order;
                end;
        end;

        SalesLineRec.Reset();
        SalesLineRec.SetRange("Document Type", par_SalesHeaderRec."Document Type");
        SalesLineRec.SetRange("Document No.", par_SalesHeaderRec."No.");
        if SalesLineRec.FindSet() then begin
            I9G_ThirdPartyLogisticSetupRec.Reset();
            I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName);
            I9G_ThirdPartyLogisticSetupRec.Get();
            if I9G_ThirdPartyLogisticSetupRec.I9G_CustomerCode <> '' then begin
                if SalesReceivablesSetupRec.ChangeCompany(par_WarehouseCompanyName) then begin
                    SalesReceivablesSetupRec.Get();
                    WarehouseSalesHeaderRec.Reset();
                    if WarehouseSalesHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
                        WarehouseSalesHeaderRec.Init();
                        WarehouseSalesHeaderRec.TransferFields(par_SalesHeaderRec);
                        WarehouseSalesHeaderRec."Document Type" := DocumentType;
                        WarehouseSalesHeaderRec."No." := par_SalesHeaderRec."No.";
                        CustomerRec.Reset();
                        if CustomerRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            CustomerRec.SetRange("No.", I9G_ThirdPartyLogisticSetupRec.I9G_CustomerCode);
                            if CustomerRec.FindFirst() then;
                        end;
                        WarehouseSalesHeaderRec."Sell-to Customer No." := I9G_ThirdPartyLogisticSetupRec.I9G_CustomerCode;
                        WarehouseSalesHeaderRec."Sell-to Customer Name" := CustomerRec.Name;
                        WarehouseSalesHeaderRec."Sell-to Customer Name 2" := CustomerRec."Name 2";
                        WarehouseSalesHeaderRec."Sell-to Address" := CustomerRec.Address;
                        WarehouseSalesHeaderRec."Sell-to Address 2" := CustomerRec."Address 2";
                        WarehouseSalesHeaderRec.I9G_SellToAddress3 := CustomerRec.I9G_Adddress3;
                        WarehouseSalesHeaderRec."Sell-to City" := CustomerRec.City;
                        WarehouseSalesHeaderRec."Sell-to Contact" := CustomerRec.Contact;
                        WarehouseSalesHeaderRec."Sell-to Contact No." := CustomerRec."Primary Contact No.";
                        WarehouseSalesHeaderRec."Sell-to Country/Region Code" := CustomerRec."Country/Region Code";
                        WarehouseSalesHeaderRec."Sell-to County" := CustomerRec.County;
                        WarehouseSalesHeaderRec."Sell-to E-Mail" := CustomerRec."E-Mail";
                        WarehouseSalesHeaderRec."Sell-to Phone No." := CustomerRec."Phone No.";
                        WarehouseSalesHeaderRec."Sell-to Post Code" := CustomerRec."Post Code";
                        WarehouseSalesHeaderRec."Delivery Zone" := par_SalesHeaderRec."Delivery Zone";
                        WarehouseSalesHeaderRec."Delivery Charge" := par_SalesHeaderRec."Delivery Charge";
                        WarehouseSalesHeaderRec."Delivery Instructions" := par_SalesHeaderRec."Delivery Instructions";

                        WarehouseSalesHeaderRec."Bill-to Customer No." := I9G_ThirdPartyLogisticSetupRec.I9G_CustomerCode;
                        WarehouseSalesHeaderRec."Bill-to Name" := CustomerRec.Name;
                        WarehouseSalesHeaderRec."Bill-to Address" := CustomerRec."Name 2";
                        WarehouseSalesHeaderRec."Bill-to Address" := CustomerRec.Address;
                        WarehouseSalesHeaderRec."Bill-to Address 2" := CustomerRec."Address 2";
                        WarehouseSalesHeaderRec.I9G_BillToAddress3 := CustomerRec.I9G_Adddress3;
                        WarehouseSalesHeaderRec."Bill-to City" := CustomerRec.City;
                        WarehouseSalesHeaderRec."Bill-to Contact" := CustomerRec.Contact;
                        WarehouseSalesHeaderRec."Bill-to Contact No." := CustomerRec."Primary Contact No.";
                        WarehouseSalesHeaderRec."Bill-to Country/Region Code" := CustomerRec."Country/Region Code";
                        WarehouseSalesHeaderRec."Bill-to County" := CustomerRec.County;
                        WarehouseSalesHeaderRec."Bill-to Post Code" := CustomerRec."Post Code";

                        WarehouseSalesHeaderRec."Ship-to Code" := CustomerRec."Ship-to Code";
                        WarehouseSalesHeaderRec."Ship-to Name" := CustomerRec.Name;
                        WarehouseSalesHeaderRec."Ship-to Name 2" := CustomerRec."Name 2";
                        WarehouseSalesHeaderRec."Ship-to Address" := CustomerRec.Address;
                        WarehouseSalesHeaderRec."Ship-to Address 2" := CustomerRec."Address 2";
                        WarehouseSalesHeaderRec.I9G_ShipToAddress3 := CustomerRec.I9G_Adddress3;
                        WarehouseSalesHeaderRec."Ship-to City" := CustomerRec.City;
                        WarehouseSalesHeaderRec."Ship-to Contact" := CustomerRec.Contact;
                        WarehouseSalesHeaderRec."Ship-to Country/Region Code" := CustomerRec."Country/Region Code";
                        WarehouseSalesHeaderRec."Ship-to County" := CustomerRec.County;
                        WarehouseSalesHeaderRec."Ship-to Post Code" := CustomerRec."Post Code";

                        WarehouseSalesHeaderRec.I9G_NovemShipToAddress := par_SalesHeaderRec.I9G_NovemShipToAddress;
                        WarehouseSalesHeaderRec.I9G_NovemShipToAddress2 := par_SalesHeaderRec.I9G_NovemShipToAddress2;
                        WarehouseSalesHeaderRec.I9G_NovemShipToAddress3 := par_SalesHeaderRec.I9G_NovemShipToAddress3;
                        WarehouseSalesHeaderRec.I9G_NovemShipToCustomerName := par_SalesHeaderRec.I9G_NovemShipToCustomerName;
                        WarehouseSalesHeaderRec.I9G_NovemShipToCustomerName2 := par_SalesHeaderRec.I9G_NovemShipToCustomerName2;

                        WarehouseSalesHeaderRec.I9G_NovemCustNoOfCopies := par_SalesHeaderRec."I9G_NovemCustNoOfCopies";
                        //DX        05 Dec 2025
                        if (par_SalesHeaderRec."Document Type" = par_SalesHeaderRec."Document Type"::"Credit Memo") OR
                        (par_SalesHeaderRec."Document Type" = par_SalesHeaderRec."Document Type"::"Return Order") then begin
                            WarehouseSalesHeaderRec."Posting No. Series" := SalesReceivablesSetupRec."Posted Credit Memo Nos.";
                            WarehouseSalesHeaderRec."Shipping No. Series" := SalesReceivablesSetupRec."Posted Return Receipt Nos.";
                            WarehouseSalesHeaderRec."Posting No." := '';
                            WarehouseSalesHeaderRec."Shipping No." := '';
                        end else begin
                            WarehouseSalesHeaderRec."Posting No. Series" := SalesReceivablesSetupRec."Posted Invoice Nos.";
                            WarehouseSalesHeaderRec."Shipping No. Series" := SalesReceivablesSetupRec."Posted Shipment Nos.";
                            WarehouseSalesHeaderRec."Posting No." := '';
                            WarehouseSalesHeaderRec."Shipping No." := '';
                        end;
                        //DX        05 Dec 2025


                        if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                            I9G_ThirdPartyLogisticSetupRec.Get();
                            if DocumentType <> DocumentType::"Return Order" then begin
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation <> '') then begin
                                    WarehouseSalesHeaderRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation;
                                end;
                            end else begin
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation <> '') then begin
                                    WarehouseSalesHeaderRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation;
                                end;
                            end;
                            if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesPaymentTermsCode <> '') then begin
                                WarehouseSalesHeaderRec."Payment Terms Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesPaymentTermsCode;
                                WarehouseSalesHeaderRec."Prepmt. Payment Terms Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesPaymentTermsCode;
                            end;
                        end;
                        // Build the warehouse header's Dimension Set ID (and shortcut dims) from the
                        // warehouse company's header default dimensions - same find-or-create as the lines.
                        // Replaces the source company's Dimension Set ID copied by TransferFields.
                        WarehouseSalesHeaderRec."Dimension Set ID" := BuildWarehouseHeaderDimSetID(par_WarehouseCompanyName,
                            WarehouseSalesHeaderRec,
                            WarehouseSalesHeaderRec."Shortcut Dimension 1 Code", WarehouseSalesHeaderRec."Shortcut Dimension 2 Code");
                        WarehouseSalesHeaderRec.Insert();
                    end;
                end;
            end else begin
                Error('Please indicate a Sell-to Customer No. in the warehouse company.');
            end;
            repeat
                WarehouseSalesLineRec.Reset();
                if WarehouseSalesLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                    if SalesLineRec.Type = SalesLineRec.Type::Item then begin
                        ItemRec.Reset();
                        if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            ItemRec.SetRange("No.", SalesLineRec."No.");
                            if ItemRec.FindFirst() then begin
                                ItemUnitOfMeasureRec.Reset();
                                if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                    ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                    ItemUnitOfMeasureRec.SetRange(Code, SalesLineRec."Unit of Measure Code");
                                    if not ItemUnitOfMeasureRec.FindFirst() then
                                        Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', SalesLineRec."No.", SalesLineRec."Unit of Measure Code"));
                                end;
                            end else begin
                                Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), SalesLineRec."No.");
                            end;
                        end;
                    end;

                    WarehouseSalesLineRec.Init();
                    WarehouseSalesLineRec.TransferFields(SalesLineRec);
                    WarehouseSalesLineRec."Document Type" := DocumentType;
                    WarehouseSalesLineRec."Document No." := par_SalesHeaderRec."No.";
                    WarehouseSalesLineRec."Sell-to Customer No." := WarehouseSalesHeaderRec."Sell-to Customer No.";
                    WarehouseSalesLineRec."Sell-to Customer Name" := WarehouseSalesHeaderRec."Sell-to Customer Name";
                    WarehouseSalesLineRec."Selling Price" := 0;
                    if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        if DocumentType <> DocumentType::"Return Order" then begin
                            if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation <> '') then begin
                                WarehouseSalesLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation;
                                WarehouseSalesLineRec."Unit Price" := SalesLineRec."Unit Price";
                            end;
                        end else begin
                            if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation <> '') then begin
                                WarehouseSalesLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation;
                                WarehouseSalesLineRec."Unit Price" := 0;
                                WarehouseSalesLineRec."Unit Price" := 0;
                                WarehouseSalesLineRec.Amount := 0;
                                WarehouseSalesLineRec."VAT Base Amount" := 0;
                                WarehouseSalesLineRec."Amount Including VAT" := 0;
                            end;
                            WarehouseSalesLineRec."Order Qty" := SalesLineRec.Quantity;
                        end;
                        WarehouseSalesLineRec."Qty. to Ship" := SalesLineRec."Qty. to Ship";
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenProdPostingGrp <> '') then begin
                            WarehouseSalesLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenProdPostingGrp;
                        end;
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenBusPostingGrp <> '') then begin
                            WarehouseSalesLineRec."Gen. Bus. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenBusPostingGrp;
                        end;
                    end;
                    WarehouseSalesLineRec.Insert();
                    WarehouseSalesLineRec."Shortcut Dimension 1 Code" := '';
                    WarehouseSalesLineRec."Shortcut Dimension 2 Code" := '';
                    WarehouseSalesLineRec."Dimension Set ID" := BuildWarehouseLineDimSetID(par_WarehouseCompanyName,
                        WarehouseSalesHeaderRec, WarehouseSalesLineRec,
                        WarehouseSalesLineRec."Shortcut Dimension 1 Code", WarehouseSalesLineRec."Shortcut Dimension 2 Code");
                    WarehouseSalesLineRec.Modify();
                end;

                ReservationEntryRec.Reset();
                ReservationEntryRec.SetFilter("Reservation Status", '%1|%2', ReservationEntryRec."Reservation Status"::Prospect, ReservationEntryRec."Reservation Status"::Surplus);
                ReservationEntryRec.SetRange("Source Type", SalesLineRec.RecordId.TableNo);
                ReservationEntryRec.SetRange("Source Subtype", SalesLineRec."Document Type".AsInteger());
                ReservationEntryRec.SetRange("Source ID", SalesLineRec."Document No.");
                ReservationEntryRec.SetRange("Source Ref. No.", SalesLineRec."Line No.");
                if ReservationEntryRec.FindSet() then begin
                    repeat
                        ReservationEntryLineNoRec.Reset();
                        if ReservationEntryLineNoRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            if ReservationEntryLineNoRec.FindLast() then begin
                                Clear(LineNo);
                                LineNo := ReservationEntryLineNoRec."Entry No." + 1;
                            end else
                                LineNo := 1;
                        end;
                        WarehouseReservationEntryRec.Reset();
                        if WarehouseReservationEntryRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            WarehouseReservationEntryRec.Init();
                            WarehouseReservationEntryRec.Validate("Entry No.", LineNo);
                            WarehouseReservationEntryRec.Validate("Reservation Status", WarehouseReservationEntryRec."Reservation Status"::Surplus);
                            WarehouseReservationEntryRec.Validate("Item No.", ReservationEntryRec."Item No.");
                            WarehouseSalesLineRec.Reset();
                            if WarehouseSalesLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                WarehouseSalesLineRec.SetRange("Document Type", DocumentType);
                                WarehouseSalesLineRec.SetRange("Document No.", SalesLineRec."Document No.");
                                WarehouseSalesLineRec.SetRange("Line No.", SalesLineRec."Line No.");
                                if WarehouseSalesLineRec.FindFirst() then begin
                                    WarehouseReservationEntryRec.Validate("Location Code", WarehouseSalesLineRec."Location Code");
                                end;
                            end;
                            WarehouseReservationEntryRec.Validate("Source Type", SalesLineRec.RecordId.TableNo);
                            if SalesLineRec."Document Type" <> SalesLineRec."Document Type"::"Credit Memo" then begin
                                WarehouseReservationEntryRec.Validate("Source Subtype", SalesLineRec."Document Type".AsInteger());
                            end else begin
                                WarehouseReservationEntryRec.Validate("Source Subtype", 5);
                            end;
                            WarehouseReservationEntryRec.Validate("Source ID", SalesLineRec."Document No.");
                            WarehouseReservationEntryRec.Validate("Source Ref. No.", SalesLineRec."Line No.");
                            WarehouseReservationEntryRec.Validate(Positive, false);
                            WarehouseReservationEntryRec.Validate("Item Tracking", WarehouseReservationEntryRec."Item Tracking"::"Lot No.");
                            WarehouseReservationEntryRec.Validate("Lot No.", ReservationEntryRec."Lot No.");
                            WarehouseReservationEntryRec.Validate("Qty. per Unit of Measure", ReservationEntryRec."Qty. per Unit of Measure");
                            //DX        27 Oct 2025
                            WarehouseReservationEntryRec.Validate("Shipment Date", SalesLineRec."Shipment Date");
                            //DX        27 Oct 2025

                            WarehouseReservationEntryRec.Validate(Quantity, ReservationEntryRec.Quantity * ReservationEntryRec."Qty. per Unit of Measure");
                            WarehouseReservationEntryRec.Validate("Quantity (Base)", ReservationEntryRec.Quantity);
                            WarehouseReservationEntryRec.Validate("Qty. to Handle (Base)", ReservationEntryRec.Quantity);
                            WarehouseReservationEntryRec.Validate("Qty. to Invoice (Base)", ReservationEntryRec.Quantity);
                            WarehouseReservationEntryRec.Validate("Expiration Date", ReservationEntryRec."Expiration Date");
                            WarehouseReservationEntryRec.Validate("Creation Date", WorkDate());
                            WarehouseReservationEntryRec.Validate("Created By", UserId);
                            WarehouseReservationEntryRec.Insert();
                        end;
                    until ReservationEntryRec.Next() = 0;
                end;

            until SalesLineRec.Next() = 0;

            par_SalesHeaderRec.I9G_SOCreated := true;
            par_SalesHeaderRec.I9G_SONo := par_SalesHeaderRec."No.";
            par_SalesHeaderRec.I9G_SOCreatedBy := UserId();
            par_SalesHeaderRec.I9G_SOCreatedDateTime := CurrentDateTime();
            par_SalesHeaderRec.I9G_NeedToCreateSO := false;
            par_SalesHeaderRec.Modify();

            WarehouseSalesHeaderRec.I9G_SOCreated := true;
            WarehouseSalesHeaderRec.I9G_SONo := par_SalesHeaderRec."No.";
            WarehouseSalesHeaderRec.I9G_SOCreatedBy := UserId();
            WarehouseSalesHeaderRec.I9G_SOCreatedDateTime := CurrentDateTime();
            WarehouseSalesHeaderRec.I9G_FromCompanyName := par_FromCompanyName;
            WarehouseSalesHeaderRec.I9G_CustVendCode := par_SalesHeaderRec."Sell-to Customer No.";
            WarehouseSalesHeaderRec.I9G_CustVendName := par_SalesHeaderRec."Sell-to Customer Name";
            WarehouseSalesHeaderRec.I9G_3PLRemarks := par_SalesHeaderRec.I9G_3PLRemarks;
            WarehouseSalesHeaderRec.I9G_NeedToCreateSO := false;
            WarehouseSalesHeaderRec.Modify();

            if DocumentType = DocumentType::Order then begin
                CreateJobQueueForSalesWhseShipmentAndPick(par_WarehouseCompanyName, WarehouseSalesHeaderRec.RecordId);
            end;
            if DocumentType = DocumentType::"Return Order" then begin
                CreateJobQueueToCreateSalesWhseReceipt(par_WarehouseCompanyName, WarehouseSalesHeaderRec.RecordId);
            end;
            Message('Sales %1 Created.', GetEnumValueNames(par_SalesHeaderRec));
        end else begin
            Error('There is nothing to send and create for sales %1.', GetEnumValueNames(par_SalesHeaderRec));
        end;
    end;

    procedure UpdateSalesDocument(par_SalesHeaderRec: Record "Sales Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        SalesLineRec: Record "Sales Line";
        WarehouseSalesHeaderRec: Record "Sales Header";
        WarehouseSalesLineRec: Record "Sales Line";
        ItemRec: Record Item;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        DocumentType: Enum "Sales Document Type";
        ReservationEntryRec: Record "Reservation Entry";
        ReservationEntryLineNoRec: Record "Reservation Entry";
        WarehouseReservationEntryRec: Record "Reservation Entry";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        LineNo: Integer;
        WarehouseGLSetupRec: Record "General Ledger Setup";
        WarehouseDefaultDimRec: Record "Default Dimension";
    begin
        Clear(DocumentType);
        case par_SalesHeaderRec."Document Type" of
            par_SalesHeaderRec."Document Type"::"Credit Memo":
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::"Return Order";
                end;
            par_SalesHeaderRec."Document Type"::Invoice:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Invoice;
                end;
            par_SalesHeaderRec."Document Type"::Order:
                begin
                    DocumentType := par_SalesHeaderRec."Document Type"::Order;
                end;
        end;
        WarehouseSalesHeaderRec.Reset();
        if WarehouseSalesHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehouseSalesHeaderRec.SetRange("Document Type", DocumentType);
            WarehouseSalesHeaderRec.SetRange("No.", par_SalesHeaderRec."No.");
            if WarehouseSalesHeaderRec.FindFirst() then begin
                if WarehouseSalesHeaderRec.Status <> WarehouseSalesHeaderRec.Status::Open then
                    Error('The sales document is being processed in the warehouse company, no changes will be made.');
                WarehouseGLSetupRec.Reset();
                WarehouseGLSetupRec.ChangeCompany(par_WarehouseCompanyName);
                WarehouseGLSetupRec.Get();
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", par_SalesHeaderRec."Document Type");
                SalesLineRec.SetRange("Document No.", par_SalesHeaderRec."No.");
                if SalesLineRec.FindSet() then begin
                    repeat
                        if SalesLineRec.Type = SalesLineRec.Type::Item then begin
                            ItemRec.Reset();
                            if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                ItemRec.SetRange("No.", SalesLineRec."No.");
                                if ItemRec.FindFirst() then begin
                                    ItemUnitOfMeasureRec.Reset();
                                    if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                        ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                        ItemUnitOfMeasureRec.SetRange(Code, SalesLineRec."Unit of Measure Code");
                                        if not ItemUnitOfMeasureRec.FindFirst() then
                                            Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', SalesLineRec."No.", SalesLineRec."Unit of Measure Code"));
                                    end;
                                end else begin
                                    Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), SalesLineRec."No.");
                                end;
                            end;
                        end;

                        WarehouseReservationEntryRec.Reset();
                        if WarehouseReservationEntryRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            WarehouseReservationEntryRec.SetRange("Reservation Status", ReservationEntryRec."Reservation Status"::Surplus);
                            WarehouseReservationEntryRec.SetRange("Source Type", SalesLineRec.RecordId.TableNo);
                            if SalesLineRec."Document Type" <> SalesLineRec."Document Type"::"Credit Memo" then begin
                                WarehouseReservationEntryRec.SetRange("Source Subtype", SalesLineRec."Document Type".AsInteger());
                            end else begin
                                WarehouseReservationEntryRec.SetRange("Source Subtype", 5);
                            end;
                            WarehouseReservationEntryRec.SetRange("Source ID", SalesLineRec."Document No.");
                            WarehouseReservationEntryRec.SetRange("Source Ref. No.", SalesLineRec."Line No.");
                            if WarehouseReservationEntryRec.FindSet() then
                                WarehouseReservationEntryRec.DeleteAll();
                        end;

                        WarehouseSalesLineRec.Reset();
                        if WarehouseSalesLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            WarehouseSalesLineRec.SetRange("Document Type", DocumentType);
                            WarehouseSalesLineRec.SetRange("Document No.", SalesLineRec."Document No.");
                            WarehouseSalesLineRec.SetRange("Line No.", SalesLineRec."Line No.");
                            if WarehouseSalesLineRec.FindSet() then
                                WarehouseSalesLineRec.DeleteAll();
                        end;

                        WarehouseSalesLineRec.Init();
                        WarehouseSalesLineRec.TransferFields(SalesLineRec);
                        WarehouseSalesLineRec."Document Type" := WarehouseSalesHeaderRec."Document Type";
                        WarehouseSalesLineRec."Document No." := WarehouseSalesHeaderRec."No.";
                        WarehouseSalesLineRec."Sell-to Customer No." := WarehouseSalesHeaderRec."Sell-to Customer No.";
                        WarehouseSalesLineRec."Sell-to Customer Name" := WarehouseSalesHeaderRec."Sell-to Customer Name";
                        WarehouseSalesLineRec."Selling Price" := 0;
                        if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                            I9G_ThirdPartyLogisticSetupRec.Get();
                            if DocumentType <> DocumentType::"Return Order" then begin
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation <> '') then begin
                                    WarehouseSalesLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesOrderLocation;
                                    WarehouseSalesLineRec."Unit Price" := SalesLineRec."Unit Price";
                                end;
                            end else begin
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation <> '') then begin
                                    WarehouseSalesLineRec."Location Code" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmLocation;
                                    WarehouseSalesLineRec."Unit Price" := 0;
                                    WarehouseSalesLineRec.Amount := 0;
                                    WarehouseSalesLineRec."VAT Base Amount" := 0;
                                    WarehouseSalesLineRec."Amount Including VAT" := 0;
                                end;
                                WarehouseSalesLineRec."Order Qty" := SalesLineRec.Quantity;
                            end;
                            WarehouseSalesLineRec."Qty. to Ship" := SalesLineRec."Qty. to Ship";
                            if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenProdPostingGrp <> '') then begin
                                WarehouseSalesLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenProdPostingGrp;
                            end;
                            if (I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenBusPostingGrp <> '') then begin
                                WarehouseSalesLineRec."Gen. Bus. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesGenBusPostingGrp;
                            end;
                        end;
                        WarehouseSalesLineRec.Insert();

                        WarehouseSalesLineRec."Shortcut Dimension 1 Code" := '';
                        WarehouseSalesLineRec."Shortcut Dimension 2 Code" := '';
                        WarehouseSalesLineRec."Dimension Set ID" := BuildWarehouseLineDimSetID(par_WarehouseCompanyName,
                            WarehouseSalesHeaderRec, WarehouseSalesLineRec,
                            WarehouseSalesLineRec."Shortcut Dimension 1 Code", WarehouseSalesLineRec."Shortcut Dimension 2 Code");
                        WarehouseSalesLineRec.Modify();

                        ReservationEntryRec.Reset();
                        ReservationEntryRec.SetFilter("Reservation Status", '%1|%2', ReservationEntryRec."Reservation Status"::Prospect, ReservationEntryRec."Reservation Status"::Surplus);
                        ReservationEntryRec.SetRange("Source Type", SalesLineRec.RecordId.TableNo);
                        ReservationEntryRec.SetRange("Source Subtype", SalesLineRec."Document Type".AsInteger());
                        ReservationEntryRec.SetRange("Source ID", SalesLineRec."Document No.");
                        ReservationEntryRec.SetRange("Source Ref. No.", SalesLineRec."Line No.");
                        if ReservationEntryRec.FindSet() then begin
                            repeat
                                ReservationEntryLineNoRec.Reset();
                                if ReservationEntryLineNoRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                    if ReservationEntryLineNoRec.FindLast() then begin
                                        Clear(LineNo);
                                        LineNo := ReservationEntryLineNoRec."Entry No." + 1;
                                    end else
                                        LineNo := 1;
                                end;
                                WarehouseReservationEntryRec.Reset();
                                if WarehouseReservationEntryRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                    WarehouseReservationEntryRec.Init();
                                    WarehouseReservationEntryRec.Validate("Entry No.", LineNo);
                                    WarehouseReservationEntryRec.Validate("Reservation Status", WarehouseReservationEntryRec."Reservation Status"::Surplus);
                                    WarehouseReservationEntryRec.Validate("Item No.", ReservationEntryRec."Item No.");
                                    WarehouseSalesLineRec.Reset();
                                    if WarehouseSalesLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                        WarehouseSalesLineRec.SetRange("Document Type", DocumentType);
                                        WarehouseSalesLineRec.SetRange("Document No.", SalesLineRec."Document No.");
                                        WarehouseSalesLineRec.SetRange("Line No.", SalesLineRec."Line No.");
                                        if WarehouseSalesLineRec.FindFirst() then begin
                                            WarehouseReservationEntryRec.Validate("Location Code", WarehouseSalesLineRec."Location Code");
                                        end;
                                    end;
                                    WarehouseReservationEntryRec.Validate("Source Type", SalesLineRec.RecordId.TableNo);
                                    if SalesLineRec."Document Type" <> SalesLineRec."Document Type"::"Credit Memo" then begin
                                        WarehouseReservationEntryRec.Validate("Source Subtype", SalesLineRec."Document Type".AsInteger());
                                    end else begin
                                        WarehouseReservationEntryRec.Validate("Source Subtype", 5);
                                    end;
                                    WarehouseReservationEntryRec.Validate("Source ID", SalesLineRec."Document No.");
                                    WarehouseReservationEntryRec.Validate("Source Ref. No.", SalesLineRec."Line No.");
                                    WarehouseReservationEntryRec.Validate(Positive, false);
                                    WarehouseReservationEntryRec.Validate("Item Tracking", WarehouseReservationEntryRec."Item Tracking"::"Lot No.");
                                    WarehouseReservationEntryRec.Validate("Lot No.", ReservationEntryRec."Lot No.");
                                    WarehouseReservationEntryRec.Validate("Qty. per Unit of Measure", ReservationEntryRec."Qty. per Unit of Measure");
                                    //DX        27 Oct 2025
                                    WarehouseReservationEntryRec.Validate("Shipment Date", SalesLineRec."Shipment Date");
                                    //DX        27 Oct 2025
                                    WarehouseReservationEntryRec.Validate(Quantity, ReservationEntryRec.Quantity * ReservationEntryRec."Qty. per Unit of Measure");
                                    WarehouseReservationEntryRec.Validate("Quantity (Base)", ReservationEntryRec.Quantity);
                                    WarehouseReservationEntryRec.Validate("Qty. to Handle (Base)", ReservationEntryRec.Quantity);
                                    WarehouseReservationEntryRec.Validate("Qty. to Invoice (Base)", ReservationEntryRec.Quantity);
                                    WarehouseReservationEntryRec.Validate("Expiration Date", ReservationEntryRec."Expiration Date");
                                    WarehouseReservationEntryRec.Validate("Creation Date", WorkDate());
                                    WarehouseReservationEntryRec.Validate("Created By", UserId);
                                    WarehouseReservationEntryRec.Insert();
                                end;
                            until ReservationEntryRec.Next() = 0;
                        end;
                    until SalesLineRec.Next() = 0;

                    Commit();

                    par_SalesHeaderRec.I9G_SOLastModifiedDateTime := CurrentDateTime();

                    WarehouseSalesHeaderRec.I9G_SOLastModifiedDateTime := CurrentDateTime();
                    WarehouseSalesHeaderRec.I9G_3PLRemarks := par_SalesHeaderRec.I9G_3PLRemarks;
                    // Keep the warehouse header's Dimension Set ID consistent with the warehouse defaults.
                    WarehouseSalesHeaderRec."Dimension Set ID" := BuildWarehouseHeaderDimSetID(par_WarehouseCompanyName,
                        WarehouseSalesHeaderRec,
                        WarehouseSalesHeaderRec."Shortcut Dimension 1 Code", WarehouseSalesHeaderRec."Shortcut Dimension 2 Code");
                    WarehouseSalesHeaderRec.Modify();

                    if DocumentType = DocumentType::Order then begin
                        CreateJobQueueForSalesWhseShipmentAndPick(par_WarehouseCompanyName, WarehouseSalesHeaderRec.RecordId);
                    end;
                    if DocumentType = DocumentType::"Return Order" then begin
                        CreateJobQueueToCreateSalesWhseReceipt(par_WarehouseCompanyName, WarehouseSalesHeaderRec.RecordId);
                    end;
                    Message('Sales %1 Updated.', GetEnumValueNames(par_SalesHeaderRec));
                end else begin
                    Error('There is nothing to send and update for sales %1.', GetEnumValueNames(par_SalesHeaderRec));
                end;
            end;
        end;
    end;

    procedure GetEnumValueNames(par_SalesHeaderRec: Record "Sales Header"): Text
    var
        SalesDocumentTypeEnum: Enum "Sales Document Type";
    begin
        exit(par_SalesHeaderRec."Document Type".Names.Get(SalesDocumentTypeEnum.Ordinals().IndexOf(par_SalesHeaderRec."Document Type".AsInteger())));
    end;

    procedure UndoShipment(par_SalesShipmentLineRec: Record "Sales Shipment Line")
    var
        SalesShipmentHeaderRec: Record "Sales Shipment Header";
        FromCompanySalesShipmentHeaderRec: Record "Sales Shipment Header";
        FromCompanySalesShipmentLineRec: Record "Sales Shipment Line";
    begin
        SalesShipmentHeaderRec.Reset();
        SalesShipmentHeaderRec.SetRange("No.", par_SalesShipmentLineRec."Document No.");
        SalesShipmentHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
        if SalesShipmentHeaderRec.FindFirst() then begin
            FromCompanySalesShipmentHeaderRec.Reset();
            if FromCompanySalesShipmentHeaderRec.ChangeCompany(SalesShipmentHeaderRec.I9G_FromCompanyName) then begin
                FromCompanySalesShipmentHeaderRec.SetRange(I9G_ShipmentNo, SalesShipmentHeaderRec."No.");
                if FromCompanySalesShipmentHeaderRec.FindFirst() then begin
                    FromCompanySalesShipmentLineRec.Reset();
                    if FromCompanySalesShipmentLineRec.ChangeCompany(SalesShipmentHeaderRec.I9G_FromCompanyName) then begin
                        FromCompanySalesShipmentLineRec.SetRange("Document No.", FromCompanySalesShipmentHeaderRec."No.");
                        FromCompanySalesShipmentLineRec.SetRange("Line No.", par_SalesShipmentLineRec."Line No.");
                        FromCompanySalesShipmentLineRec.SetRange("No.", par_SalesShipmentLineRec."No.");
                        if FromCompanySalesShipmentLineRec.FindFirst() then begin
                            CreateJobQueueForUndoPurchaseReceipt(SalesShipmentHeaderRec.I9G_FromCompanyName, FromCompanySalesShipmentLineRec.RecordId);
                        end;
                    end;
                end;
            end;
        end;
    end;

    // Task List No. 3744
    // Builds the warehouse sales line's Dimension Set ID the same way the standard platform
    // does when a Sales Line is created (Codeunit 408 "DimensionManagement"):
    //   1. Resolve the HEADER default dimensions from Bill-to Customer, Salesperson,
    //      Campaign, Responsibility Center, Customer Templ. and Location.
    //   2. Inherit them into the LINE (tagged as Customer, exactly like the platform) and
    //      add the LINE default dimensions from the line type (Item/...), Responsibility
    //      Center, Job and Location.
    // Conflicts between sources are resolved through the warehouse company's
    // "Default Dimension Priority" setup (lower priority number wins), and the final
    // combination is materialised through the standard Dimension Set Tree Node mechanism.
    local procedure BuildWarehouseLineDimSetID(par_WarehouseCompanyName: Text[250]; par_WhseSalesHeader: Record "Sales Header"; par_WhseSalesLine: Record "Sales Line"; var par_ShortcutDim1Code: Code[20]; var par_ShortcutDim2Code: Code[20]): Integer
    var
        WarehouseGLSetupRec: Record "General Ledger Setup";
        WarehouseSourceCodeSetupRec: Record "Source Code Setup";
        TempHeaderDimBuf: Record "Dimension Buffer" temporary;
        TempLineDimBuf: Record "Dimension Buffer" temporary;
        GlobalDimCode: array[2] of Code[20];
        SalesSourceCode: Code[20];
        LineTypeTableID: Integer;
    begin
        Clear(par_ShortcutDim1Code);
        Clear(par_ShortcutDim2Code);

        WarehouseGLSetupRec.ChangeCompany(par_WarehouseCompanyName);
        if not WarehouseGLSetupRec.Get() then
            exit(0);
        GlobalDimCode[1] := WarehouseGLSetupRec."Global Dimension 1 Code";
        GlobalDimCode[2] := WarehouseGLSetupRec."Global Dimension 2 Code";

        WarehouseSourceCodeSetupRec.ChangeCompany(par_WarehouseCompanyName);
        if WarehouseSourceCodeSetupRec.Get() then
            SalesSourceCode := WarehouseSourceCodeSetupRec.Sales;

        // --- Header default dimension sources (mirror Sales Header.InitDefaultDimensionSources) ---
        BuildHeaderDimBuf(TempHeaderDimBuf, par_WarehouseCompanyName, SalesSourceCode, par_WhseSalesHeader);

        // --- Inherit the header dimensions into the line buffer (tagged as Customer, like the platform) ---
        TempHeaderDimBuf.Reset();
        if TempHeaderDimBuf.FindSet() then
            repeat
                InsertDimBufEntry(TempLineDimBuf, DATABASE::Customer, TempHeaderDimBuf."Dimension Code", TempHeaderDimBuf."Dimension Value Code");
            until TempHeaderDimBuf.Next() = 0;

        // --- Line default dimension sources (mirror Sales Line.InitDefaultDimensionSources) ---
        LineTypeTableID := SalesLineTypeToTableID(par_WhseSalesLine.Type);
        if LineTypeTableID <> 0 then
            AddDefaultDimsToDimBuf(TempLineDimBuf, par_WarehouseCompanyName, SalesSourceCode, LineTypeTableID, par_WhseSalesLine."No.");
        AddDefaultDimsToDimBuf(TempLineDimBuf, par_WarehouseCompanyName, SalesSourceCode, DATABASE::"Responsibility Center", par_WhseSalesLine."Responsibility Center");
        AddDefaultDimsToDimBuf(TempLineDimBuf, par_WarehouseCompanyName, SalesSourceCode, DATABASE::Job, par_WhseSalesLine."Job No.");
        AddDefaultDimsToDimBuf(TempLineDimBuf, par_WarehouseCompanyName, SalesSourceCode, DATABASE::Location, par_WhseSalesLine."Location Code");

        // Shortcut (global) dimension codes are read from the final combination, matching
        // DimMgt.UpdateGlobalDimFromDimSetID.
        ResolveShortcutDims(TempLineDimBuf, GlobalDimCode[1], GlobalDimCode[2], par_ShortcutDim1Code, par_ShortcutDim2Code);

        exit(ResolveDimSetIDFromDimBuf(TempLineDimBuf, par_WarehouseCompanyName));
    end;

    // Builds the warehouse HEADER default-dimension buffer from the same sources the platform
    // uses in Sales Header.InitDefaultDimensionSources. Shared by the header and line builders.
    local procedure BuildHeaderDimBuf(var par_TempHeaderDimBuf: Record "Dimension Buffer" temporary; par_WarehouseCompanyName: Text[250]; par_SourceCode: Code[20]; par_WhseSalesHeader: Record "Sales Header")
    begin
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::Customer, par_WhseSalesHeader."Bill-to Customer No.");
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::"Salesperson/Purchaser", par_WhseSalesHeader."Salesperson Code");
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::Campaign, par_WhseSalesHeader."Campaign No.");
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::"Responsibility Center", par_WhseSalesHeader."Responsibility Center");
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::"Customer Templ.", par_WhseSalesHeader."Bill-to Customer Templ. Code");
        AddDefaultDimsToDimBuf(par_TempHeaderDimBuf, par_WarehouseCompanyName, par_SourceCode, DATABASE::Location, par_WhseSalesHeader."Location Code");
    end;

    // Reads the shortcut (global) dimension codes from a resolved buffer, mirroring
    // DimMgt.UpdateGlobalDimFromDimSetID.
    local procedure ResolveShortcutDims(var par_TempDimBuf: Record "Dimension Buffer" temporary; par_GlobalDim1Code: Code[20]; par_GlobalDim2Code: Code[20]; var par_ShortcutDim1Code: Code[20]; var par_ShortcutDim2Code: Code[20])
    begin
        Clear(par_ShortcutDim1Code);
        Clear(par_ShortcutDim2Code);
        if par_GlobalDim1Code <> '' then begin
            par_TempDimBuf.Reset();
            par_TempDimBuf.SetRange("Dimension Code", par_GlobalDim1Code);
            if par_TempDimBuf.FindFirst() then
                par_ShortcutDim1Code := par_TempDimBuf."Dimension Value Code";
        end;
        if par_GlobalDim2Code <> '' then begin
            par_TempDimBuf.Reset();
            par_TempDimBuf.SetRange("Dimension Code", par_GlobalDim2Code);
            if par_TempDimBuf.FindFirst() then
                par_ShortcutDim2Code := par_TempDimBuf."Dimension Value Code";
        end;
        par_TempDimBuf.Reset();
    end;

    // Builds the warehouse sales HEADER's Dimension Set ID from the warehouse company's header
    // default dimensions, using the same tree-node find-or-create as the lines. Prevents the
    // header from keeping the source company's (cross-company) Dimension Set ID.
    local procedure BuildWarehouseHeaderDimSetID(par_WarehouseCompanyName: Text[250]; par_WhseSalesHeader: Record "Sales Header"; var par_ShortcutDim1Code: Code[20]; var par_ShortcutDim2Code: Code[20]): Integer
    var
        WarehouseGLSetupRec: Record "General Ledger Setup";
        WarehouseSourceCodeSetupRec: Record "Source Code Setup";
        TempHeaderDimBuf: Record "Dimension Buffer" temporary;
        SalesSourceCode: Code[20];
    begin
        Clear(par_ShortcutDim1Code);
        Clear(par_ShortcutDim2Code);

        WarehouseGLSetupRec.ChangeCompany(par_WarehouseCompanyName);
        if not WarehouseGLSetupRec.Get() then
            exit(0);

        WarehouseSourceCodeSetupRec.ChangeCompany(par_WarehouseCompanyName);
        if WarehouseSourceCodeSetupRec.Get() then
            SalesSourceCode := WarehouseSourceCodeSetupRec.Sales;

        BuildHeaderDimBuf(TempHeaderDimBuf, par_WarehouseCompanyName, SalesSourceCode, par_WhseSalesHeader);

        ResolveShortcutDims(TempHeaderDimBuf, WarehouseGLSetupRec."Global Dimension 1 Code", WarehouseGLSetupRec."Global Dimension 2 Code", par_ShortcutDim1Code, par_ShortcutDim2Code);

        exit(ResolveDimSetIDFromDimBuf(TempHeaderDimBuf, par_WarehouseCompanyName));
    end;

    // Mirrors the per-source processing of Codeunit 408 "DimensionManagement".GetDefaultDimID:
    // reads the warehouse company's "Default Dimension" for the given table and No. (and the
    // blank "No." table-level defaults) and merges them into the buffer, resolving conflicts
    // through "Default Dimension Priority" (the source with the lower priority number wins; if
    // no priority is set up the value already in the buffer is kept, exactly like the platform).
    local procedure AddDefaultDimsToDimBuf(var par_TempDimBuf: Record "Dimension Buffer" temporary; par_WarehouseCompanyName: Text[250]; par_SourceCode: Code[20]; par_TableID: Integer; par_No: Code[20])
    var
        WarehouseDefaultDimRec: Record "Default Dimension";
        DefaultDimPriorityNew: Record "Default Dimension Priority";
        DefaultDimPriorityExisting: Record "Default Dimension Priority";
        NoFilter: array[2] of Code[20];
        j: Integer;
    begin
        if (par_TableID = 0) or (par_No = '') then
            exit;

        NoFilter[1] := par_No;
        NoFilter[2] := '';

        WarehouseDefaultDimRec.ChangeCompany(par_WarehouseCompanyName);
        DefaultDimPriorityNew.ChangeCompany(par_WarehouseCompanyName);
        DefaultDimPriorityExisting.ChangeCompany(par_WarehouseCompanyName);

        WarehouseDefaultDimRec.SetRange("Table ID", par_TableID);
        for j := 1 to 2 do begin
            WarehouseDefaultDimRec.SetRange("No.", NoFilter[j]);
            if WarehouseDefaultDimRec.FindSet() then
                repeat
                    if WarehouseDefaultDimRec."Dimension Value Code" <> '' then begin
                        par_TempDimBuf.Reset();
                        par_TempDimBuf.SetRange("Dimension Code", WarehouseDefaultDimRec."Dimension Code");
                        if not par_TempDimBuf.FindFirst() then
                            InsertDimBufEntry(par_TempDimBuf, WarehouseDefaultDimRec."Table ID", WarehouseDefaultDimRec."Dimension Code", WarehouseDefaultDimRec."Dimension Value Code")
                        else
                            if DefaultDimPriorityNew.Get(par_SourceCode, WarehouseDefaultDimRec."Table ID") then
                                if DefaultDimPriorityExisting.Get(par_SourceCode, par_TempDimBuf."Table ID") then begin
                                    if DefaultDimPriorityNew.Priority < DefaultDimPriorityExisting.Priority then begin
                                        par_TempDimBuf.Delete();
                                        InsertDimBufEntry(par_TempDimBuf, WarehouseDefaultDimRec."Table ID", WarehouseDefaultDimRec."Dimension Code", WarehouseDefaultDimRec."Dimension Value Code");
                                    end;
                                end else begin
                                    par_TempDimBuf.Delete();
                                    InsertDimBufEntry(par_TempDimBuf, WarehouseDefaultDimRec."Table ID", WarehouseDefaultDimRec."Dimension Code", WarehouseDefaultDimRec."Dimension Value Code");
                                end;
                    end;
                until WarehouseDefaultDimRec.Next() = 0;
        end;
        par_TempDimBuf.Reset();
    end;

    local procedure InsertDimBufEntry(var par_TempDimBuf: Record "Dimension Buffer" temporary; par_TableID: Integer; par_DimCode: Code[20]; par_DimValueCode: Code[20])
    begin
        par_TempDimBuf.Init();
        par_TempDimBuf."Table ID" := par_TableID;
        par_TempDimBuf."Entry No." := 0;
        par_TempDimBuf."Dimension Code" := par_DimCode;
        par_TempDimBuf."Dimension Value Code" := par_DimValueCode;
        par_TempDimBuf.Insert();
    end;

    // Maps a Sales Line Type to its default-dimension source table, like
    // DimMgt.SalesLineTypeToTableID. Returns 0 for types without a master table.
    local procedure SalesLineTypeToTableID(par_LineType: Enum "Sales Line Type"): Integer
    begin
        case par_LineType of
            par_LineType::Item:
                exit(DATABASE::Item);
            par_LineType::"G/L Account":
                exit(DATABASE::"G/L Account");
            par_LineType::Resource:
                exit(DATABASE::Resource);
            par_LineType::"Fixed Asset":
                exit(DATABASE::"Fixed Asset");
            par_LineType::"Charge (Item)":
                exit(DATABASE::"Item Charge");
        end;
        exit(0);
    end;

    // Materialises the dimension combination held in the buffer into a Dimension Set ID in the
    // warehouse company, using the standard Dimension Set Tree Node mechanism (see Codeunit 408
    // "DimensionManagement".GetDimensionSetID).
    local procedure ResolveDimSetIDFromDimBuf(var par_TempDimBuf: Record "Dimension Buffer" temporary; par_WarehouseCompanyName: Text[250]): Integer
    var
        WarehouseDimValueRec: Record "Dimension Value";
        WarehouseDimensionRec: Record Dimension;
        WarehouseDimSetEntry: Record "Dimension Set Entry";
        WarehouseDimSetTreeNode: Record "Dimension Set Tree Node";
        WarehouseDimSetTreeNode2: Record "Dimension Set Tree Node";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        NewDimSetID: Integer;
        NewNodeID: Integer;
    begin
        par_TempDimBuf.Reset();
        if not par_TempDimBuf.FindSet() then
            exit(0);

        WarehouseDimValueRec.ChangeCompany(par_WarehouseCompanyName);
        WarehouseDimensionRec.ChangeCompany(par_WarehouseCompanyName);
        repeat
            WarehouseDimValueRec.Reset();
            WarehouseDimValueRec.SetRange("Dimension Code", par_TempDimBuf."Dimension Code");
            WarehouseDimValueRec.SetRange(Code, par_TempDimBuf."Dimension Value Code");
            if WarehouseDimValueRec.FindFirst() then begin
                if not WarehouseDimensionRec.Get(par_TempDimBuf."Dimension Code") then
                    Clear(WarehouseDimensionRec);
                TempDimSetEntry.Init();
                TempDimSetEntry."Dimension Set ID" := 0;
                TempDimSetEntry."Dimension Code" := par_TempDimBuf."Dimension Code";
                TempDimSetEntry."Dimension Value Code" := WarehouseDimValueRec.Code;
                TempDimSetEntry."Dimension Value ID" := WarehouseDimValueRec."Dimension Value ID";
                TempDimSetEntry."Dimension Name" := WarehouseDimensionRec.Name;
                TempDimSetEntry."Dimension Value Name" := WarehouseDimValueRec.Name;
                if WarehouseDimValueRec."Global Dimension No." in [1, 2] then
                    TempDimSetEntry."Global Dimension No." := WarehouseDimValueRec."Global Dimension No.";
                if TempDimSetEntry.Insert() then;
            end;
        until par_TempDimBuf.Next() = 0;

        TempDimSetEntry.Reset();
        if TempDimSetEntry.IsEmpty() then
            exit(0);

        // Resolve (or create) the Dimension Set ID in the warehouse company using the
        // same Dimension Set Tree Node mechanism as the standard Codeunit 408
        // "DimensionManagement".GetDimensionSetID. The temporary entries are walked in
        // primary-key order (Dimension Code), branching on "Dimension Value ID" at each
        // level, exactly as the platform does. This guarantees:
        //   * an existing identical combination is reused (no duplicate set is created);
        //   * the master ID counter - which is driven by the tree node table, NOT by the
        //     Dimension Set Entry table - stays in sync, so the standard code can never
        //     later re-issue an ID we already used (the root cause of the
        //     "Dimension Set Entry already exists" error during Calculate Inventory).
        WarehouseDimSetTreeNode.ChangeCompany(par_WarehouseCompanyName);
        WarehouseDimSetTreeNode2.ChangeCompany(par_WarehouseCompanyName);
        WarehouseDimSetEntry.ChangeCompany(par_WarehouseCompanyName);

        NewDimSetID := 0;
        TempDimSetEntry.Reset();
        TempDimSetEntry.FindSet();
        repeat
            if not WarehouseDimSetTreeNode.Get(NewDimSetID, TempDimSetEntry."Dimension Value ID") then begin
                WarehouseDimSetTreeNode.LockTable();
                if not WarehouseDimSetTreeNode.Get(NewDimSetID, TempDimSetEntry."Dimension Value ID") then begin
                    WarehouseDimSetTreeNode2.Reset();
                    WarehouseDimSetTreeNode2.SetCurrentKey("Dimension Set ID");
                    if WarehouseDimSetTreeNode2.FindLast() then
                        NewNodeID := WarehouseDimSetTreeNode2."Dimension Set ID" + 1
                    else
                        NewNodeID := 1;
                    WarehouseDimSetTreeNode.Init();
                    WarehouseDimSetTreeNode."Parent Dimension Set ID" := NewDimSetID;
                    WarehouseDimSetTreeNode."Dimension Value ID" := TempDimSetEntry."Dimension Value ID";
                    WarehouseDimSetTreeNode."Dimension Set ID" := NewNodeID;
                    WarehouseDimSetTreeNode."In Use" := false;
                    WarehouseDimSetTreeNode.Insert();
                end;
            end;
            NewDimSetID := WarehouseDimSetTreeNode."Dimension Set ID";
        until TempDimSetEntry.Next() = 0;

        // Only the leaf node carries the actual entries; create them once, when the set
        // is first materialised ("In Use" = false).
        if not WarehouseDimSetTreeNode."In Use" then begin
            TempDimSetEntry.Reset();
            TempDimSetEntry.FindSet();
            repeat
                if not WarehouseDimSetEntry.Get(NewDimSetID, TempDimSetEntry."Dimension Code") then begin
                    WarehouseDimSetEntry.Init();
                    WarehouseDimSetEntry."Dimension Set ID" := NewDimSetID;
                    WarehouseDimSetEntry."Dimension Code" := TempDimSetEntry."Dimension Code";
                    WarehouseDimSetEntry."Dimension Value Code" := TempDimSetEntry."Dimension Value Code";
                    WarehouseDimSetEntry."Dimension Value ID" := TempDimSetEntry."Dimension Value ID";
                    WarehouseDimSetEntry."Dimension Name" := TempDimSetEntry."Dimension Name";
                    WarehouseDimSetEntry."Dimension Value Name" := TempDimSetEntry."Dimension Value Name";
                    WarehouseDimSetEntry."Global Dimension No." := TempDimSetEntry."Global Dimension No.";
                    WarehouseDimSetEntry.Insert();
                end;
            until TempDimSetEntry.Next() = 0;
            WarehouseDimSetTreeNode."In Use" := true;
            WarehouseDimSetTreeNode.Modify();
        end;

        exit(NewDimSetID);
    end;

    procedure CheckSalesLinesBeforeSend(par_SalesHeaderRec: Record "Sales Header")
    var
        SalesLineRec: Record "Sales Line";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        ShortcutDimensionCode: array[8] of Code[20];
        ShipCU: Codeunit I9G_CreateSalesWhseShipAndPick;
        ReservationEntryRec: Record "Reservation Entry";
        ItemRec: Record Item;
    begin
        if (par_SalesHeaderRec."Document Type" = par_SalesHeaderRec."Document Type"::Order) and (par_SalesHeaderRec.I9G_SignedOrder = false) and (par_SalesHeaderRec.I9G_DeliveryOrder = false) then begin
            Error('Please indicate posting for Signed Order or Delivery order.');
        end;

        SalesLineRec.Reset();
        SalesLineRec.SetRange("Document Type", par_SalesHeaderRec."Document Type");
        SalesLineRec.SetRange("Document No.", par_SalesHeaderRec."No.");
        SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
        if SalesLineRec.FindSet() then begin
            repeat
                if SalesLineRec."Location Code" = '' then
                    Error('%1 must have a value for %2 [%3]', SalesLineRec.FieldCaption("Location Code"), SalesLineRec.Type, SalesLineRec."No.");
                if SalesLineRec.Quantity = 0 then
                    Error('%1 must have a value for %2 [%3]', SalesLineRec.FieldCaption(Quantity), SalesLineRec.Type, SalesLineRec."No.");
                if SalesLineRec."Gen. Prod. Posting Group" = '' then
                    Error('%1 must have a value for %2 [%3]', SalesLineRec.FieldCaption("Gen. Prod. Posting Group"), SalesLineRec.Type, SalesLineRec."No.");
                if SalesLineRec."Shortcut Dimension 1 Code" = '' then
                    Error('%1 must have a value for %2 [%3]', SalesLineRec.FieldCaption("Shortcut Dimension 1 Code"), SalesLineRec.Type, SalesLineRec."No.");
                if SalesLineRec."Shortcut Dimension 2 Code" = '' then
                    Error('%1 must have a value for %2 [%3]', SalesLineRec.FieldCaption("Shortcut Dimension 2 Code"), SalesLineRec.Type, SalesLineRec."No.");
                DimensionManagementCodeUnit.GetShortcutDimensions(SalesLineRec."Dimension Set ID", ShortcutDimensionCode);
                if ShortcutDimensionCode[4] = '' then
                    Error('Product Code must have a value for %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");
                if ShortcutDimensionCode[6] = '' then
                    Error('Geographical Code must have a value for %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");
                if ShortcutDimensionCode[7] = '' then
                    Error('Sales Employee Code must have a value for %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");


                ItemRec.Reset();
                ItemRec.SetRange("No.", SalesLineRec."No.");
                ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
                if ItemRec.FindFirst() then begin
                    ReservationEntryRec.Reset();
                    ReservationEntryRec.SetFilter("Reservation Status", '%1|%2', ReservationEntryRec."Reservation Status"::Prospect, ReservationEntryRec."Reservation Status"::Surplus);
                    ReservationEntryRec.SetRange("Source Type", SalesLineRec.RecordId.TableNo);
                    ReservationEntryRec.SetRange("Source Subtype", SalesLineRec."Document Type".AsInteger());
                    ReservationEntryRec.SetRange("Source ID", SalesLineRec."Document No.");
                    ReservationEntryRec.SetRange("Source Ref. No.", SalesLineRec."Line No.");
                    ReservationEntryRec.SetRange("Item No.", SalesLineRec."No.");
                    ReservationEntryRec.SetRange("Location Code", SalesLineRec."Location Code");
                    if ReservationEntryRec.FindFirst() then begin
                        if ReservationEntryRec."Lot No." = '' then
                            Error('Lot No. must have a value for %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");
                    end else begin
                        Error('Item tracking entries must have a value for  %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");
                    end;
                end;
            until SalesLineRec.Next() = 0;
        end;

    end;

    procedure CheckSalesLineBeforeCreateWarehouseShip(par_SalesHeaderRec: Record "Sales Header")
    var
        SalesLineRec: Record "Sales Line";
        I9G_ThirdPartyLogisticSetup: Record I9G_ThirdPartyLogisticSetup;
    begin
        if I9G_ThirdPartyLogisticSetup.Get() then begin
            if (I9G_ThirdPartyLogisticSetup.I9G_EnableThirdPartyLogistic = true) and (CheckCompanyName() = false) then begin
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", par_SalesHeaderRec."Document Type");
                SalesLineRec.SetRange("Document No.", par_SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                SalesLineRec.SetFilter("Selling Price", '<>%1', 0);
                if SalesLineRec.FindFirst() then begin
                    Error('Selling Price must be empty for %1 [%2]', SalesLineRec.Type, SalesLineRec."No.");
                end;
            end;
        end;
    end;

    /*Functions - Transfer Order*/
    procedure CreateTransferDocument(par_TransferHeaderRec: Record "Transfer Header")
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        FromCompanyName: Text[30];
    begin
        I9G_ThirdPartyLogisticSetupRec.Get();
        Clear(FromCompanyName);
        FromCompanyName := CompanyName();
        if I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true then begin
            CheckTransferLinesBeforeSend(par_TransferHeaderRec);
            if IsTransferDocumentExsits(par_TransferHeaderRec, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany) then begin
                UpdateTransferDocument(par_TransferHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end else begin
                CreateNewTransferDocument(par_TransferHeaderRec, FromCompanyName, I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany);
            end;
        end else begin
            Message('Please enable the internal third party logistic function before proceed.');
        end;
    end;

    procedure IsTransferDocumentExsits(par_TransferHeaderRec: Record "Transfer Header"; par_WarehouseCompanyName: Text[250]): Boolean
    var
        WarehouseTransferHeaderRec: Record "Transfer Header";
    begin
        WarehouseTransferHeaderRec.Reset();
        if WarehouseTransferHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehouseTransferHeaderRec.SetRange("No.", par_TransferHeaderRec."No.");
            if WarehouseTransferHeaderRec.FindFirst() then begin
                exit(true);
            end else begin
                exit(false);
            end;
        end;
    end;

    procedure CreateNewTransferDocument(par_TransferHeaderRec: Record "Transfer Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        TransferLineRec: Record "Transfer Line";
        WarehouseTransferHeaderRec: Record "Transfer Header";
        WarehouseTransferLineRec: Record "Transfer Line";
        InventorySetupRec: Record "Inventory Setup";
        TransferFromLocationRec: Record Location;
        TransferToLocationRec: Record Location;
        ItemRec: Record Item;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
    begin
        TransferLineRec.Reset();
        TransferLineRec.SetRange("Document No.", par_TransferHeaderRec."No.");
        if TransferLineRec.FindSet() then begin
            WarehouseTransferHeaderRec.Reset();
            if WarehouseTransferHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
                I9G_ThirdPartyLogisticSetupRec.Reset();
                I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName);
                I9G_ThirdPartyLogisticSetupRec.Get();
                if (I9G_ThirdPartyLogisticSetupRec.I9G_TranferFromLocation <> '') and (I9G_ThirdPartyLogisticSetupRec.I9G_TranferToLocation <> '') then begin
                    if InventorySetupRec.ChangeCompany(par_WarehouseCompanyName) then begin
                        InventorySetupRec.Get();
                        WarehouseTransferHeaderRec.Init();
                        WarehouseTransferHeaderRec.TransferFields(par_TransferHeaderRec);
                        WarehouseTransferHeaderRec."No." := par_TransferHeaderRec."No.";
                        WarehouseTransferHeaderRec."Transfer-from Code" := I9G_ThirdPartyLogisticSetupRec.I9G_TranferFromLocation;
                        WarehouseTransferHeaderRec."Transfer-To Code" := I9G_ThirdPartyLogisticSetupRec.I9G_TranferToLocation;
                        TransferFromLocationRec.Reset();
                        if TransferFromLocationRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            TransferFromLocationRec.SetRange(Code, I9G_ThirdPartyLogisticSetupRec.I9G_TranferFromLocation);
                            if TransferFromLocationRec.FindFirst() then;
                        end;

                        TransferToLocationRec.Reset();
                        if TransferToLocationRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            TransferToLocationRec.SetRange(Code, I9G_ThirdPartyLogisticSetupRec.I9G_TranferToLocation);
                            if TransferToLocationRec.FindFirst() then;
                        end;

                        WarehouseTransferHeaderRec."Transfer-from Name" := TransferFromLocationRec.Name;
                        WarehouseTransferHeaderRec."Transfer-from Name 2" := TransferFromLocationRec."Name 2";
                        WarehouseTransferHeaderRec."Transfer-from Address" := TransferFromLocationRec.Address;
                        WarehouseTransferHeaderRec."Transfer-from Name 2" := TransferFromLocationRec."Address 2";
                        WarehouseTransferHeaderRec."Transfer-from City" := TransferFromLocationRec.City;
                        WarehouseTransferHeaderRec."Transfer-from Post Code" := TransferFromLocationRec."Post Code";

                        WarehouseTransferHeaderRec."Transfer-To Name" := TransferToLocationRec.Name;
                        WarehouseTransferHeaderRec."Transfer-To Name 2" := TransferToLocationRec."Name 2";
                        WarehouseTransferHeaderRec."Transfer-To Address" := TransferToLocationRec.Address;
                        WarehouseTransferHeaderRec."Transfer-To Name 2" := TransferToLocationRec."Address 2";
                        WarehouseTransferHeaderRec."Transfer-To City" := TransferToLocationRec.City;
                        WarehouseTransferHeaderRec."Transfer-To Post Code" := TransferToLocationRec."Post Code";
                        WarehouseTransferHeaderRec.Insert();
                    end;
                end else begin
                    Error('Please indicate a Transfer-From Code and Transfer-To Code in the warehouse company.');
                end;
            end;
            repeat
                WarehouseTransferLineRec.Reset();
                if WarehouseTransferLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                    ItemRec.Reset();
                    if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                        ItemRec.SetRange("No.", TransferLineRec."Item No.");
                        if ItemRec.FindFirst() then begin
                            ItemUnitOfMeasureRec.Reset();
                            if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                ItemUnitOfMeasureRec.SetRange(Code, TransferLineRec."Unit of Measure Code");
                                if not ItemUnitOfMeasureRec.FindFirst() then
                                    Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', TransferLineRec."Item No.", TransferLineRec."Unit of Measure Code"));
                            end;
                        end else begin
                            Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), TransferLineRec."Item No.");
                        end;
                    end;
                    WarehouseTransferLineRec.Init();
                    WarehouseTransferLineRec.TransferFields(TransferLineRec);
                    WarehouseTransferLineRec."Document No." := WarehouseTransferHeaderRec."No.";
                    WarehouseTransferLineRec."Transfer-from Code" := WarehouseTransferHeaderRec."Transfer-from Code";
                    WarehouseTransferLineRec."Transfer-to Code" := WarehouseTransferHeaderRec."Transfer-to Code";
                    if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp <> '') then begin
                            WarehouseTransferLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_TransferGenProdPostingGrp;
                        end;
                    end;
                    WarehouseTransferLineRec.Insert();
                end;
            until TransferLineRec.Next() = 0;

            par_TransferHeaderRec.I9G_TOCreated := true;
            par_TransferHeaderRec.I9G_TONo := WarehouseTransferHeaderRec."No.";
            par_TransferHeaderRec.I9G_TOCreatedBy := UserId();
            par_TransferHeaderRec.I9G_TOCreatedDateTime := CurrentDateTime();
            par_TransferHeaderRec.Modify();

            WarehouseTransferHeaderRec.I9G_TOCreated := true;
            WarehouseTransferHeaderRec.I9G_TONo := par_TransferHeaderRec."No.";
            WarehouseTransferHeaderRec.I9G_TOCreatedBy := UserId();
            WarehouseTransferHeaderRec.I9G_TOCreatedDateTime := CurrentDateTime();
            WarehouseTransferHeaderRec.I9G_FromCompanyName := par_FromCompanyName;
            WarehouseTransferHeaderRec.I9G_TransferFromName := par_TransferHeaderRec."Transfer-from Name";
            WarehouseTransferHeaderRec.I9G_TransferToName := par_TransferHeaderRec."Transfer-to Name";
            WarehouseTransferHeaderRec.I9G_3PLRemarks := par_TransferHeaderRec.I9G_3PLRemarks;
            WarehouseTransferHeaderRec.Modify();

            I9G_CreateTransWhseShipAndPick(par_WarehouseCompanyName, WarehouseTransferHeaderRec.RecordId);

            Message('Transfer Order Created.');
        end else begin
            Error('There is nothing to send and create for transfer order.');
        end;
    end;

    procedure UpdateTransferDocument(par_TransferHeaderRec: Record "Transfer Header"; par_FromCompanyName: Text[250]; par_WarehouseCompanyName: Text[250])
    var
        TransferLineRec: Record "Transfer Line";
        WarehouseTransferHeaderRec: Record "Transfer Header";
        WarehouseTransferLineRec: Record "Transfer Line";
        ItemRec: Record Item;
        ItemUnitOfMeasureRec: Record "Item Unit of Measure";
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
    begin
        WarehouseTransferHeaderRec.Reset();
        if WarehouseTransferHeaderRec.ChangeCompany(par_WarehouseCompanyName) then begin
            WarehouseTransferHeaderRec.SetRange("No.", par_TransferHeaderRec."No.");
            if WarehouseTransferHeaderRec.FindFirst() then begin
                if WarehouseTransferHeaderRec.Status <> WarehouseTransferHeaderRec.Status::Open then
                    Error('The transfer document is being processed in the warehouse company, no changes will be made.');
                TransferLineRec.Reset();
                TransferLineRec.SetRange("Document No.", par_TransferHeaderRec."No.");
                if TransferLineRec.FindSet() then begin
                    repeat
                        ItemRec.Reset();
                        if ItemRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            ItemRec.SetRange("No.", TransferLineRec."Item No.");
                            if ItemRec.FindFirst() then begin
                                ItemUnitOfMeasureRec.Reset();
                                if ItemUnitOfMeasureRec.ChangeCompany(par_WarehouseCompanyName) then begin
                                    ItemUnitOfMeasureRec.SetRange("Item No.", ItemRec."No.");
                                    ItemUnitOfMeasureRec.SetRange(Code, TransferLineRec."Unit of Measure Code");
                                    if not ItemUnitOfMeasureRec.FindFirst() then
                                        Error(StrSubstNo('The item %1 unit of measure code %2 is not found in the warehouse company.', TransferLineRec."Item No.", TransferLineRec."Unit of Measure Code"));
                                end;
                            end else begin
                                Error(StrSubstNo('The Item No. %1 is not found in the warehouse company.'), TransferLineRec."Item No.");
                            end;
                        end;
                        WarehouseTransferLineRec.Reset();
                        if WarehouseTransferLineRec.ChangeCompany(par_WarehouseCompanyName) then begin
                            WarehouseTransferLineRec.SetRange("Document No.", TransferLineRec."Document No.");
                            WarehouseTransferLineRec.SetRange("Line No.", TransferLineRec."Line No.");
                            if WarehouseTransferLineRec.FindSet() then
                                WarehouseTransferLineRec.DeleteAll(true);
                            WarehouseTransferLineRec.Init();
                            WarehouseTransferLineRec.TransferFields(TransferLineRec);
                            WarehouseTransferLineRec."Document No." := WarehouseTransferHeaderRec."No.";
                            WarehouseTransferLineRec."Transfer-from Code" := WarehouseTransferHeaderRec."Transfer-from Code";
                            WarehouseTransferLineRec."Transfer-to Code" := WarehouseTransferHeaderRec."Transfer-to Code";
                            if (I9G_ThirdPartyLogisticSetupRec.ChangeCompany(par_WarehouseCompanyName)) then begin
                                I9G_ThirdPartyLogisticSetupRec.Get();
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseGenProdPostingGrp <> '') then begin
                                    WarehouseTransferLineRec."Gen. Prod. Posting Group" := I9G_ThirdPartyLogisticSetupRec.I9G_TransferGenProdPostingGrp;
                                end;
                            end;
                            WarehouseTransferLineRec.Insert();
                        end;
                    until TransferLineRec.Next() = 0;
                end;
            end else begin
                Error('There is nothing to send and update for transfer order.');
            end;

            par_TransferHeaderRec.I9G_TOLastModifiedDateTime := CurrentDateTime();

            WarehouseTransferHeaderRec.I9G_3PLRemarks := par_TransferHeaderRec.I9G_3PLRemarks;
            WarehouseTransferHeaderRec.I9G_TOLastModifiedDateTime := CurrentDateTime();
            WarehouseTransferHeaderRec.Modify();

            CreateJobQueueToCreateSalesWhseReceipt(par_WarehouseCompanyName, WarehouseTransferHeaderRec.RecordId);

            Message('Purchase Order Updated.');
        end;
    end;

    procedure CheckTransferLinesBeforeSend(par_TransferHeaderRec: Record "Transfer Header")
    var
        TransferLineRec: Record "Transfer Line";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        ShortcutDimensionCode: array[8] of Code[20];
    begin
        TransferLineRec.Reset();
        TransferLineRec.SetRange("Document No.", par_TransferHeaderRec."No.");
        if TransferLineRec.FindSet() then begin
            repeat
                if TransferLineRec.Quantity = 0 then
                    Error('%1 must have a value for [%2]', TransferLineRec.FieldCaption(Quantity), TransferLineRec."Item No.");
            until TransferLineRec.Next() = 0;
        end;
    end;
    /*Event Subsribers - Purchase*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostPurchaseDoc, '', false, false)]
    local procedure "PurchPostOnAfterPostPurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        PurchaseLineRec: Record "Purchase Line";
        FromCompanyPurchaseHeaderRec: Record "Purchase Header";
        OpenFromCompanyPurchaseHeaderRec: Record "Purchase Header";
        FromCompanyPurchaseLineRec: Record "Purchase Line";
        FromCompanyReservationEntryRec: Record "Reservation Entry";
        ReservationEntryLineNoRec: Record "Reservation Entry";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        PayTermRec: Record "Payment Terms";
        LineNo: Integer;
    begin
        if PurchaseHeader.I9G_FromCompanyName <> '' then begin
            PurchaseLineRec.Reset();
            PurchaseLineRec.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchaseLineRec.SetRange("Document No.", PurchaseHeader."No.");
            if PurchaseLineRec.FindSet() then begin
                repeat
                    ItemLedgerEntryRec.Reset();
                    ItemLedgerEntryRec.SetRange("Entry Type", ItemLedgerEntryRec."Entry Type"::Purchase);
                    ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Purchase Receipt");
                    ItemLedgerEntryRec.SetRange("Document No.", PurchRcpHdrNo);
                    ItemLedgerEntryRec.SetRange("Document Line No.", PurchaseLineRec."Line No.");
                    ItemLedgerEntryRec.SetFilter("Lot No.", '<>%1', '');
                    if ItemLedgerEntryRec.FindSet() then begin
                        repeat
                            ReservationEntryLineNoRec.Reset();
                            if ReservationEntryLineNoRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                                if ReservationEntryLineNoRec.FindLast() then begin
                                    Clear(LineNo);
                                    LineNo := ReservationEntryLineNoRec."Entry No." + 1;
                                end else
                                    LineNo := 1;
                            end;
                            FromCompanyReservationEntryRec.Reset();
                            if FromCompanyReservationEntryRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                                FromCompanyReservationEntryRec.Init();
                                FromCompanyReservationEntryRec.Validate("Entry No.", LineNo);
                                FromCompanyReservationEntryRec.Validate("Reservation Status", FromCompanyReservationEntryRec."Reservation Status"::Surplus);
                                FromCompanyReservationEntryRec.Validate("Item No.", ItemLedgerEntryRec."Item No.");
                                FromCompanyPurchaseLineRec.Reset();
                                if FromCompanyPurchaseLineRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                                    FromCompanyPurchaseLineRec.SetRange("Document Type", PurchaseLineRec."Document Type");
                                    FromCompanyPurchaseLineRec.SetRange("Document No.", PurchaseHeader.I9G_PONo);
                                    FromCompanyPurchaseLineRec.SetRange("Line No.", PurchaseLineRec."Line No.");
                                    if FromCompanyPurchaseLineRec.FindFirst() then begin
                                        FromCompanyReservationEntryRec.Validate("Location Code", FromCompanyPurchaseLineRec."Location Code");
                                    end;
                                end;
                                FromCompanyReservationEntryRec.Validate("Source Type", PurchaseLineRec.RecordId.TableNo);
                                FromCompanyReservationEntryRec.Validate("Source Subtype", PurchaseLineRec."Document Type".AsInteger());
                                FromCompanyReservationEntryRec.Validate("Source ID", PurchaseLineRec."Document No.");
                                FromCompanyReservationEntryRec.Validate("Source Ref. No.", PurchaseLineRec."Line No.");
                                FromCompanyReservationEntryRec.Validate(Positive, true);
                                FromCompanyReservationEntryRec.Validate("Item Tracking", FromCompanyReservationEntryRec."Item Tracking"::"Lot No.");
                                FromCompanyReservationEntryRec.Validate("Lot No.", ItemLedgerEntryRec."Lot No.");
                                if ItemLedgerEntryRec."Qty. per Unit of Measure" = 0 then begin
                                    FromCompanyReservationEntryRec.Validate("Qty. per Unit of Measure", 1)
                                end else begin
                                    FromCompanyReservationEntryRec.Validate("Qty. per Unit of Measure", ItemLedgerEntryRec."Qty. per Unit of Measure");
                                end;
                                FromCompanyReservationEntryRec.Validate(Quantity, Abs(ItemLedgerEntryRec.Quantity * ItemLedgerEntryRec."Qty. per Unit of Measure"));
                                FromCompanyReservationEntryRec.Validate("Quantity (Base)", Abs(ItemLedgerEntryRec.Quantity));
                                FromCompanyReservationEntryRec.Validate("Qty. to Handle (Base)", Abs(ItemLedgerEntryRec.Quantity));
                                FromCompanyReservationEntryRec.Validate("Qty. to Invoice (Base)", Abs(ItemLedgerEntryRec.Quantity));
                                FromCompanyReservationEntryRec.Validate("Expiration Date", ItemLedgerEntryRec."Expiration Date");
                                FromCompanyReservationEntryRec.Validate("Creation Date", WorkDate());
                                FromCompanyReservationEntryRec.Validate("Created By", UserId);
                                FromCompanyReservationEntryRec.Insert();
                            end;
                        until ItemLedgerEntryRec.Next() = 0;
                    end;

                    OpenFromCompanyPurchaseHeaderRec.Reset();
                    if OpenFromCompanyPurchaseHeaderRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                        OpenFromCompanyPurchaseHeaderRec.SetRange("Document Type", PurchaseHeader."Document Type");
                        OpenFromCompanyPurchaseHeaderRec.SetRange("No.", PurchaseHeader."No.");
                        if OpenFromCompanyPurchaseHeaderRec.FindFirst() then begin
                            OpenFromCompanyPurchaseHeaderRec.Status := OpenFromCompanyPurchaseHeaderRec.Status::Open;
                            OpenFromCompanyPurchaseHeaderRec.I9G_ReceiptNo := PurchRcpHdrNo;
                            OpenFromCompanyPurchaseHeaderRec."Posting Date" := WorkDate();
                            OpenFromCompanyPurchaseHeaderRec."Document Date" := WorkDate();
                            OpenFromCompanyPurchaseHeaderRec."Order Date" := WorkDate();
                            OpenFromCompanyPurchaseHeaderRec."VAT Reporting Date" := WorkDate();
                            //DX        24 Oct 2025
                            PayTermRec.reset;
                            PayTermRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName);
                            PayTermRec.SetLoadFields(Code, "Due Date Calculation");
                            PayTermRec.SetRange(Code, OpenFromCompanyPurchaseHeaderRec."Payment Terms Code");
                            if PayTermRec.FindFirst() then begin
                                OpenFromCompanyPurchaseHeaderRec."Due Date" := CalcDate(PayTermRec."Due Date Calculation", WorkDate());
                            end;
                            //DX        24 Oct 2025
                            OpenFromCompanyPurchaseHeaderRec.Receive := true;
                            OpenFromCompanyPurchaseHeaderRec.Invoice := false;
                            OpenFromCompanyPurchaseHeaderRec.Modify(true);
                            Commit();
                        end else begin
                            Error('The purchase order document is not found in the %1.', PurchaseHeader.I9G_FromCompanyName);
                        end;
                    end;

                    FromCompanyPurchaseLineRec.Reset();
                    if FromCompanyPurchaseLineRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                        FromCompanyPurchaseLineRec.SetRange("Document Type", PurchaseLineRec."Document Type");
                        FromCompanyPurchaseLineRec.SetRange("Document No.", PurchaseHeader.I9G_PONo);
                        FromCompanyPurchaseLineRec.SetRange("Line No.", PurchaseLineRec."Line No.");
                        if FromCompanyPurchaseLineRec.FindFirst() then begin
                            FromCompanyPurchaseLineRec."Order Qty" := PurchaseLineRec."Order Qty";
                            FromCompanyPurchaseLineRec.Quantity := PurchaseLineRec.Quantity;
                            FromCompanyPurchaseLineRec."Quantity (Base)" := PurchaseLineRec."Quantity (Base)";
                            FromCompanyPurchaseLineRec."Qty. to Receive" := PurchaseLineRec."Quantity Received" - FromCompanyPurchaseLineRec."Quantity Received";
                            FromCompanyPurchaseLineRec.Modify(false);
                        end else begin
                            Error('The purchase line is not found in the %1.', PurchaseHeader.I9G_FromCompanyName);
                        end;
                    end;
                until PurchaseLineRec.Next() = 0;
                Commit();

                FromCompanyPurchaseHeaderRec.Reset();
                if FromCompanyPurchaseHeaderRec.ChangeCompany(PurchaseHeader.I9G_FromCompanyName) then begin
                    FromCompanyPurchaseHeaderRec.SetRange("Document Type", PurchaseHeader."Document Type");
                    FromCompanyPurchaseHeaderRec.SetRange("No.", PurchaseHeader.I9G_PONo);
                    if FromCompanyPurchaseHeaderRec.FindFirst() then begin
                        CreateJobQueueForPostPurchaseReceive(PurchaseHeader.I9G_FromCompanyName, FromCompanyPurchaseHeaderRec.RecordId);
                    end;
                end else begin
                    Error('Unable to post purhcase receive.\nThe purchase order document is not found in the %1.', PurchaseHeader.I9G_FromCompanyName);
                end;
            end;
        end;
    end;

    procedure CreateJobQueueForPostPurchaseReceive(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80132;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Post Purchase Receive';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueForUndoPurchaseReceipt(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80133;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Undo Purchase Receipt Lines';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueToCreatePurchWhseReceipt(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80138;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Create Purch. Whse. Receipt';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    /*Event Subsribers - Sales*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure "SalesPostOnAfterPostSalesDoc"(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        SalesLineRec: Record "Sales Line";
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        FromCompanySalesHeaderRec: Record "Sales Header";
        OpenFromCompanySalesHeaderRec: Record "Sales Header";
        FromCompanySalesLineRec: Record "Sales Line";
        FromCompanyReservationEntryRec: Record "Reservation Entry";
        ReservationEntryLineNoRec: Record "Reservation Entry";
        ItemLedgerEntryRec: Record "Item Ledger Entry" temporary;
        SaleCrMemoLineRec: Record "Sales Cr.Memo Line";
        LineNo: Integer;
    begin
        if SalesHeader.I9G_FromCompanyName <> '' then begin
            if SalesShptHdrNo <> '' then begin
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                if SalesLineRec.FindSet() then begin
                    OpenFromCompanySalesHeaderRec.Reset();
                    if OpenFromCompanySalesHeaderRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                        OpenFromCompanySalesHeaderRec.SetRange("Document Type", SalesHeader."Document Type");
                        OpenFromCompanySalesHeaderRec.SetRange("No.", SalesHeader."No.");
                        if OpenFromCompanySalesHeaderRec.FindFirst() then begin
                            if OpenFromCompanySalesHeaderRec.Status <> OpenFromCompanySalesHeaderRec.Status::Open then begin
                                OpenFromCompanySalesHeaderRec.Status := OpenFromCompanySalesHeaderRec.Status::Open;
                                OpenFromCompanySalesHeaderRec."Posting Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Document Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Order Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."VAT Reporting Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Due Date" := CalcDate(OpenFromCompanySalesHeaderRec."Payment Terms Code", WorkDate());
                                OpenFromCompanySalesHeaderRec.Modify(true);
                                Commit();
                            end;
                        end;
                    end;
                    repeat
                        FromCompanySalesLineRec.Reset();
                        if FromCompanySalesLineRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                            FromCompanySalesLineRec.SetRange("Document Type", SalesLineRec."Document Type");
                            FromCompanySalesLineRec.SetRange("Document No.", SalesHeader.I9G_SONo);
                            FromCompanySalesLineRec.SetRange("Line No.", SalesLineRec."Line No.");
                            if FromCompanySalesLineRec.FindFirst() then begin
                                FromCompanySalesLineRec.Quantity := SalesLineRec.Quantity;
                                FromCompanySalesLineRec."Quantity (Base)" := SalesLineRec."Quantity (Base)";
                                FromCompanySalesLineRec."Qty. to Invoice" := SalesLineRec."Quantity Invoiced" - FromCompanySalesLineRec."Quantity Invoiced";
                                FromCompanySalesLineRec."Qty. to Ship" := SalesLineRec."Quantity Shipped" - FromCompanySalesLineRec."Quantity Shipped";
                                FromCompanySalesLineRec.Modify(false);
                            end else begin
                                Error('The sales line is not found in the %1.', SalesHeader.I9G_FromCompanyName);
                            end;
                        end;
                    until SalesLineRec.Next() = 0;
                    Commit();

                    FromCompanySalesHeaderRec.Reset();
                    if FromCompanySalesHeaderRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                        FromCompanySalesHeaderRec.SetRange("Document Type", SalesHeader."Document Type");
                        FromCompanySalesHeaderRec.SetRange("No.", SalesHeader."No.");
                        if FromCompanySalesHeaderRec.FindFirst() then begin
                            if SalesShptHdrNo <> '' then begin
                                FromCompanySalesHeaderRec.I9G_ShipmentNo := SalesShptHdrNo;
                                FromCompanySalesHeaderRec.Ship := true;
                            end;
                            FromCompanySalesHeaderRec.Modify(true);
                            Commit();
                            if FromCompanySalesHeaderRec.Ship = true then
                                CreateJobQueueForPostSalesShipment(SalesHeader.I9G_FromCompanyName, FromCompanySalesHeaderRec.RecordId);
                        end else begin
                            Error('The sales %1 document is not found in the %2.', SalesHeader."Document Type".Names, SalesHeader.I9G_FromCompanyName);
                        end;
                    end;
                end;
            end;
            if SalesInvHdrNo <> '' then begin
                SalesInvoiceLineRec.Reset();
                SalesInvoiceLineRec.SetRange("Document No.", SalesInvHdrNo);
                if SalesInvoiceLineRec.FindSet() then begin
                    OpenFromCompanySalesHeaderRec.Reset();
                    if OpenFromCompanySalesHeaderRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                        OpenFromCompanySalesHeaderRec.SetRange("Document Type", SalesHeader."Document Type");
                        OpenFromCompanySalesHeaderRec.SetRange("No.", SalesHeader."No.");
                        if OpenFromCompanySalesHeaderRec.FindFirst() then begin
                            if OpenFromCompanySalesHeaderRec.Status <> OpenFromCompanySalesHeaderRec.Status::Open then begin
                                OpenFromCompanySalesHeaderRec.Status := OpenFromCompanySalesHeaderRec.Status::Open;
                                OpenFromCompanySalesHeaderRec."Posting Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Document Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Order Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."VAT Reporting Date" := WorkDate();
                                OpenFromCompanySalesHeaderRec."Due Date" := CalcDate(OpenFromCompanySalesHeaderRec."Payment Terms Code", WorkDate());
                                OpenFromCompanySalesHeaderRec.Modify(true);
                                Commit();
                            end;
                        end;
                    end;
                    repeat
                        FromCompanySalesLineRec.Reset();
                        if FromCompanySalesLineRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                            FromCompanySalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                            FromCompanySalesLineRec.SetRange("Document No.", SalesHeader.I9G_SONo);
                            FromCompanySalesLineRec.SetRange("Line No.", SalesInvoiceLineRec."Line No.");
                            if FromCompanySalesLineRec.FindFirst() then begin
                                FromCompanySalesLineRec."Qty. to Invoice" := SalesInvoiceLineRec.Quantity;
                                FromCompanySalesLineRec.Modify(false);
                            end else begin
                                Error('The sales line is not found in the %1.', SalesHeader.I9G_FromCompanyName);
                            end;
                        end;
                    until SalesInvoiceLineRec.Next() = 0;
                    Commit();

                    FromCompanySalesHeaderRec.Reset();
                    if FromCompanySalesHeaderRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                        FromCompanySalesHeaderRec.SetRange("Document Type", SalesHeader."Document Type");
                        FromCompanySalesHeaderRec.SetRange("No.", SalesHeader."No.");
                        if FromCompanySalesHeaderRec.FindFirst() then begin
                            FromCompanySalesHeaderRec.I9G_InvoiceNo := SalesInvHdrNo;
                            FromCompanySalesHeaderRec.Invoice := true;
                            FromCompanySalesHeaderRec.Modify(true);
                            Commit();
                            CreateJobQueueForPostSalesInvoice(SalesHeader.I9G_FromCompanyName, FromCompanySalesHeaderRec.RecordId);
                        end else begin
                            Error('The sales %1 document is not found in the %2.', SalesHeader."Document Type".Names, SalesHeader.I9G_FromCompanyName);
                        end;
                    end;
                end;
            end;
            if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") and (SalesCrMemoHdrNo <> '') then begin
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                if not SalesLineRec.FindFirst() then begin
                    FromCompanySalesHeaderRec.Reset();
                    if FromCompanySalesHeaderRec.ChangeCompany(SalesHeader.I9G_FromCompanyName) then begin
                        FromCompanySalesHeaderRec.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                        FromCompanySalesHeaderRec.SetRange("No.", SalesHeader.I9G_SONo);
                        if FromCompanySalesHeaderRec.FindFirst() then begin
                            FromCompanySalesHeaderRec.I9G_CreditMemoNo := SalesCrMemoHdrNo;
                            FromCompanySalesHeaderRec.Invoice := true;
                            FromCompanySalesHeaderRec.Receive := true;
                            FromCompanySalesHeaderRec.Modify(true);
                            Commit();
                            CreateJobQueueForPostSalesCrMemo(SalesHeader.I9G_FromCompanyName, FromCompanySalesHeaderRec.RecordId);
                        end else begin
                            Error('The sales %1 document is not found in the %2.', SalesHeader."Document Type".Names, SalesHeader.I9G_FromCompanyName);
                        end;
                    end;
                end
            end;
        end;
    end;

    procedure GetItemLedgerEntryRec(var TempItemLedgerEntryRec: Record "Item Ledger Entry" temporary; par_DocumentType: Enum "Sales Document Type"; par_DocumentNo: Code[20]; par_SalesLineNo: Integer)
    var
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ReturnReceiptHeaderRec: Record "Return Receipt Header";
    begin
        TempItemLedgerEntryRec.Reset();
        TempItemLedgerEntryRec.DeleteAll();

        if par_DocumentType = par_DocumentType::Order then begin
            ItemLedgerEntryRec.Reset();
            ItemLedgerEntryRec.SetRange("Entry Type", ItemLedgerEntryRec."Entry Type"::Sale);
            ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Shipment");
            ItemLedgerEntryRec.SetRange("Document No.", par_DocumentNo);
            ItemLedgerEntryRec.SetRange("Document Line No.", par_SalesLineNo);
            ItemLedgerEntryRec.SetFilter("Lot No.", '<>%1', '');
            if ItemLedgerEntryRec.FindSet() then begin
                repeat
                    TempItemLedgerEntryRec.Init();
                    TempItemLedgerEntryRec := ItemLedgerEntryRec;
                    TempItemLedgerEntryRec.Insert();
                until ItemLedgerEntryRec.Next() = 0;
            end;
        end;

        if par_DocumentType = par_DocumentType::"Return Order" then begin
            ReturnReceiptHeaderRec.Reset();
            ReturnReceiptHeaderRec.SetRange("Return Order No.", par_DocumentNo);
            if ReturnReceiptHeaderRec.FindSet() then begin
                repeat
                    ItemLedgerEntryRec.Reset();
                    ItemLedgerEntryRec.SetRange("Entry Type", ItemLedgerEntryRec."Entry Type"::Sale);
                    ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Return Receipt");
                    ItemLedgerEntryRec.SetRange("Document No.", ReturnReceiptHeaderRec."No.");
                    ItemLedgerEntryRec.SetRange("Document Line No.", par_SalesLineNo);
                    ItemLedgerEntryRec.SetFilter("Lot No.", '<>%1', '');
                    if ItemLedgerEntryRec.FindSet() then begin
                        repeat
                            TempItemLedgerEntryRec.Init();
                            TempItemLedgerEntryRec := ItemLedgerEntryRec;
                            TempItemLedgerEntryRec.Insert();
                        until ItemLedgerEntryRec.Next() = 0;
                    end;
                until ReturnReceiptHeaderRec.Next() = 0;
            end;
        end;
    end;

    procedure CreateJobQueueForPostSalesShipment(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80134;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Post Sales Shipment';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueForPostSalesInvoice(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80136;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Post Sales Invoice';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueForPostSalesCrMemo(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80137;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Post Sales Credit Memo';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueForUndoSalesShipment(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80135;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Undo Sales Shipment Lines';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueForSalesWhseShipmentAndPick(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80139;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec."Maximum No. of Attempts to Run" := 3;     //DX        28 Oct 2025
            JobQueueEntryRec."Rerun Delay (sec.)" := 120;               //DX        28 Oct 2025
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Create Sales Whse. Shipment';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueToCreateSalesWhseReceipt(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80140;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Create Sales. Whse. Receipt';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    procedure CreateJobQueueToPostSalesDocument(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80143;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Post Sales Document';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    /*Event Subsribers - Transfer*/
    procedure I9G_CreateTransWhseShipAndPick(par_CompanyName: Text[250]; par_RecordID: RecordId)
    var
        JobQueueEntryRec: Record "Job Queue Entry";
    begin
        if JobQueueEntryRec.ChangeCompany(par_CompanyName) then begin
            JobQueueEntryRec.Init();
            JobQueueEntryRec."Object Type to Run" := JobQueueEntryRec."Object Type to Run"::Codeunit;
            JobQueueEntryRec."Object ID to Run" := 80142;
            JobQueueEntryRec."Record ID to Process" := par_RecordID;
            JobQueueEntryRec."Job Queue Category Code" := 'DOCPOST';
            JobQueueEntryRec."Run in User Session" := false;
            JobQueueEntryRec.Status := JobQueueEntryRec.Status::Ready;
            JobQueueEntryRec.Description := 'Novem-PMP 3PL Create Trans. Whse. Shipment And Pick';
            JobQueueEntryRec.Insert(true);
            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntryRec);
        end else begin
            Error('Company %1 does not exists.', par_CompanyName);
        end;
    end;

    /*Event Subsribers - Customized*/
    procedure UpdateInvNoAtNovem(Input: code[20]; Val: code[20])
    var
        myInt: Integer;
        PSIRec: Record "Sales Invoice Header";
    begin
        PSIRec.reset;
        PSIRec.SetRange("No.", Input);
        if PSIRec.FindFirst() then begin
            PSIRec.I9G_InvoiceNo := Val;
            PSIRec.Modify(false);
        end;
    end;

    procedure UpdateShipNoAtNovem(Input: code[20]; Val: code[20])
    var
        myInt: Integer;
        PSIRec: Record "Sales Shipment Header";
    begin
        PSIRec.reset;
        PSIRec.SetRange("No.", Input);
        if PSIRec.FindFirst() then begin
            PSIRec.I9G_ShipmentNo := Val;
            PSIRec.Modify(false);
        end;
    end;

    procedure UpdateSalesInvoice(par_SONO: Code[20]; par_InvoiceNo: Code[20]; par_ShipmentNo: Code[20]; par_FromCompanyName: Text)
    var
        FromCompanySalesInvoiceHeaderRec: Record "Sales Invoice Header";
    begin
        FromCompanySalesInvoiceHeaderRec.Reset();
        if FromCompanySalesInvoiceHeaderRec.ChangeCompany(par_FromCompanyName) then begin
            FromCompanySalesInvoiceHeaderRec.SetRange(I9G_SONo, par_SONO);
            if FromCompanySalesInvoiceHeaderRec.FindFirst() then begin
                FromCompanySalesInvoiceHeaderRec.I9G_InvoiceNo := par_InvoiceNo;
                FromCompanySalesInvoiceHeaderRec.I9G_ShipmentNo := par_ShipmentNo;
                FromCompanySalesInvoiceHeaderRec.Modify(false);
            end;
        end;
    end;

    procedure UpdateSalesShipment(par_SONO: Code[20]; par_InvoiceNo: Code[20]; par_ShipmentNo: Code[20]; par_FromCompanyName: Text)
    var
        FromCompanySalesShipmentHeaderRec: Record "Sales Shipment Header";
    begin
        FromCompanySalesShipmentHeaderRec.Reset();
        if FromCompanySalesShipmentHeaderRec.ChangeCompany(par_FromCompanyName) then begin
            FromCompanySalesShipmentHeaderRec.SetRange(I9G_SONo, par_SONO);
            if FromCompanySalesShipmentHeaderRec.FindFirst() then begin
                FromCompanySalesShipmentHeaderRec.I9G_InvoiceNo := par_InvoiceNo;
                FromCompanySalesShipmentHeaderRec.I9G_ShipmentNo := par_ShipmentNo;
                FromCompanySalesShipmentHeaderRec.Modify(false);
            end;
        end;
    end;

    procedure UpdateInvoiceNoPMP(var SIHRec: Record "Sales Invoice Header")
    var
        myInt: Integer;
        LSIHRec: Record "Sales Invoice Header";
    begin
        LSIHRec.reset;
        LSIHRec.ChangeCompany(SIHRec.I9G_FromCompanyName);
        LSIHRec.SetLoadFields("Order No.", "No.");
        LSIHRec.SetRange("Order No.", SIHRec."Order No.");
        if LSIHRec.FindFirst() then begin
            SIHRec.I9G_InvoiceNo := LSIHRec."No.";
            SIHRec.Modify(false);
        end;
    end;

    procedure UpdateSpecialOrder()
    var
        PostedSalesInvoiceHeaderRec: Record "Sales Invoice Header";
        PostedSalesShipmentHeaderRec: Record "Sales Shipment Header";
    begin
        PostedSalesInvoiceHeaderRec.SetRange("No.", 'NHINV-2511-0047');
        if PostedSalesInvoiceHeaderRec.FindFirst() then begin
            PostedSalesInvoiceHeaderRec.I9G_InvoiceNo := 'SI-25-116609';
            PostedSalesInvoiceHeaderRec.Modify();
        end;

        PostedSalesShipmentHeaderRec.SetRange("No.", 'NHDO-2510-0058');
        if PostedSalesShipmentHeaderRec.FindFirst() then begin
            PostedSalesShipmentHeaderRec.I9G_InvoiceNo := 'SI-25-116609';
            PostedSalesShipmentHeaderRec.Modify();
        end;
    end;

    procedure InsertAssignmentLedgerEntry()
    var
        AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
        InsertAssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
        EntryNo: Integer;
    begin
        Clear(EntryNo);
        AssignmentLedgerEntryRec.Reset();
        if AssignmentLedgerEntryRec.FindLast() then begin
            EntryNo := AssignmentLedgerEntryRec."Entry No." + 1;
        end;
        InsertAssignmentLedgerEntryRec.Reset();
        InsertAssignmentLedgerEntryRec.Init();
        InsertAssignmentLedgerEntryRec."Entry No." := EntryNo;
        InsertAssignmentLedgerEntryRec.Basket := '508';
        InsertAssignmentLedgerEntryRec."Document No." := 'NHSO-2510-0910';
        InsertAssignmentLedgerEntryRec."Trip Doc No." := '';
        InsertAssignmentLedgerEntryRec."Picking Doc No." := 'WPL-25-124760';
        InsertAssignmentLedgerEntryRec."Customer No." := 'N071';
        InsertAssignmentLedgerEntryRec."Customer Name" := 'NOVEM HEALTHCARE PTE LTD';
        InsertAssignmentLedgerEntryRec.Status := InsertAssignmentLedgerEntryRec.Status::Completed;
        InsertAssignmentLedgerEntryRec.Picker := 'EDMUND.PAU';
        InsertAssignmentLedgerEntryRec."Checking Doc No." := 'WPL-25-124760';
        InsertAssignmentLedgerEntryRec."Checker ID" := 'OPS.BERNARD';
        InsertAssignmentLedgerEntryRec."Pick Type" := InsertAssignmentLedgerEntryRec."Pick Type"::"Non-Cold";
        InsertAssignmentLedgerEntryRec."Invoice No." := 'SI-25-116609';
        InsertAssignmentLedgerEntryRec.Insert(false);
    end;

    procedure UpdateExpirationDate()
    var
        ReservationEntryRec: Record "Reservation Entry";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        WarehouseEntriesRec: Record "Warehouse Entry";
    begin
        ReservationEntryRec.Reset();
        ReservationEntryRec.SetRange("Item No.", '314MA011');
        ReservationEntryRec.SetFilter("Source ID", '%1|%2', 'NHSO-2511-0128', 'NHSO-2511-0058');
        ReservationEntryRec.SetFilter("Entry No.", '%1|%2', 9012491, 9022095);
        if ReservationEntryRec.FindSet() then begin
            repeat
                ReservationEntryRec."Expiration Date" := DMY2DATE(31, 12, 2027);
                ReservationEntryRec.Modify();
            until ReservationEntryRec.Next() = 0;
        end;
        ItemLedgerEntryRec.Reset();
        ItemLedgerEntryRec.SetRange("Item No.", '314MA011');
        ItemLedgerEntryRec.SetRange("Lot No.", '2402512');
        ItemLedgerEntryRec.SetRange(Open, true);
        if ItemLedgerEntryRec.FindSet() then begin
            repeat
                ItemLedgerEntryRec."Expiration Date" := DMY2DATE(31, 12, 2027);
                ItemLedgerEntryRec.Modify();
            until ItemLedgerEntryRec.Next() = 0;
        end;

        WarehouseEntriesRec.Reset();
        WarehouseEntriesRec.SetRange("Item No.", '314MA011');
        WarehouseEntriesRec.SetRange("Lot No.", '2402512');
        if WarehouseEntriesRec.FindSet() then begin
            repeat
                WarehouseEntriesRec."Expiration Date" := DMY2DATE(31, 12, 2027);
                WarehouseEntriesRec.Modify();
            until WarehouseEntriesRec.Next() = 0;
        end;
    end;

    procedure ShowNovemCustomerDetailsFromShipTo(par_CheckingHeaderRec: Record "Checking Header")
    var
        SalesInvoiceHeaderRec: Record "Sales Invoice Header";
        AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
        SalesHeaderRec: Record "Sales Header";
        NovemShipToAddressRec: Record "Ship-to Address";
        NovemSalesInvoiceHeaderRec: Record "Sales Invoice Header";
        NovemSalesHeaderRec: Record "Sales Header";
    begin
        /*Get Novem Customer Details from Novem Ship-to details*/
        par_CheckingHeaderRec.I9G_NovemCustomerName := '';
        par_CheckingHeaderRec.I9G_NovemShipToCustomerName := '';
        par_CheckingHeaderRec.I9G_NovemShipToCustomerName2 := '';
        par_CheckingHeaderRec.I9G_NovemCustomerAddress := '';
        par_CheckingHeaderRec.I9G_NovemCustomerAddress2 := '';
        par_CheckingHeaderRec.I9G_NovemCustomerAddress3 := '';
        par_CheckingHeaderRec.I9G_NovemCustomerOpsHr := '';
        par_CheckingHeaderRec.I9G_NovemCustomerDelInstr := '';
        AssignmentLedgerEntryRec.Reset();
        AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.", "Document No.");
        AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.", "Document No.");
        AssignmentLedgerEntryRec.SetRange("Picking Doc No.", par_CheckingHeaderRec."No.");
        if AssignmentLedgerEntryRec.FindFirst() then begin
            SalesInvoiceHeaderRec.Reset();
            SalesInvoiceHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
            SalesInvoiceHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
            SalesInvoiceHeaderRec.SetFilter(I9G_CustVendName, '<>%1', '');
            SalesInvoiceHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
            if SalesInvoiceHeaderRec.FindFirst() then begin
                NovemSalesInvoiceHeaderRec.Reset();
                if NovemSalesInvoiceHeaderRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                    NovemSalesInvoiceHeaderRec.SetRange(I9G_SONo, SalesInvoiceHeaderRec.I9G_SONo);
                    if NovemSalesInvoiceHeaderRec.FindFirst() then begin
                        NovemShipToAddressRec.Reset();
                        if NovemShipToAddressRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                            NovemShipToAddressRec.SetRange("Customer No.", NovemSalesInvoiceHeaderRec."Sell-to Customer No.");
                            NovemShipToAddressRec.SetRange(Code, NovemSalesInvoiceHeaderRec."Ship-to Code");
                            if NovemShipToAddressRec.FindFirst() then begin
                                par_CheckingHeaderRec.I9G_NovemCustomerName := NovemSalesInvoiceHeaderRec."Sell-to Customer Name";
                                par_CheckingHeaderRec."Delivery Charge" := NovemShipToAddressRec.I9G_DeliveryCharge;
                                par_CheckingHeaderRec."Shipping Bin" := NovemShipToAddressRec.I9G_DeliveryZone;
                                par_CheckingHeaderRec.I9G_NovemShipToCustomerName := NovemShipToAddressRec.Name;
                                par_CheckingHeaderRec.I9G_NovemShipToCustomerName2 := NovemShipToAddressRec."Name 2";
                                par_CheckingHeaderRec.I9G_NovemCustomerAddress := NovemShipToAddressRec.Address;
                                par_CheckingHeaderRec.I9G_NovemCustomerAddress2 := NovemShipToAddressRec."Address 2";
                                par_CheckingHeaderRec.I9G_NovemCustomerOpsHr := NovemShipToAddressRec.I9G_Address3;
                                par_CheckingHeaderRec.I9G_NovemCustomerDelInstr := NovemSalesInvoiceHeaderRec."Delivery Instructions";
                                SalesInvoiceHeaderRec.I9G_NovemCustNoOfCopies := NovemShipToAddressRec.I9G_NovemCustNoOfCopies;
                                SalesInvoiceHeaderRec.Modify();
                            end;
                        end;
                    end else begin
                        NovemSalesHeaderRec.Reset();
                        if NovemSalesHeaderRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                            NovemSalesHeaderRec.SetRange(I9G_SONo, SalesInvoiceHeaderRec.I9G_SONo);
                            if NovemSalesHeaderRec.FindFirst() then begin
                                NovemShipToAddressRec.Reset();
                                if NovemShipToAddressRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                                    NovemShipToAddressRec.SetRange("Customer No.", NovemSalesHeaderRec."Sell-to Customer No.");
                                    NovemShipToAddressRec.SetRange(Code, NovemSalesHeaderRec."Ship-to Code");
                                    if NovemShipToAddressRec.FindFirst() then begin
                                        par_CheckingHeaderRec.I9G_NovemCustomerName := NovemSalesHeaderRec."Sell-to Customer Name";
                                        par_CheckingHeaderRec."Delivery Charge" := NovemShipToAddressRec.I9G_DeliveryCharge;
                                        par_CheckingHeaderRec."Shipping Bin" := NovemShipToAddressRec.I9G_DeliveryZone;
                                        par_CheckingHeaderRec.I9G_NovemShipToCustomerName := NovemShipToAddressRec.Name;
                                        par_CheckingHeaderRec.I9G_NovemShipToCustomerName2 := NovemShipToAddressRec."Name 2";
                                        par_CheckingHeaderRec.I9G_NovemCustomerAddress := NovemShipToAddressRec.Address;
                                        par_CheckingHeaderRec.I9G_NovemCustomerAddress2 := NovemShipToAddressRec."Address 2";
                                        par_CheckingHeaderRec.I9G_NovemCustomerOpsHr := NovemShipToAddressRec.I9G_Address3;
                                        par_CheckingHeaderRec.I9G_NovemCustomerDelInstr := NovemSalesHeaderRec."Delivery Instructions";
                                        SalesInvoiceHeaderRec.I9G_NovemCustNoOfCopies := NovemShipToAddressRec.I9G_NovemCustNoOfCopies;
                                        SalesInvoiceHeaderRec.Modify();
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end else begin
                SalesHeaderRec.Reset();
                SalesHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Document No.");
                SalesHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
                SalesHeaderRec.SetFilter(I9G_CustVendName, '<>%1', '');
                SalesHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
                if SalesHeaderRec.FindFirst() then begin
                    NovemSalesHeaderRec.Reset();
                    if NovemSalesHeaderRec.ChangeCompany(SalesHeaderRec.I9G_FromCompanyName) then begin
                        NovemSalesHeaderRec.SetRange(I9G_SONo, SalesHeaderRec.I9G_SONo);
                        if NovemSalesHeaderRec.FindFirst() then begin
                            NovemShipToAddressRec.Reset();
                            if NovemShipToAddressRec.ChangeCompany(SalesHeaderRec.I9G_FromCompanyName) then begin
                                NovemShipToAddressRec.SetRange("Customer No.", NovemSalesHeaderRec."Sell-to Customer No.");
                                NovemShipToAddressRec.SetRange(Code, NovemSalesHeaderRec."Ship-to Code");
                                if NovemShipToAddressRec.FindFirst() then begin
                                    par_CheckingHeaderRec.I9G_NovemCustomerName := NovemSalesHeaderRec."Sell-to Customer Name";
                                    par_CheckingHeaderRec."Delivery Charge" := NovemShipToAddressRec.I9G_DeliveryCharge;
                                    par_CheckingHeaderRec."Shipping Bin" := NovemShipToAddressRec.I9G_DeliveryZone;
                                    par_CheckingHeaderRec.I9G_NovemShipToCustomerName := NovemShipToAddressRec.Name;
                                    par_CheckingHeaderRec.I9G_NovemShipToCustomerName2 := NovemShipToAddressRec."Name 2";
                                    par_CheckingHeaderRec.I9G_NovemCustomerAddress := NovemShipToAddressRec.Address;
                                    par_CheckingHeaderRec.I9G_NovemCustomerAddress2 := NovemShipToAddressRec."Address 2";
                                    par_CheckingHeaderRec.I9G_NovemCustomerOpsHr := NovemShipToAddressRec.I9G_Address3;
                                    par_CheckingHeaderRec.I9G_NovemCustomerDelInstr := NovemSalesHeaderRec."Delivery Instructions";
                                    SalesHeaderRec.I9G_NovemCustNoOfCopies := NovemShipToAddressRec.I9G_NovemCustNoOfCopies;
                                    SalesHeaderRec.Modify();
                                end;
                            end;
                        end;
                    end;
                end else begin
                    NovemSalesInvoiceHeaderRec.Reset();
                    if NovemSalesInvoiceHeaderRec.ChangeCompany(SalesHeaderRec.I9G_FromCompanyName) then begin
                        NovemSalesInvoiceHeaderRec.SetRange(I9G_SONo, SalesHeaderRec.I9G_SONo);
                        if NovemSalesInvoiceHeaderRec.FindFirst() then begin
                            NovemShipToAddressRec.Reset();
                            if NovemShipToAddressRec.ChangeCompany(SalesHeaderRec.I9G_FromCompanyName) then begin
                                NovemShipToAddressRec.SetRange("Customer No.", NovemSalesInvoiceHeaderRec."Sell-to Customer No.");
                                NovemShipToAddressRec.SetRange(Code, NovemSalesInvoiceHeaderRec."Ship-to Code");
                                if NovemShipToAddressRec.FindFirst() then begin
                                    par_CheckingHeaderRec.I9G_NovemCustomerName := NovemSalesInvoiceHeaderRec."Sell-to Customer Name";
                                    par_CheckingHeaderRec."Delivery Charge" := NovemShipToAddressRec.I9G_DeliveryCharge;
                                    par_CheckingHeaderRec."Shipping Bin" := NovemShipToAddressRec.I9G_DeliveryZone;
                                    par_CheckingHeaderRec.I9G_NovemShipToCustomerName := NovemShipToAddressRec.Name;
                                    par_CheckingHeaderRec.I9G_NovemShipToCustomerName2 := NovemShipToAddressRec."Name 2";
                                    par_CheckingHeaderRec.I9G_NovemCustomerAddress := NovemShipToAddressRec.Address;
                                    par_CheckingHeaderRec.I9G_NovemCustomerAddress2 := NovemShipToAddressRec."Address 2";
                                    par_CheckingHeaderRec.I9G_NovemCustomerOpsHr := NovemShipToAddressRec.I9G_Address3;
                                    par_CheckingHeaderRec.I9G_NovemCustomerDelInstr := NovemSalesInvoiceHeaderRec."Delivery Instructions";
                                    SalesHeaderRec.I9G_NovemCustNoOfCopies := NovemShipToAddressRec.I9G_NovemCustNoOfCopies;
                                    SalesHeaderRec.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            par_CheckingHeaderRec.Modify();
        end;
    end;


    procedure CheckShipmentDate(SHRec: Record "Sales Header")
    var
        myInt: Integer;
    begin
        // YF 27 Nov 2025 // Disabled as instructed by Dixon
        /*
        if Today <= SHRec."Shipment Date" then
            Error('You cannot send this order to interco until today is %1 shipment date %2', Format(today), Format(SHRec."Shipment Date"));
        */
        // YF 27 Nov 2025 // Disabled as instructed by Dixon
    end;

    procedure TaskListNo3154()
    var
        ValueEntryRec: Record "Value Entry";
    begin
        ValueEntryRec.Reset();
        ValueEntryRec.SetRange("Entry No.", 30651);
        if ValueEntryRec.FindFirst() then begin
            ValueEntryRec."Sales Amount (Actual)" := 0;
            ValueEntryRec.Modify();
        end;
    end;

    procedure CheckPMPInvLineAnd3PLInvLine(InvNo: code[20]; FromCoyName: text[30])
    var
        myInt: Integer;
        PMPInv: code[20];
        PMPSHRec: record "Sales Invoice Header";
        NHCSHRec: record "Sales Invoice Header";
        PMPSLRec: record "Sales Invoice Line";
        PMPSLAmt: decimal;
        NHCSLAmt: decimal;
        NovemSLRec: Record "Sales Invoice Line";
        PMPSLCount: integer;
        NovemSLCount: integer;
    begin
        clear(PMPSLAmt);
        pmpshrec.reset;
        pmpshrec.SetLoadFields("No.", "Amount Including VAT");
        pmpshrec.setrange("No.", InvNo);
        pmpshrec.CalcFields("Amount Including VAT");
        PMPSLAmt := pmpshrec."Amount Including VAT";

        clear(NHCSLAmt);
        NHCSHRec.reset;
        nhcshrec.SetLoadFields("No.", "Amount Including VAT");
        NHCSHRec.ChangeCompany(FromCoyName);
        NHCSHRec.SetRange("No.", InvNo);
        NHCSHRec.CalcFields("Amount Including VAT");
        NHCSLAmt := NHCSHRec."Amount Including VAT";
        if PMPSLAmt <> NHCSLAmt then
            Message('The invoice %1 amount %2 is not same as the invoice amount %3 in %4.', InvNo, Format(PMPSLAmt), Format(NHCSLAmt), FromCoyName);

        clear(pmpslrec);
        clear(pmpslcount);
        clear(novemslrec);
        clear(novemslcount);
        PMPSLRec.reset;
        pmpslrec.SetCurrentKey("Document No.", type, "No.", quantity);
        PMPSLRec.SetLoadFields("Document No.", type, quantity);
        PMPSLRec.setrange("Document No.", InvNo);
        pmpslrec.SetRange(type, pmpslrec.Type::Item);
        pmpslrec.SetFilter(Quantity, '<>0');
        pmpslrec.SetFilter("No.", '<>%1', '');
        pmpslcount := pmpslrec.Count();

        NovemSLRec.reset;
        novemslrec.ChangeCompany(FromCoyName);
        novemslrec.SetCurrentKey("Document No.", type, "No.", quantity);
        novemslrec.SetLoadFields("Document No.", type, quantity);
        novemslrec.setrange("Document No.", InvNo);
        novemslrec.SetRange(type, novemslrec.Type::Item);
        NovemSLRec.SetFilter("No.", '<>%1', '');
        novemslrec.SetFilter(Quantity, '<>0');
        novemslcount := novemslrec.Count();

        if NovemSLCount <> PMPSLCount then
            Message('The invoice %1 line count %2 is not same as the invoice line count %3 in %4.', InvNo, Format(PMPSLCount), Format(NovemSLCount), FromCoyName);
    end;
}