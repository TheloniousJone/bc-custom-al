report 70048 "Inventory Posting List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory Posting List';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "Novem - Inventory Posting List";

    dataset
    {
        dataitem(ItemLedEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Posting Date");//SORTING("Entry Type", "Item No.");
            RequestFilterFields = "Posting Date", "Item No.", "Location Code";
            column(STRSUBSTNO__ItemLedEntryFilter_; StrSubstNo('%1', ItemLedEntryFilter)) { }
            column(Today; Format(CurrentDateTime(), 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            column(Item_No_; "Item No.") { }
            column(Description; ItemDescr) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            column(Document_No_; DocumentNo) { }
            column(Location_Code; "Location Code") { }
            column(Source_No_; SourceNo) { }
            column(SourceName; SourceName) { }
            column(Iss_Quantity; IssInvQuantity) { }
            column(Rec_Quantity; RecInvQuantity) { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Sales_Amount__Actual_; UnitCost_UnitSale) { }
            column(Lot_No_; "Lot No.") { }
            column(FilterCustomerNo; FilterCustomerNo) { }
            column(FilterVendorNo; FilterVendorNo) { }
            column(Document_Date; Format(ItemLedEntry."Document Date", 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            trigger OnPreDataItem()
            begin
                // ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
                // ItemLedEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                if FilterCustomerNo <> '' then
                    SetFilter("Source No.", FilterCustomerNo);
                if FilterVendorNo <> '' then
                    SetFilter("Source No.", FilterVendorNo);
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvHdr: Record "Sales Invoice Header";
                SalesCrMemo: Record "Sales Cr.Memo Header";
                PurchInvHdr: Record "Purch. Inv. Header";
                PurchCrMemo: Record "Purch. Cr. Memo Hdr.";
                ValueEntry: Record "Value Entry";
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                Clear(DocumentNo);
                Clear(SourceNo);
                Clear(SourceName);
                Clear(IssInvQuantity);
                Clear(RecInvQuantity);
                Clear(UnitCost_UnitSale);

                ItemLedEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)", "Sales Amount (Actual)", "Sales Amount (Expected)");

                ItemRec.Reset();
                if ItemRec.get(ItemLedEntry."Item No.") then
                    ItemDescr := ItemRec.Description;

                case "Entry Type" of
                    "Entry Type"::"Assembly Consumption":
                        begin
                            DocumentNo := "Document No.";
                            RecInvQuantity := ItemLedEntry.Quantity;
                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)";
                        end;
                    "Entry Type"::"Assembly Output":
                        begin
                            DocumentNo := "Document No.";
                            IssInvQuantity := ItemLedEntry.Quantity;
                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)";
                        end;
                    "Entry Type"::Purchase:
                        begin
                            case "Document Type" of
                                "Document Type"::"Purchase Receipt":
                                    begin
                                        ValueEntry.Reset();
                                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                                        ValueEntry.SetRange("Document Type", "Document Type"::"Purchase Invoice");
                                        if ValueEntry.FindFirst() then begin
                                            DocumentNo := ValueEntry."Document No.";
                                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)" / ItemLedEntry.Quantity;
                                            RecInvQuantity := ItemLedEntry.Quantity;
                                            SourceNo := ValueEntry."Source No.";
                                        end
                                        else begin
                                            RecInvQuantity := ItemLedEntry.Quantity;

                                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Expected)" / ItemLedEntry.Quantity;
                                            DocumentNo := ItemLedEntry."Document No.";
                                            SourceNo := ItemLedEntry."Source No.";
                                        end;
                                    end;
                                "Document Type"::"Purchase Invoice":
                                    begin
                                        DocumentNo := "Document No.";
                                        RecInvQuantity := ItemLedEntry.Quantity;
                                        UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)" / ItemLedEntry.Quantity;
                                        SourceNo := ItemLedEntry."Source No.";
                                    end;
                                "Document Type"::"Purchase Return Shipment":
                                    begin
                                        ValueEntry.Reset();
                                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                                        ValueEntry.SetRange("Document Type", "Document Type"::"Purchase Credit Memo");
                                        if ValueEntry.FindFirst() then begin
                                            DocumentNo := ValueEntry."Document No.";
                                            SourceNo := ValueEntry."Source No.";

                                            RecInvQuantity := ItemLedEntry.Quantity;
                                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)" / ItemLedEntry.Quantity;
                                        end;
                                    end;
                                "Document Type"::"Purchase Credit Memo":
                                    begin
                                        DocumentNo := "Document No.";
                                        RecInvQuantity := ItemLedEntry.Quantity;
                                        UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)" / ItemLedEntry.Quantity;
                                        SourceNo := ItemLedEntry."Source No.";
                                    end;
                            end;

                            if Vend.get(SourceNo) then
                                SourceName := Vend.Name;
                        end;
                    "Entry Type"::Sale:
                        begin
                            case "Document Type" of
                                "Document Type"::"Sales Shipment":
                                    begin
                                        ValueEntry.Reset();
                                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                                        ValueEntry.SetRange("Document Type", "Document Type"::"Sales Invoice");
                                        if ValueEntry.FindFirst() then begin
                                            DocumentNo := ValueEntry."Document No.";
                                            UnitCost_UnitSale := ItemLedEntry."Sales Amount (Actual)" / ItemLedEntry.Quantity;
                                            IssInvQuantity := ItemLedEntry.Quantity;
                                            SourceNo := ValueEntry."Source No.";
                                        end
                                        else begin
                                            IssInvQuantity := ItemLedEntry.Quantity;

                                            UnitCost_UnitSale := ItemLedEntry."Sales Amount (Expected)" / ItemLedEntry.Quantity;
                                            DocumentNo := ItemLedEntry."Document No.";
                                            SourceNo := ItemLedEntry."Source No.";
                                        end;
                                    end;
                                "Document Type"::"Sales Invoice":
                                    begin
                                        DocumentNo := ItemLedEntry."Document No.";
                                        IssInvQuantity := ItemLedEntry.Quantity;
                                        UnitCost_UnitSale := ItemLedEntry."Sales Amount (Actual)" / ItemLedEntry.Quantity;
                                        SourceNo := ItemLedEntry."Source No.";
                                    end;
                                "Document Type"::"Sales Return Receipt":
                                    begin
                                        ValueEntry.Reset();
                                        ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                                        ValueEntry.SetRange("Document Type", "Document Type"::"Sales Credit Memo");
                                        if ValueEntry.FindFirst() then begin
                                            DocumentNo := ValueEntry."Document No.";
                                            SourceNo := ValueEntry."Source No.";

                                            IssInvQuantity := ItemLedEntry.Quantity;
                                            UnitCost_UnitSale := ItemLedEntry."Sales Amount (Actual)" / ItemLedEntry.Quantity;
                                        end;
                                    end;
                                "Document Type"::"Sales Credit Memo":
                                    begin
                                        DocumentNo := ItemLedEntry."Document No.";
                                        IssInvQuantity := ItemLedEntry.Quantity;
                                        UnitCost_UnitSale := ItemLedEntry."Sales Amount (Actual)" / ItemLedEntry.Quantity;
                                        SourceNo := ItemLedEntry."Source No.";
                                    end;
                            end;

                            if Cust.get(SourceNo) then
                                SourceName := Cust.Name;
                        end;
                    "Entry Type"::Transfer:
                        begin
                            if "Document Type" = "Document Type"::"Direct Transfer" then begin
                                DocumentNo := "Document No.";
                                UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)";

                                if Quantity < 0 then
                                    IssInvQuantity := ItemLedEntry.Quantity;

                                if Quantity > 0 then
                                    RecInvQuantity := ItemLedEntry.Quantity;
                            end;
                        end;
                    "Entry Type"::"Negative Adjmt.":
                        begin
                            DocumentNo := "Document No.";
                            IssInvQuantity := ItemLedEntry.Quantity;
                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)";
                        end;
                    "Entry Type"::"Positive Adjmt.":
                        begin
                            DocumentNo := "Document No.";
                            RecInvQuantity := ItemLedEntry.Quantity;
                            UnitCost_UnitSale := ItemLedEntry."Cost Amount (Actual)";
                        end;
                end;
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
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
                    field(FilterVendorNo; FilterVendorNo)
                    {
                        Caption = 'Vendor Code';
                        Lookup = true;
                        DrillDown = true;
                        LookupPageId = "Vendor Lookup";
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            VendorRec: Record Vendor;
                            VendorLookupPage: Page "Vendor Lookup";
                            RecRef: RecordRef;
                        begin
                            clear(FilterCustomerNo);
                            VendorLookupPage.SetTableView(VendorRec);
                            VendorLookupPage.LookupMode(true);
                            if VendorLookupPage.RunModal() = Action::LookupOK then begin
                                VendorLookupPage.SetSelectionFilter(VendorRec);
                                RecRef.GetTable(VendorRec);
                                FilterVendorNo := I9G_NovemEventSubscribersCodeUnit.GetSelectionFilter(RecRef, VendorRec.FieldNo("No."));
                            end;
                        end;
                    }
                }
            }
        }
    }

    rendering
    {
        layout("Novem - Inventory Posting List")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70048-InventoryPostingList.rdl';
        }
    }

    trigger OnPreReport()
    begin
        // ItemLedEntry.SetLoadFields("Entry No.", "Item No.", "Posting Date", "Document Date", "Entry Type", "Source No.", "Document No.", "Description", "Item Category Code", "Unit of Measure Code", "Invoiced Quantity", "Sales Amount (Actual)");
        ItemLedEntryFilter := ItemLedEntry.GetFilters();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        SourceNo: Code[20];
        SourceName: Text[100];
        ItemLedEntryFilter: Text;
        FilterCustomerNo: Text;
        FilterVendorNo: Text;
        DocumentNo: Code[20];
        IssInvQuantity: Decimal;
        RecInvQuantity: Decimal;
        UnitCost_UnitSale: Decimal;
        ItemRec: Record Item;
        ItemDescr: Text[100];



}

