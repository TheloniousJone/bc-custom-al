report 57114 "HP Delivery Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57114 - HP Delivery Order.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Assembly Header"; "Assembly Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Item No.", "Due Date";
            column(ReportCaption; ReportCaptionLbl)
            {
            }
            column(TelCaption; TelCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(WebsiteCaption; WebsiteCaptionLbl)
            {
            }
            column(CoRegNoCaption; CoRegNoCaptionLbl)
            {
            }
            column(GSTRegNoCaption; GSTRegNoCaptionLbl)
            {
            }
            column(PurchaseOrderCaption; PurchaseOrderCaptionLbl)
            {
            }
            column(NumberCaption; NumberCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Header_No; "No.")
            {
            }
            column(Header_PONo; "PO No.")
            {
            }
            column(Header_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_ItemNo; "Item No.")
            {
            }
            column(Header_ItemDescription; Description)
            {
            }
            column(Header_VendorName; Rec_Vendor.Name)
            {
            }
            column(Header_VendorAddress; Rec_Vendor.Address)
            {
            }
            column(Header_VendorAddress2; Rec_Vendor."Address 2")
            {
            }
            column(Header_VendorCity; Rec_Vendor.City)
            {
            }
            column(Header_VendorPostCode; Rec_Vendor."Post Code")
            {
            }
            column(Header_Quantity; Quantity)
            {
            }
            column(Header_UOM; "Unit of Measure Code")
            {
            }
            column(Header_ItemTracking_LotNo; Header_ItemTracking_LotNo)
            {
            }
            column(Header_ItemTracking_ExpDate; Format(Header_ItemTracking_ExpDate, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_PackingInst; "Packing Instructions")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Website; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfo_CoRegNo; CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfo_GSTRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            dataitem("Assembly Line"; "Assembly Line")
            {
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                trigger OnPreDataItem()
                begin
                    SetRange(Type, Type::Item);
                end;

                trigger OnAfterGetRecord()
                begin
                    InsertIntoTemp("Assembly Line");
                end;
            }
            dataitem(SummaryLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                column(temp_ItemNo; ItemLedgerEntryTemp."Item No.")
                {
                }
                column(temp_ItemName; Item_Description)
                {
                }
                column(temp_BatchNumber; ItemLedgerEntryTemp."Lot No.")
                {
                }
                column(temp_Quantity; ItemLedgerEntryTemp.Quantity)
                {
                }
                column(temp_UOM; ItemLedgerEntryTemp."Unit of Measure Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    ItemLedgerEntryTemp.Reset();
                    SetRange(Number, 1, ItemLedgerEntryTemp.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        ItemLedgerEntryTemp.FindFirst()
                    else
                        ItemLedgerEntryTemp.Next();

                    GetItemDescription(ItemLedgerEntryTemp."Item No.");
                end;

                trigger OnPostDataItem()
                begin
                    ItemLedgerEntryTemp.DeleteAll();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Vendor No" <> '' then begin
                    Rec_Vendor.Reset();
                    Rec_Vendor.Get("Vendor No");
                end else
                    Clear(Rec_Vendor);

                GetItemTrackingForHeader("Assembly Header");
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ReportCaptionLbl: Label 'Delivery Note';
        TelCaptionLbl: Label 'T';
        FaxCaptionLbl: Label 'F';
        WebsiteCaptionLbl: Label 'W';
        CoRegNoCaptionLbl: Label 'Co. Reg. No.';
        GSTRegNoCaptionLbl: Label 'GST Reg. No.';
        PurchaseOrderCaptionLbl: Label 'Purchase Order';
        NumberCaptionLbl: Label 'Number';
        DateCaptionLbl: Label 'Date';
        DescriptionCaptionLbl: Label 'Description';
        CompanyInfo: Record "Company Information";
        Rec_Vendor: Record Vendor;
        ItemLedgerEntryTemp: Record "Item Ledger Entry" temporary;
        Entry_No: Integer;
        Item_Description: Text[100];
        Header_ItemTracking_LotNo: Code[50];
        Header_ItemTracking_ExpDate: Date;

    local procedure InsertIntoTemp(par_AL: Record "Assembly Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", 901);
        ReservationEntry.SetRange("Source Subtype", par_AL."Document Type");
        ReservationEntry.SetRange("Source ID", par_AL."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", par_AL."Line No.");
        if ReservationEntry.FindSet() then begin
            repeat
                ItemLedgerEntryTemp.Reset();
                ItemLedgerEntryTemp.SetRange("Lot No.", ReservationEntry."Lot No.");
                ItemLedgerEntryTemp.SetRange("Item No.", ReservationEntry."Item No.");
                if not ItemLedgerEntryTemp.FindFirst() then begin
                    if Entry_No = 0 then
                        Entry_No := 1
                    else
                        Entry_No += 1;

                    ItemLedgerEntryTemp.Reset();
                    ItemLedgerEntryTemp.Init();
                    ItemLedgerEntryTemp."Entry No." := Entry_No;
                    ItemLedgerEntryTemp."Item No." := ReservationEntry."Item No.";
                    ItemLedgerEntryTemp."Lot No." := ReservationEntry."Lot No.";
                    ItemLedgerEntryTemp.Quantity := ReservationEntry."Quantity (Base)" * -1;
                    ItemLedgerEntryTemp."Unit of Measure Code" := par_AL."Unit of Measure Code";
                    ItemLedgerEntryTemp.Insert(false);
                end;
            until ReservationEntry.Next() = 0;
        end else begin
            ItemLedgerEntryTemp.Reset();
            ItemLedgerEntryTemp.SetRange("Item No.", par_AL."No.");
            if not ItemLedgerEntryTemp.FindFirst() then begin
                if Entry_No = 0 then
                    Entry_No := 1
                else
                    Entry_No += 1;

                ItemLedgerEntryTemp.Reset();
                ItemLedgerEntryTemp.Init();
                ItemLedgerEntryTemp."Entry No." := Entry_No;
                ItemLedgerEntryTemp."Item No." := par_AL."No.";
                ItemLedgerEntryTemp.Quantity := par_AL."Quantity (Base)";
                ItemLedgerEntryTemp."Unit of Measure Code" := par_AL."Unit of Measure Code";
                ItemLedgerEntryTemp.Insert(false);
            end;
        end;
    end;

    local procedure GetItemDescription(par_ItemNo: Code[20])
    var
        lcl_Item: Record Item;
    begin
        Clear(Item_Description);

        lcl_Item.Reset();
        lcl_Item.SetRange("No.", par_ItemNo);
        if lcl_Item.FindFirst() then
            Item_Description := lcl_Item.Description;
    end;

    local procedure GetItemTrackingForHeader(par_AH: Record "Assembly Header")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        Clear(Header_ItemTracking_LotNo);
        Clear(Header_ItemTracking_ExpDate);

        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", 900);
        ReservationEntry.SetRange("Source Subtype", par_AH."Document Type");
        ReservationEntry.SetRange("Source ID", par_AH."No.");
        if ReservationEntry.FindFirst() then begin
            Header_ItemTracking_LotNo := ReservationEntry."Lot No.";
            Header_ItemTracking_ExpDate := ReservationEntry."Expiration Date";
        end
    end;
}