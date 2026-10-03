report 60112 "Ord.Disp.Bal QR"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Ord-Disp-Bal-QR';
    RDLCLayout = './Report Layouts/ReportLayout 60112 - OrdDispBalQR.rdl';
    PreviewMode = PrintLayout;
    EnableExternalImages = true;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Ord-Disp-Bal-QR';
            column(No_; "No.") { }
            column(Document_Date; "Document Date") { }
            column(Well__Basket_No_; "Well. Basket No.")
            {

            }
            column(Patient_Name; "Patient Name") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(PatientAddress; "ship-to Address" + ' ' + "Ship-to Post Code") { }
            column(PatientContact; "Ship-to Contact") { }

            column(QRCodeImageLink; QRCodeImageLink) { }
            column(External_Document_No_; "External Document No.") { }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = salesheader;
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Description; Description) { }
                column(QtytoShip; "Qty. to Ship") { }
                column(OrderQty; Quantity) { }
                column(Bal; Bal) { }
                column(Line_No_; "Line No.") { }
                trigger OnAfterGetRecord()
                begin
                    Clear(Bal);
                    Bal := SalesLine.Quantity - SalesLine."Qty. to Ship";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // YF 06 May 2022
                QRCodeImageLink := 'https://illum9-api.cloud:55669/qrgen/cTvHa3uz?add_logo=true&phone_no=' + CompInfo."WhatsApp QR Phone No.";
                QRCodeImageLink += '&msg_text=' + CompInfo."WhatsApp QR Message";
                QRCodeImageLink += '&ext_doc_no=' + SalesHeader."External Document No.";
                // YF 06 May 2022
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
    end;

    var
        SLRec: Record "Sales Line";
        SHRec: Record "Sales Header";
        Bal: Decimal;
        QRCodeImageLink: Text[1024];
        CompInfo: Record "Company Information";

}
