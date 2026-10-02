report 70050 I9G_SalesHistory
{
    DefaultRenderingLayout = "Novem - Sales History";
    Caption = 'Customer & Product Sales History';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("ItemLedgerEntry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.") where("Entry Type" = filter("Sale"));
            trigger OnAfterGetRecord()
            var
                ValueEntry: Record "Value Entry";
            begin
                Clear(InvNo);

                if (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment") OR
                    (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Invoice") then begin
                    ValueEntry.Reset();
                    ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                    ValueEntry.SetRange(Adjustment, false);
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                    if ValueEntry.FindFirst() then begin
                        InvNo := ValueEntry."Document No.";
                        InsertItemLedgerIntoTemp(ItemLedgerEntry);
                    end;

                end;
                if (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Credit Memo") OR
                    (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") then begin
                    ValueEntry.Reset();
                    ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                    ValueEntry.SetRange(Adjustment, false);
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
                    if ValueEntry.FindFirst() then begin
                        InsertItemLedgerIntoTemp(ItemLedgerEntry);
                    end;

                end;
            end;

            trigger OnPreDataItem()
            var
            begin
                SetFilter("Last Invoice Date", FilterDate);
                if FilterProductNo <> '' then
                    SetFilter("Item No.", FilterProductNo);
                if FilterCustomerNo <> '' then
                    SetFilter("Source No.", FilterCustomerNo);
                if FilterSalesPersonNo <> '' then
                    SetFilter("Shortcut Dimension 7 Code", FilterSalesPersonNo);
                SetRange("Source Type", "Source Type"::Customer);
            end;
        }
        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(ReportCaption; ReportCaption) { }
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(FilterOptions; FilterOptions) { }
            column(FilterDate; FilterDate) { }
            column(FilterCustomerNo; FilterCustomerNo) { }
            column(FilterProductNo; FilterProductNo) { }
            column(FilterSalesPersonNo; FilterSalesPersonNo) { }
            column(ItemNo; I9G_TempTableRec.Code1) { }
            column(ItemDescription; I9G_TempTableRec.Text1) { }
            column(ItemDescription2; I9G_TempTableRec.Text2) { }
            column(ItemGroupCode; I9G_TempTableRec.Code2) { }
            column(ItemGroupName; I9G_TempTableRec.Text3) { }
            column(UoMCode; I9G_TempTableRec.Code3) { }
            column(CustomerNo; I9G_TempTableRec.Code4) { }
            column(CustomerName; I9G_TempTableRec.Text4) { }
            column(DocumentDistrictCode; I9G_TempTableRec.Code5) { }
            column(DocumentPostalCode; I9G_TempTableRec.Code6) { }
            column(DocumentCaseDR; I9G_TempTableRec.Code7) { }
            column(DocumentCaseNo; I9G_TempTableRec.Code8) { }
            column(SalesQuantity; I9G_TempTableRec.Decimal1) { }
            column(FOCQuantity; I9G_TempTableRec.Decimal2) { }
            column(SalesAmount; I9G_TempTableRec.Decimal3) { }
            column(Salesperson; I9G_TempTableRec.Code9) { }
            column(ExecutionDateTime; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4> <Hours12,2>:<Minutes,2>:<Seconds,2> <AM/PM>')) { }
            trigger OnPreDataItem()
            begin
                I9G_TempTableRec.Reset();
                SetRange(Number, 1, I9G_TempTableRec.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    I9G_TempTableRec.FindFirst()
                else
                    I9G_TempTableRec.Next();
            end;

            trigger OnPostDataItem()
            begin
                I9G_TempTableRec.DeleteAll();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(FilterOptions; FilterOptions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Group By';
                        ToolTip = 'Specifies the value of the Options field.';
                        // Visible = false;
                    }
                    field(FilterDate; FilterDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date Range Filter';
                        ToolTip = 'Specifies the value of the Date Range filter field.';
                        ShowMandatory = true;
                        NotBlank = true;
                        trigger OnValidate()
                        var
                            FilterTokensCodeUnit: Codeunit "Filter Tokens";
                        begin
                            FilterTokensCodeUnit.MakeDateFilter(FilterDate);
                        end;
                    }
                    field(FilterProductNo; FilterProductNo)
                    {
                        Caption = 'Product Code';
                        Lookup = true;
                        DrillDown = true;
                        LookupPageId = "Item Lookup";
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemRec: Record Item;
                            ItemLookupPage: Page "Item Lookup";
                            RecRef: RecordRef;
                        begin
                            clear(FilterProductNo);
                            ItemLookupPage.SetTableView(ItemRec);
                            ItemLookupPage.LookupMode(true);
                            if ItemLookupPage.RunModal() = Action::LookupOK then begin
                                ItemLookupPage.SetSelectionFilter(ItemRec);
                                RecRef.GetTable(ItemRec);
                                FilterProductNo := I9G_NovemEventSubscribersCodeUnit.GetSelectionFilter(RecRef, ItemRec.FieldNo("No."));
                            end;
                        end;
                    }
                    field(FilterCustomerNo; FilterCustomerNo)
                    {
                        Caption = 'Customer Code';
                        Lookup = true;
                        DrillDown = true;
                        LookupPageId = "Customer Lookup";
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CustomerRec: Record Customer;
                            CustomerLookupPage: Page "Customer Lookup";
                            RecRef: RecordRef;
                        begin
                            clear(FilterCustomerNo);
                            CustomerLookupPage.SetTableView(CustomerRec);
                            CustomerLookupPage.LookupMode(true);
                            if CustomerLookupPage.RunModal() = Action::LookupOK then begin
                                CustomerLookupPage.SetSelectionFilter(CustomerRec);
                                RecRef.GetTable(CustomerRec);
                                FilterCustomerNo := I9G_NovemEventSubscribersCodeUnit.GetSelectionFilter(RecRef, CustomerRec.FieldNo("No."));
                            end;
                        end;
                    }
                    field(FilterSalesPersonNo; FilterSalesPersonNo)
                    {
                        Caption = 'Salesperson Code';
                        Lookup = true;
                        DrillDown = true;
                        LookupPageId = "Salespersons/Purchasers";
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            SalespersonPurchaserRec: Record "Salesperson/Purchaser";
                            SalespersonsPurchasersList: Page "Salespersons/Purchasers";
                            RecRef: RecordRef;
                        begin
                            clear(FilterSalesPersonNo);
                            SalespersonsPurchasersList.SetTableView(SalespersonPurchaserRec);
                            SalespersonsPurchasersList.LookupMode(true);
                            if SalespersonsPurchasersList.RunModal() = Action::LookupOK then begin
                                SalespersonsPurchasersList.SetSelectionFilter(SalespersonPurchaserRec);
                                RecRef.GetTable(SalespersonPurchaserRec);
                                FilterSalesPersonNo := I9G_NovemEventSubscribersCodeUnit.GetSelectionFilter(RecRef, SalespersonPurchaserRec.FieldNo(Code));
                            end;
                        end;
                    }
                }
            }
        }
    }
    rendering
    {
        layout("Novem - Sales History")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70050-SalesHistory.rdl';
        }
    }
    trigger OnInitReport()
    var
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    trigger OnPreReport()
    var
    begin
        Clear(ReportCaption);
        if FilterOptions = FilterOptions::Customer then begin
            ReportCaption := 'Customer Product Sales Report';
        end else begin
            ReportCaption := 'Product Customer Sales Report';
        end;
    end;

    local procedure InsertItemLedgerIntoTemp(par_ItemLedgerEntry: Record "Item Ledger Entry")
    var
        GetItemRec: Record Item;
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        DocumentDistrictCode: Code[20];
        DocumentPostalCode: Code[20];
        DocumentCaseNo: Code[150];
        DocumentCaseDR: Code[150];
        IsCrMm: Boolean;
    begin
        Clear(IsCrMm);

        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;
        GetItemRec.Reset();
        GetItemRec := GetItemRecord(par_ItemLedgerEntry."Item No.");
        GetDocumentRec(par_ItemLedgerEntry."Document Type", par_ItemLedgerEntry."Document No.", DocumentDistrictCode, DocumentPostalCode, DocumentCaseNo, DocumentCaseDR, IsCrMm);

        par_ItemLedgerEntry.CalcFields("Shortcut Dimension 4 Code", "Shortcut Dimension 7 Code");

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code1, par_ItemLedgerEntry."Item No.");
        //I9G_TempTableRec.SetRange(Code2, GetItemRec.I9G_ItemGroupCode);
        I9G_TempTableRec.SetRange(Code2, par_ItemLedgerEntry."Shortcut Dimension 4 Code");
        I9G_TempTableRec.SetRange(Code3, par_ItemLedgerEntry."Unit of Measure Code");
        I9G_TempTableRec.SetRange(Code4, par_ItemLedgerEntry."Source No.");
        I9G_TempTableRec.SetRange(Code5, DocumentDistrictCode);
        I9G_TempTableRec.SetRange(Code6, DocumentPostalCode);
        I9G_TempTableRec.SetRange(Code7, DocumentCaseDR);
        I9G_TempTableRec.SetRange(Code8, DocumentCaseNo);
        I9G_TempTableRec.SetRange(Code9, par_ItemLedgerEntry."Shortcut Dimension 7 Code");
        I9G_TempTableRec.SetRange(Boolean1, IsCrMm);
        if not I9G_TempTableRec.FindFirst() then begin
            if IsCrMm then begin
                I9G_TempTableRec.Reset();
                I9G_TempTableRec.Init();
                I9G_TempTableRec."Entry No." := EntryNo;
                I9G_TempTableRec.Code1 := par_ItemLedgerEntry."Item No.";
                I9G_TempTableRec.Text1 := GetItemRec.Description;
                I9G_TempTableRec.Text2 := GetItemRec."Description 2";
                //I9G_TempTableRec.Code2 := GetItemRec.I9G_ItemGroupCode;
                I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Shortcut Dimension 4 Code";
                I9G_TempTableRec.Text3 := GetItemGroupCodeDescription(par_ItemLedgerEntry."Shortcut Dimension 4 Code");
                I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Unit of Measure Code";
                I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Source No.";
                I9G_TempTableRec.Text4 := GetCustomerName(par_ItemLedgerEntry."Source No.");
                I9G_TempTableRec.Code5 := DocumentDistrictCode;
                I9G_TempTableRec.Code6 := DocumentPostalCode;
                I9G_TempTableRec.Code7 := DocumentCaseDR;
                I9G_TempTableRec.Code8 := DocumentCaseNo;
                I9G_TempTableRec.Code9 := par_ItemLedgerEntry."Shortcut Dimension 7 Code";
                par_ItemLedgerEntry.CalcFields("Sales Amount (Actual)");
                if par_ItemLedgerEntry."Sales Amount (Actual)" = 0 then begin
                    I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity * -1; //Abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
                end else begin
                    I9G_TempTableRec.Decimal1 := par_ItemLedgerEntry.Quantity * -1;//Abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
                    I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry."Sales Amount (Actual)";
                end;
                I9G_TempTableRec.Boolean1 := IsCrMm;
                I9G_TempTableRec.Insert();
            end
            else begin
                I9G_TempTableRec.Reset();
                I9G_TempTableRec.Init();
                I9G_TempTableRec."Entry No." := EntryNo;
                I9G_TempTableRec.Code1 := par_ItemLedgerEntry."Item No.";
                I9G_TempTableRec.Text1 := GetItemRec.Description;
                I9G_TempTableRec.Text2 := GetItemRec."Description 2";
                //I9G_TempTableRec.Code2 := GetItemRec.I9G_ItemGroupCode;
                I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Shortcut Dimension 4 Code";
                I9G_TempTableRec.Text3 := GetItemGroupCodeDescription(par_ItemLedgerEntry."Shortcut Dimension 4 Code");
                I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Unit of Measure Code";
                I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Source No.";
                I9G_TempTableRec.Text4 := GetCustomerName(par_ItemLedgerEntry."Source No.");
                I9G_TempTableRec.Code5 := DocumentDistrictCode;
                I9G_TempTableRec.Code6 := DocumentPostalCode;
                I9G_TempTableRec.Code7 := DocumentCaseDR;
                I9G_TempTableRec.Code8 := DocumentCaseNo;
                I9G_TempTableRec.Code9 := par_ItemLedgerEntry."Shortcut Dimension 7 Code";
                par_ItemLedgerEntry.CalcFields("Sales Amount (Actual)");
                if par_ItemLedgerEntry."Sales Amount (Actual)" = 0 then begin
                    I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity * -1; //Abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
                end else begin
                    I9G_TempTableRec.Decimal1 := par_ItemLedgerEntry.Quantity * -1;//Abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
                    I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry."Sales Amount (Actual)";
                end;
                I9G_TempTableRec.Insert();
            end;
        end else begin
            par_ItemLedgerEntry.CalcFields("Sales Amount (Actual)");
            if par_ItemLedgerEntry."Sales Amount (Actual)" = 0 then begin
                I9G_TempTableRec.Decimal2 += par_ItemLedgerEntry.Quantity * -1;//abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
            end else begin
                I9G_TempTableRec.Decimal1 += par_ItemLedgerEntry.Quantity * -1;//abs(par_ItemLedgerEntry.Quantity); //LK04Oct2024 remove abs
                I9G_TempTableRec.Decimal3 += par_ItemLedgerEntry."Sales Amount (Actual)";
            end;
            I9G_TempTableRec.Modify();
        end;
    end;

    local procedure GetItemRecord(par_ItemNo: Code[20]): Record Item
    var
        ItemRec: Record Item;
    begin
        ItemRec.Reset();
        ItemRec.SetRange("No.", par_ItemNo);
        if ItemRec.FindFirst() then begin
            exit(ItemRec);
        end;
    end;

    local procedure GetItemGroupCodeDescription(par_ItemGroupCode: Code[100]): Text[250]
    var
        //I9G_ItemGroupsRec: Record I9G_ItemGroups;
        DimensionValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
        DimensionValue.SetRange(Code, par_ItemGroupCode);
        if DimensionValue.FindFirst() then begin
            exit(DimensionValue.Name);
        end else begin
            exit('');
        end;

        /*
        I9G_ItemGroupsRec.Reset();
        I9G_ItemGroupsRec.SetRange(I9G_ItemGroupCode, par_ItemGroupCode);
        if I9G_ItemGroupsRec.FindFirst() then begin
            exit(I9G_ItemGroupsRec.I9G_ItemGroupDescription);
        end;
        */
    end;

    local procedure GetCustomerName(par_CustomerNo: Code[20]): Text[100]
    var
        CustomerRec: Record Customer;
    begin
        CustomerRec.Reset();
        CustomerRec.SetRange("No.", par_CustomerNo);
        if CustomerRec.FindFirst() then begin
            exit(CustomerRec.Name);
        end;
    end;

    local procedure GetDocumentRec(par_DocumentType: Enum "Item Ledger Document Type"; par_DocumentNo: Code[20]; var return_DistrictCode: Code[20]; var return_PostalCode: Code[20]; var return_CaseNo: Code[150]; var return_CaseDR: Code[150]; var IsCrMm: Boolean)
    var
        SalesShipmentHeaderRec: Record "Sales Shipment Header";
        SalesInvoiceHeaderRec: Record "Sales Invoice Header";
        ReturnReceiptHeaderRec: Record "Return Receipt Header";
        SalesCrMemoHeaderRec: Record "Sales Cr.Memo Header";
    begin
        case par_DocumentType OF
            par_DocumentType::"Sales Shipment",
            par_DocumentType::"Sales Invoice":
                begin
                    SalesInvoiceHeaderRec.Reset();
                    SalesInvoiceHeaderRec.SetRange("No.", InvNo);
                    if SalesInvoiceHeaderRec.FindFirst() then begin
                        return_DistrictCode := SalesInvoiceHeaderRec.I9G_ShipToDistrictCode;
                        return_PostalCode := SalesInvoiceHeaderRec."Ship-to Post Code";
                        return_CaseNo := SalesInvoiceHeaderRec.I9G_CaseNumber;
                        return_CaseDR := SalesInvoiceHeaderRec.I9G_CaseDoctor;
                        IsCrMm := false;
                    end;
                end;
            par_DocumentType::"Sales Return Receipt":
                begin
                    ReturnReceiptHeaderRec.Reset();
                    ReturnReceiptHeaderRec.SetRange("No.", par_DocumentNo);
                    if ReturnReceiptHeaderRec.FindFirst() then begin
                        return_DistrictCode := ReturnReceiptHeaderRec.I9G_ShipToDistrictCode;
                        return_PostalCode := ReturnReceiptHeaderRec."Ship-to Post Code";
                        return_CaseNo := ReturnReceiptHeaderRec.I9G_CaseNumber;
                        return_CaseDR := ReturnReceiptHeaderRec.I9G_CaseDoctor;
                        IsCrMm := false;
                    end;
                end;
            else begin
                SalesCrMemoHeaderRec.Reset();
                SalesCrMemoHeaderRec.SetRange("No.", par_DocumentNo);
                if SalesCrMemoHeaderRec.FindFirst() then begin
                    return_DistrictCode := SalesCrMemoHeaderRec.I9G_ShipToDistrictCode;
                    return_PostalCode := SalesCrMemoHeaderRec."Ship-to Post Code";
                    return_CaseNo := SalesCrMemoHeaderRec.I9G_CaseNumber;
                    return_CaseDR := SalesCrMemoHeaderRec.I9G_CaseDoctor;
                    IsCrMm := true;
                end;
            end;
        end;
    end;

    procedure GetReportOptionAndFilterText(par_FilterOption: Option "Product","Customer"; par_FilterText: Text)
    var
    begin
        FilterOptions := par_FilterOption;
        if FilterOptions = FilterOptions::Customer then begin
            FilterCustomerNo := par_FilterText;
        end else begin
            FilterProductNo := par_FilterText;
        end;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        I9G_TempTableRec: Record I9G_TempTable temporary;
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        EntryNo: Integer;
        FilterOptions: Option "Product","Customer";
        FilterDate: Text;
        FilterProductNo: Text;
        FilterCustomerNo: Text;
        FilterSalesPersonNo: Text;
        PeriodStartDate: array[6] of Date;
        PeriodEndDate: array[6] of Date;
        HeaderText: array[6] of Text;
        TotalQuantity: array[6] of Decimal;
        TotalAmount: array[6] of Decimal;
        ReportCaption: Text[150];
        InvNo: Code[20];
}