report 70046 "SalesRpFullInformation"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Report Full Information';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "Novem - Sales Report Full Information";

    dataset
    {
        dataitem(ItemLedEntry; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Entry Type", "Item No.") WHERE("Entry Type" = filter('Sale'));
            RequestFilterFields = "Last Invoice Date", "Source No.", "Item No.";
            column(Year; Format(ItemLedEntry."Last Invoice Date", 0, '<Year4>')) { }
            column(Monthly; Format(ItemLedEntry."Last Invoice Date", 0, '<Month Text>')) { }
            column(Document_Date; Format(ItemLedEntry."Last Invoice Date", 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            column(STRSUBSTNO__ItemLedEntryFilter_; StrSubstNo('%1', ItemLedEntryFilter)) { }
            column(Document_Type; DocumentType) { }
            column(Source_No_; SourceNo) { }
            column(SourceName; SourceName) { }
            column(Document_No_; DocumentNo) { }
            column(Item_No_; "Item No.") { }
            column(Description; ItemDescr) { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Sales_Quantity; SalesInvQuantity) { }
            column(Bonus_Quantity; BonusInvQuantity) { }
            column(Invoiced_Quantity; "Invoiced Quantity") { }
            column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }
            column(SellPrice; SellPrice) { }
            column(Discount; Discount) { }
            column(Posting_Date; "Posting Date") { }
            column(Today; Format(CurrentDateTime(), 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            // column(StartDate; StartDate) { }
            // Column(EndDate; EndDate) { }
            column(Item_Category_Code; "Shortcut Dimension 4 Code") { }
            column(DeliveryAddress; DeliveryAddress) { }
            column(DistrictCode; DistrictCode) { }
            column(PostCode; PostCode) { }
            column(IsCrMm; IsCrMm) { }
            column(Sales_Employee; "Shortcut Dimension 7 Code") { }
            column(CaseNo; CaseNo) { }
            column(CaseDoc; CaseDoc) { }

            trigger OnPreDataItem()
            begin
                // ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
                // ItemLedEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);

            end;

            trigger OnAfterGetRecord()
            var
                SalesInvHdr: Record "Sales Invoice Header";
                SalesInvLine: Record "Sales Invoice Line";
                SalesCrMemo: Record "Sales Cr.Memo Header";
                SalesCrMemoLine: Record "Sales Cr.Memo Line";
                ValueEntry: Record "Value Entry";
                Item: Record Item;
            begin
                Clear(DocumentNo);
                Clear(DocumentType);
                Clear(SourceNo);
                Clear(SourceName);
                Clear(SalesAgent);
                Clear(DeliveryAddress);
                Clear(PostCode);
                Clear(SellPrice);
                Clear(Discount);
                Clear(SalesInvQuantity);
                Clear(BonusInvQuantity);
                Clear(IsCrMm);
                Clear(DistrictCode);
                Clear(CaseNo);
                Clear(CaseDoc);

                case "Document Type" of
                    "Document Type"::"Sales Shipment":
                        begin
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                            ValueEntry.SetRange("Document Type", "Document Type"::"Sales Invoice");
                            if ValueEntry.FindFirst() then begin
                                DocumentNo := ValueEntry."Document No.";
                                DocumentType := 'Invoice';
                            end;

                            if SalesInvHdr.Get(DocumentNo) then begin
                                SourceNo := SalesInvHdr."Sell-to Customer No.";
                                SourceName := SalesInvHdr."Sell-to Customer Name";
                                SalesAgent := SalesInvHdr."Salesperson Code";
                                DeliveryAddress := SalesInvHdr."Ship-to Name" + SalesInvHdr."Ship-to Name 2" + SalesInvHdr."Ship-to Address" + SalesInvHdr."Ship-to Address 2";
                                DistrictCode := SalesInvHdr.I9G_ShipToDistrictCode;
                                PostCode := SalesInvHdr."Ship-to Post Code";
                                CaseNo := SalesInvHdr.I9G_CaseNumber;
                                CaseDoc := SalesInvHdr.I9G_CaseDoctor;
                            end;

                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Document No.", DocumentNo);
                            SalesInvLine.SetRange("Line No.", ValueEntry."Document Line No.");
                            if SalesInvLine.FindFirst() then begin
                                SellPrice := SalesInvLine."Unit Price";
                                Discount := SalesInvLine."Inv. Discount Amount" + SalesInvLine."Line Discount Amount";
                            end;

                            IsCrMm := false;
                        end;
                    "Document Type"::"Sales Invoice":
                        begin
                            DocumentNo := "Document No.";
                            DocumentType := 'Invoice';

                            if SalesInvHdr.Get(DocumentNo) then begin
                                SourceNo := SalesInvHdr."Sell-to Customer No.";
                                SourceName := SalesInvHdr."Sell-to Customer Name";
                                SalesAgent := SalesInvHdr."Salesperson Code";
                                DeliveryAddress := SalesInvHdr."Ship-to Name" + SalesInvHdr."Ship-to Name 2" + SalesInvHdr."Ship-to Address" + SalesInvHdr."Ship-to Address 2";
                                DistrictCode := SalesInvHdr.I9G_ShipToDistrictCode;
                                PostCode := SalesInvHdr."Ship-to Post Code";
                                CaseNo := SalesInvHdr.I9G_CaseNumber;
                                CaseDoc := SalesInvHdr.I9G_CaseDoctor;
                            end;

                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Document No.", DocumentNo);
                            SalesInvLine.SetRange("Line No.", "Document Line No.");
                            if SalesInvLine.FindFirst() then begin
                                SellPrice := SalesInvLine."Unit Price";
                                Discount := SalesInvLine."Inv. Discount Amount" + SalesInvLine."Line Discount Amount";
                            end;

                            IsCrMm := false;
                        end;
                    "Document Type"::"Sales Return Receipt":
                        begin
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                            ValueEntry.SetRange("Document Type", "Document Type"::"Sales Credit Memo");
                            if ValueEntry.FindFirst() then begin
                                DocumentNo := ValueEntry."Document No.";
                                DocumentType := 'Credit Note';
                            end;

                            if SalesCrMemo.Get(DocumentNo) then begin
                                SourceNo := SalesCrMemo."Sell-to Customer No.";
                                SourceName := SalesCrMemo."Sell-to Customer Name";
                                SalesAgent := SalesCrMemo."Salesperson Code";
                                DeliveryAddress := SalesCrMemo."Ship-to Name" + SalesCrMemo."Ship-to Name 2" + SalesCrMemo."Ship-to Address" + SalesCrMemo."Ship-to Address 2";
                                DistrictCode := SalesCrMemo.I9G_ShipToDistrictCode;
                                PostCode := SalesCrMemo."Ship-to Post Code";
                                CaseNo := SalesCrMemo.I9G_CaseNumber;
                                CaseDoc := SalesCrMemo.I9G_CaseDoctor;
                            end;

                            SalesCrMemoLine.Reset();
                            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
                            SalesCrMemoLine.SetRange("Line No.", ValueEntry."Document Line No.");
                            if SalesCrMemoLine.FindFirst() then begin
                                SellPrice := SalesCrMemoLine."Unit Price";
                                Discount := SalesCrMemoLine."Inv. Discount Amount" + SalesCrMemoLine."Line Discount Amount";
                            end;

                            IsCrMm := false;
                        end;
                    "Document Type"::"Sales Credit Memo":
                        begin
                            DocumentNo := "Document No.";
                            DocumentType := 'Credit Note';

                            if SalesCrMemo.Get(DocumentNo) then begin
                                SourceNo := SalesCrMemo."Sell-to Customer No.";
                                SourceName := SalesCrMemo."Sell-to Customer Name";
                                SalesAgent := SalesCrMemo."Salesperson Code";
                                DeliveryAddress := SalesCrMemo."I9G_Name (CN)" + SalesCrMemo."I9G_Ship-to Name 2 (CN)" + SalesCrMemo."I9G_Address (CN)" + SalesCrMemo."I9G_Address 2 (CN)";
                                DistrictCode := SalesCrMemo."I9G_District Code (CN)";
                                PostCode := SalesCrMemo."I9G_Postcode (CN)";
                                CaseNo := SalesCrMemo.I9G_CaseNumber;
                                CaseDoc := SalesCrMemo.I9G_CaseDoctor;
                            end;

                            SalesCrMemoLine.Reset();
                            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
                            SalesCrMemoLine.SetRange("Line No.", "Document Line No.");
                            if SalesCrMemoLine.FindFirst() then begin
                                SellPrice := SalesCrMemoLine."Unit Price";
                                Discount := SalesCrMemoLine."Inv. Discount Amount" + SalesCrMemoLine."Line Discount Amount";
                            end;

                            IsCrMm := true;
                        end;
                end;

                if "Sales Amount (Actual)" <> 0 then
                    SalesInvQuantity := "Invoiced Quantity" * -1
                else
                    BonusInvQuantity := "Invoiced Quantity" * -1;

                Item.Reset();
                if Item.Get("Item No.") then begin
                    ItemDescr := Item.Description;
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
                group(Options)
                {
                    Caption = 'Options';
                    // field(StartDate; StartDate)
                    // {
                    //     Caption = 'Start Date';
                    // }
                    // field(EndDate; EndDate)
                    // {
                    //     Caption = 'End Date';
                    // }
                }
            }
        }
    }

    rendering
    {
        layout("Novem - Sales Report Full Information")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70046-SalesRpFullInformation.rdl';
        }
    }

    trigger OnPreReport()
    begin
        // if (StartDate = 0D) or (EndDate = 0D) then
        //     Error('Please fill in the start date and end date.');

        // if StartDate > EndDate then
        //     Error('Start date cannot be later than the end date..');
        // ItemLedEntry.SetLoadFields("Entry No.", "Item No.", "Posting Date", "Document Date", "Entry Type", "Source No.", "Document No.", "Description", "Item Category Code", "Unit of Measure Code", "Invoiced Quantity", "Sales Amount (Actual)");
        ItemLedEntryFilter := ItemLedEntry.GetFilters();
    end;

    var
        // StartDate: Date;
        // EndDate: Date;
        SourceNo: Code[20];
        SourceName: Text[100];
        Duration: Duration;
        SalesAgent: Code[20];
        DeliveryAddress: Text[300];
        DistrictCode: Code[20];
        PostCode: Code[20];
        DocumentType: Text[20];
        ItemLedEntryFilter: Text;
        DocumentNo: Code[20];
        SellPrice: Decimal;
        Discount: Decimal;
        SalesInvQuantity: Decimal;
        BonusInvQuantity: Decimal;
        ItemDescr: Text[100];
        IsCrMm: Boolean;
        CaseNo: Code[150];
        CaseDoc: Text[100];

}

