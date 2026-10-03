report 50013 "Stock List"
{
    DefaultLayout = RDLC;
    Caption = 'Inventory with lot';
    RDLCLayout = './ReportLayouts/Rpt 50013 Stock List.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Item; Item)
        {
            // DataItemTableView = sorting(Number) where(Number = const(1));
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");

            trigger OnAfterGetRecord()
            var
                lrec_Item: Record Item;
                lrec_VE: Record "Value Entry";
                lrec_ItemApplEntry: Record "Item Application Entry";
                lrec_ILE: Record "Item Ledger Entry";
                lrec_TotalQty: Decimal;
                lrec_Counted: Decimal;
                lrec_PR: Record "Purch. Rcpt. Header";
                lrec_Cust: Record Customer;
                lrec_Item2: Record Item;
                // lrec_Manufacturer: Record "Item Manufacturer";
                lrec_ItemCategory: Record "Item Category";
            begin
                grec_TempTable.Reset();
                if grec_TempTable.FindLast() then begin
                    g_LineNo := grec_TempTable."Entry No." + 10000;
                end else begin
                    g_LineNo := 10000;
                end;

                // lrec_Item.Reset();
                // lrec_Item.SetRange(Type, lrec_Item.Type::Inventory);
                // // lrec_Item.SetRange("No.", ItemNo);
                // // if lrec_Item.FindSet() then begin
                // repeat
                clear(lrec_TotalQty);
                clear(lrec_Counted);

                lrec_VE.Reset();
                lrec_VE.SetRange("Item No.", "No.");
                lrec_VE.SetFilter("Posting Date", '..%1', ToDate);
                lrec_VE.SetRange("Location Code", Location);
                lrec_VE.SetCurrentKey("Entry No.");
                lrec_VE.SetAscending("Entry No.", false);

                if lrec_VE.FindSet() then begin
                    lrec_VE.CalcSums("Item Ledger Entry Quantity");
                    // if zero means during this period, all purchase is sold. so can skip.
                    if lrec_VE."Item Ledger Entry Quantity" <> 0 then begin
                        lrec_TotalQty := lrec_VE."Item Ledger Entry Quantity"; // means got X qty not sold
                                                                               // we only want to see Inbound entry
                        lrec_VE.SetFilter("Item Ledger Entry Quantity", '>0');
                        lrec_VE.FindSet();
                        repeat
                            if lrec_Counted <> lrec_TotalQty then begin
                                // check whether Inbound entry is sold
                                lrec_ItemApplEntry.Reset();
                                lrec_ItemApplEntry.SetRange("Inbound Item Entry No.", lrec_VE."Item Ledger Entry No.");
                                lrec_ItemApplEntry.SetFilter("Posting Date", '..%1', ToDate);
                                lrec_ItemApplEntry.CalcSums(Quantity);
                                // if zero means this Inbound entry is sold. so can skip.
                                if lrec_ItemApplEntry.Quantity <> 0 then begin
                                    // lrec_Counted += 1; // count how many we found, so we can skip the rest once hit TotalQty

                                    lrec_Counted += lrec_ItemApplEntry.Quantity;

                                    // insert to temp table
                                    lrec_ILE.Reset();
                                    lrec_ILE.SetRange("Entry No.", lrec_VE."Item Ledger Entry No.");
                                    lrec_ILE.FindSet();

                                    grec_TempTable.Init();
                                    grec_TempTable."Entry No." := g_LineNo;

                                    // GR
                                    lrec_PR.Reset();
                                    lrec_PR.SetRange("No.", lrec_ILE."Document No.");
                                    if lrec_PR.FindSet() then begin
                                        grec_TempTable.Date1 := lrec_PR."Order Date";
                                        grec_TempTable.Code1 := lrec_PR."Order No.";
                                        grec_TempTable.Text1 := lrec_PR."Posting Description";
                                        grec_TempTable.Code2 := lrec_PR."Purchaser Code";
                                        grec_TempTable.Code3 := lrec_PR."Shortcut Dimension 2 Code";
                                        // grec_TempTable.Text2 := lrec_PR.AsstCustGroup;
                                        // if lrec_PR.AsstCustGroup <> '' then begin
                                        //     if lrec_Cust.Get(lrec_PR.AsstCustGroup) then begin
                                        //         grec_TempTable.Text2 := lrec_Cust.Name;
                                        //     end;
                                        // end;
                                        grec_TempTable.Text3 := lrec_PR."Buy-from Vendor Name";
                                        grec_TempTable.Date2 := lrec_PR."Posting Date";
                                    end else begin
                                        // Jnl
                                        grec_TempTable.Date1 := lrec_ILE."Document Date";
                                        grec_TempTable.Code1 := lrec_ILE."Document No.";
                                        grec_TempTable.Text1 := lrec_ILE."External Document No.";
                                        grec_TempTable.Code3 := lrec_ILE."Global Dimension 2 Code";
                                        grec_TempTable.Date2 := lrec_ILE."Posting Date";
                                    end;

                                    lrec_Item2.Get(lrec_ILE."Item No.");
                                    grec_TempTable.Text4 := lrec_Item2."Vendor Item No.";
                                    grec_TempTable.Code4 := lrec_ILE."Item No.";
                                    grec_TempTable.Text5 := lrec_ILE.Description;
                                    // if lrec_Manufacturer.Get(lrec_Item2.Manufacturer) then
                                    //     grec_TempTable.Text6 := lrec_Manufacturer.Name;
                                    if lrec_ItemCategory.Get(lrec_Item2."Item Category Code") then
                                        grec_TempTable.Text7 := lrec_ItemCategory.Description;
                                    grec_TempTable.Code5 := lrec_ILE."Location Code";
                                    grec_TempTable.Code6 := lrec_ILE."Serial No.";
                                    grec_TempTable.Code7 := lrec_ILE."Lot No.";
                                    grec_TempTable.Date3 := lrec_ILE."Expiration Date";
                                    if lrec_ILE."Document Type" = lrec_ILE."Document Type"::" " then
                                        grec_TempTable.Text8 := Format(lrec_ILE."Entry Type")
                                    else
                                        grec_TempTable.Text8 := Format(lrec_ILE."Document Type");
                                    // grec_TempTable.Decimal3 := lrec_ILE.Quantity;
                                    grec_TempTable.Decimal3 := lrec_Counted;

                                    lrec_ILE.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                                    if lrec_ILE."Cost Amount (Expected)" = 0 then begin
                                        grec_TempTable.Decimal1 := Round(lrec_ILE."Cost Amount (Actual)" / lrec_ILE.Quantity, 0.01, '=');
                                        grec_TempTable.Decimal2 := round(lrec_ILE."Cost Amount (Actual)" / lrec_ILE.Quantity * lrec_Counted, 0.01, '=');
                                    end
                                    else begin
                                        grec_TempTable.Decimal1 := round(lrec_ILE."Cost Amount (Expected)" / lrec_ILE.Quantity, 0.01, '=');
                                        grec_TempTable.Decimal2 := round(lrec_ILE."Cost Amount (Actual)" / lrec_ILE.Quantity * lrec_Counted, 0.01, '=');
                                    end;

                                    grec_TempTable.Insert();
                                    g_LineNo += 10000;
                                    // insert to temp table
                                end;
                            end;
                        until lrec_VE.Next() = 0;
                    end;
                end;
                // until lrec_Item.Next() = 0;
                // end;
            end;

            trigger OnPreDataItem()
            begin
                grec_TempTable.Reset();
                grec_TempTable.DeleteAll();
            end;
        }

        dataitem(Temp; Integer)
        {
            DataItemTableView = sorting(Number) /*where(Number = const(1))*/;

            column(ToDate; ToDate) { }
            column(OrderDate; grec_TempTable.Date1) { }
            column(PONo; grec_TempTable.Code1) { }
            column(PostingDesc; grec_TempTable.Text1) { }
            column(PurchaserCode; grec_TempTable.Code2) { }
            column(SectionCode; grec_TempTable.Code3) { }
            column(AsstCustGroup; grec_TempTable.Text2) { }
            column(VendorName; grec_TempTable.Text3) { }
            column(VendorItemNo; grec_TempTable.Text4) { }
            column(GRDate; grec_TempTable.Date2) { }
            column(ItemNo; grec_TempTable.Code4) { }
            column(ItemDesc; grec_TempTable.Text5) { }
            column(ManufacturerName; grec_TempTable.Text6) { }
            column(ItemCategoryName; grec_TempTable.Text7) { }
            column(LocationCode; grec_TempTable.Code5) { }
            column(SerialNo; grec_TempTable.Code6) { }
            column(LotNo; grec_TempTable.Code7) { }
            column(DocType; grec_TempTable.Text8) { }
            column(Qty; grec_TempTable.Decimal3) { }
            column(UnitPrice; grec_TempTable.Decimal1) { }
            column(TotalAmount; grec_TempTable.Decimal2) { }
            column(ExpiryDate; grec_TempTable.Date3) { }

            //Trigger Integer >>
            trigger OnPreDataItem()
            begin
                grec_TempTable.Reset();
                SetRange(Number, 1, grec_TempTable.Count);

            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    grec_TempTable.Find('-')
                else
                    grec_TempTable.Next();
            end;
            //Trigger Integer <<
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Period Filter")
                {
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter End Date';
                        ShowMandatory = true;
                    }
                    field(Location; Location)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        ShowMandatory = true;
                        TableRelation = Location;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompInfo.GET;
    end;

    trigger OnPreReport()
    begin
    end;

    var

        CompInfo: Record "Company Information";
        ToDate: Date;
        grec_TempTable: Record "Temp Table" temporary;
        g_LineNo: Integer;
        Location: code[20];

}

// HANDSOME YY LOGIC
// Item
// VE
// -> filter posting date
// -> sort 'Entry No.' decending
// -> sum Item Ledger Entry Quantity
// --> if zero skip
// --> if more than 0, save this var TOTAL QTY
// --> loop in
// ------> filter Item Ledger Entry Quantity > 0
// ------> Table 339 Item Application Entry Filter Inbound Item Entry No. = VE.Item Ledger Entry No
// ------> filter 339.Posting Date
// ------------> sum quantity
// ----------------> if 0 means skip this VE
// ----------------> if not zero, add to COUNTED
// --------------------> if COUNTED = TOTAL QTY SKIP THIS ITEM