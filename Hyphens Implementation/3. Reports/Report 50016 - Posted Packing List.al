report 50016 "Posted Packing List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Report 50016 - Posted Packing List.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
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
            column(InvoiceNoCaption; InvoiceNoCaptionLbl)
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
            column(Header_No; "No.")
            {
            }
            column(Header_PostingDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_SellToName; "Sell-to Customer Name")
            {
            }
            column(Header_SellToAddress; "Sell-to Address")
            {
            }
            column(Header_SellToAddress2; "Sell-to Address 2")
            {
            }
            column(Header_SellToCity; "Sell-to City")
            {
            }
            column(Header_SellToPostCode; "Sell-to Post Code")
            {
            }
            column(Header_SellToCountry; "Sell-to Country/Region Code")
            {
            }
            column(Header_ShipToName; "Ship-to Name")
            {
            }
            column(Header_ShipToAddress; "Ship-to Address")
            {
            }
            column(Header_ShipToAddress2; "Ship-to Address 2")
            {
            }
            column(Header_ShipToCity; "Ship-to City")
            {
            }
            column(Header_ShipToPostCode; "Ship-to Post Code")
            {
            }
            column(Header_ShipToCountry; "Ship-to Country/Region Code")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    InsertIntoTemp("Sales Invoice Line");
                end;
            }
            dataitem(SummaryLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                column(temp_ItemNo; temp_SalesInvLine."No.")
                {
                }
                column(temp_ItemName; temp_SalesInvLine.Description)
                {
                }
                column(temp_BatchNumber; temp_SalesInvLine."Shipment No.")
                {
                }
                column(temp_ExpiryDate; Format(temp_SalesInvLine."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(temp_Quantity; temp_SalesInvLine.Quantity)
                {
                }
                column(temp_NetWeight; temp_SalesInvLine."Net Weight")
                {
                }
                column(temp_GrossWeight; temp_SalesInvLine."Gross Weight")
                {
                }

                trigger OnPreDataItem()
                begin
                    temp_SalesInvLine.Reset();
                    SetRange(Number, 1, temp_SalesInvLine.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        temp_SalesInvLine.FindFirst()
                    else
                        temp_SalesInvLine.Next();
                end;

                trigger OnPostDataItem()
                begin
                    temp_SalesInvLine.DeleteAll();
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
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        CompanyInfo: Record "Company Information";
        temp_SalesInvLine: Record "Sales Invoice Line" temporary;
        Line_No: Integer;

    local procedure InsertIntoTemp(par_SIL: Record "Sales Invoice Line")
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        RowID: Text;
        lcl_ItemUOM: Record "Item Unit of Measure";
    begin
        RowID := StrSubstNo('"%1";"%2";"%3";"%4";"%5";"%6"', 113, 0, par_SIL."Document No.", '', 0, par_SIL."Line No.");

        ValueEntryRelation.SetCurrentKey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId", RowID);
        if ValueEntryRelation.FindSet() then begin
            repeat
                ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                if ValueEntry."Item Ledger Entry Type" in [ValueEntry."Item Ledger Entry Type"::Sale, ValueEntry."Item Ledger Entry Type"::Purchase] then begin
                    ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");

                    if Line_No = 0 then
                        Line_No := 10000
                    else
                        Line_No += 10000;

                    temp_SalesInvLine.Reset();
                    temp_SalesInvLine.Init();
                    temp_SalesInvLine."Document No." := par_SIL."Document No.";
                    temp_SalesInvLine."Line No." := Line_No;
                    temp_SalesInvLine."No." := par_SIL."No.";
                    temp_SalesInvLine.Description := par_SIL.Description;
                    temp_SalesInvLine."Shipment No." := ItemLedgEntry."Lot No."; //Batch Number
                    temp_SalesInvLine."Shipment Date" := ItemLedgEntry."Expiration Date"; //Expiry Date
                    temp_SalesInvLine.Quantity := -1 * ItemLedgEntry.Quantity;

                    lcl_ItemUOM.Reset();
                    lcl_ItemUOM.SetRange("Item No.", par_SIL."No.");
                    lcl_ItemUOM.SetRange(Code, par_SIL."Unit of Measure Code");
                    lcl_ItemUOM.SetFilter("Qty. per Unit of Measure", '<>%1', 0);
                    if lcl_ItemUOM.FindFirst() then begin
                        temp_SalesInvLine."Net Weight" := (-1 * ItemLedgEntry.Quantity * par_SIL."Net Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                        temp_SalesInvLine."Gross Weight" := (-1 * ItemLedgEntry.Quantity * par_SIL."Gross Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                    end;

                    temp_SalesInvLine.Insert(false);
                end
            until ValueEntryRelation.Next() = 0;
        end else begin
            if Line_No = 0 then
                Line_No := 10000
            else
                Line_No += 10000;

            temp_SalesInvLine.Reset();
            temp_SalesInvLine.Init();
            temp_SalesInvLine."Document No." := par_SIL."Document No.";
            temp_SalesInvLine."Line No." := Line_No;
            temp_SalesInvLine."No." := par_SIL."No.";
            temp_SalesInvLine.Description := par_SIL.Description;
            temp_SalesInvLine.Quantity := par_SIL.Quantity;

            lcl_ItemUOM.Reset();
            lcl_ItemUOM.SetRange("Item No.", par_SIL."No.");
            lcl_ItemUOM.SetRange(Code, par_SIL."Unit of Measure Code");
            lcl_ItemUOM.SetFilter("Qty. per Unit of Measure", '<>%1', 0);
            if lcl_ItemUOM.FindFirst() then begin
                temp_SalesInvLine."Net Weight" := (par_SIL.Quantity * par_SIL."Net Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
                temp_SalesInvLine."Gross Weight" := (par_SIL.Quantity * par_SIL."Gross Weight") / lcl_ItemUOM."Qty. per Unit of Measure";
            end;

            temp_SalesInvLine.Insert(false);
        end;
    end;
}