report 50015 "Packing List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Report 50015 - Packing List.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const("Order"));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
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
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(OrderNoCaption; OrderNoCaptionLbl)
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
            column(Header_DocType; "Document Type")
            {
            }
            column(Header_No; "No.")
            {
            }
            column(Header_PostingDate; Format("Sales Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_SellToName; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(Header_SellToAddress; "Sales Header"."Sell-to Address")
            {
            }
            column(Header_SellToAddress2; "Sales Header"."Sell-to Address 2")
            {
            }
            column(Header_SellToCity; "Sales Header"."Sell-to City")
            {
            }
            column(Header_SellToPostCode; "Sales Header"."Sell-to Post Code")
            {
            }
            column(Header_SellToCountry; "Sales Header"."Sell-to Country/Region Code")
            {
            }
            column(Header_ShipToName; "Sales Header"."Ship-to Name")
            {
            }
            column(Header_ShipToAddress; "Sales Header"."Ship-to Address")
            {
            }
            column(Header_ShipToAddress2; "Sales Header"."Ship-to Address 2")
            {
            }
            column(Header_ShipToCity; "Sales Header"."Ship-to City")
            {
            }
            column(Header_ShipToPostCode; "Sales Header"."Ship-to Post Code")
            {
            }
            column(Header_ShipToCountry; "Sales Header"."Ship-to Country/Region Code")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    InsertIntoTemp("Sales Line");
                end;
            }
            dataitem(SummaryLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                column(temp_ItemNo; temp_SalesLine."No.")
                {
                }
                column(temp_ItemName; temp_SalesLine.Description)
                {
                }
                column(temp_BatchNumber; temp_SalesLine."Shipment No.")
                {
                }
                column(temp_ExpiryDate; Format(temp_SalesLine."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(temp_Quantity; temp_SalesLine.Quantity)
                {
                }
                column(temp_NetWeight; temp_SalesLine."Net Weight")
                {
                }
                column(temp_GrossWeight; temp_SalesLine."Gross Weight")
                {
                }

                trigger OnPreDataItem()
                begin
                    temp_SalesLine.Reset();
                    SetRange(Number, 1, temp_SalesLine.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        temp_SalesLine.FindFirst()
                    else
                        temp_SalesLine.Next();
                end;

                trigger OnPostDataItem()
                begin
                    temp_SalesLine.DeleteAll();
                end;
            }
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ReportCaptionLbl: Label 'Packing List';
        TelCaptionLbl: Label 'T';
        FaxCaptionLbl: Label 'F';
        WebsiteCaptionLbl: Label 'W';
        CoRegNoCaptionLbl: Label 'Co. Reg. No.';
        GSTRegNoCaptionLbl: Label 'GST Reg. No.';
        DateCaptionLbl: Label 'Date';
        OrderNoCaptionLbl: Label 'Order No.';
        CompanyInfo: Record "Company Information";
        temp_SalesLine: Record "Sales Line" temporary;
        Line_No: Integer;

    local procedure InsertIntoTemp(par_SL: Record "Sales Line")
    var
        lcl_ReservationEntry: Record "Reservation Entry";
        lcl_ItemUOM: Record "Item Unit of Measure";
        grec_TrackS: Record "Item Ledger Entry";
    begin
        lcl_ReservationEntry.Reset();
        lcl_ReservationEntry.SetRange("Source Type", 37);
        lcl_ReservationEntry.SetRange("Source Subtype", par_SL."Document Type");
        lcl_ReservationEntry.SetRange("Source ID", par_SL."Document No.");
        lcl_ReservationEntry.SetRange("Source Ref. No.", par_SL."Line No.");
        if lcl_ReservationEntry.FindSet() then begin
            repeat
                if Line_No = 0 then
                    Line_No := 10000
                else
                    Line_No += 10000;

                temp_SalesLine.Reset();
                temp_SalesLine.Init();
                temp_SalesLine."Document Type" := par_SL."Document Type";
                temp_SalesLine."Document No." := par_SL."Document No.";
                temp_SalesLine."Line No." := Line_No;
                temp_SalesLine."No." := par_SL."No.";
                temp_SalesLine.Description := par_SL.Description;
                temp_SalesLine."Shipment No." := lcl_ReservationEntry."Lot No."; //Batch Number
                temp_SalesLine."Shipment Date" := lcl_ReservationEntry."Expiration Date"; //Expiry Date
                temp_SalesLine.Quantity := lcl_ReservationEntry."Quantity (Base)" * -1;

                grec_TrackS.Reset();
                grec_TrackS.SetRange("Item No.", par_SL."No.");
                grec_TrackS.SetRange("Lot No.", lcl_ReservationEntry."Lot No.");
                if grec_TrackS.FindFirst() then begin
                    // if temp_SalesLine."Shipment No." = '' then begin
                    //     temp_SalesLine."Shipment No." := grec_TrackS."Lot No.";
                    // end;
                    if temp_SalesLine."Shipment Date" = 0D then begin
                        temp_SalesLine."Shipment Date" := grec_TrackS."Expiration Date";
                    end;

                end;

                lcl_ItemUOM.Reset();
                lcl_ItemUOM.SetRange("Item No.", par_SL."No.");
                lcl_ItemUOM.SetRange(Code, par_SL."Unit of Measure Code");
                lcl_ItemUOM.SetFilter("Qty. per Unit of Measure", '<>%1', 0);
                if lcl_ItemUOM.FindFirst() then begin
                    temp_SalesLine."Net Weight" := (lcl_ReservationEntry."Quantity (Base)" * -1 * par_SL."Net Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                    temp_SalesLine."Gross Weight" := (lcl_ReservationEntry."Quantity (Base)" * -1 * par_SL."Gross Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                end;

                temp_SalesLine.Insert(false);

            until lcl_ReservationEntry.Next() = 0;
        end else begin
            if Line_No = 0 then
                Line_No := 10000
            else
                Line_No += 10000;

            temp_SalesLine.Reset();
            temp_SalesLine.Init();
            temp_SalesLine."Document Type" := par_SL."Document Type";
            temp_SalesLine."Document No." := par_SL."Document No.";
            temp_SalesLine."Line No." := Line_No;
            temp_SalesLine."No." := par_SL."No.";
            temp_SalesLine.Description := par_SL.Description;
            temp_SalesLine.Quantity := par_SL.Quantity;

            lcl_ItemUOM.Reset();
            lcl_ItemUOM.SetRange("Item No.", par_SL."No.");
            lcl_ItemUOM.SetRange(Code, par_SL."Unit of Measure Code");
            lcl_ItemUOM.SetFilter("Qty. per Unit of Measure", '<>%1', 0);
            if lcl_ItemUOM.FindFirst() then begin
                temp_SalesLine."Net Weight" := (par_SL.Quantity * par_SL."Net Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                temp_SalesLine."Gross Weight" := (par_SL.Quantity * par_SL."Gross Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
            end;

            temp_SalesLine.Insert(false);
        end
    end;
}