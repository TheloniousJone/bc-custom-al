report 60113 "CourierQR"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'CourierQR';
    RDLCLayout = './Report Layouts/ReportLayout 60113 - CourierQR.rdl';
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

            // column(QRCodeImageLink; QRCodeImageLink) { }
            column(QRCodeImageLink; QRCode) { }
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
                GenerateQRCode();
                /* 
                    QRCodeImageLink := 'https://illum9-api.cloud:55669/qrgen/cTvHa3uz?add_logo=false&phone_no=' + CompInfo."WhatsApp QR Phone No.";
                    QRCodeImageLink += '&msg_text=' + ' ';
                    QRCodeImageLink += '&ext_doc_no=' + SalesHeader."External Document No."; 
                 */


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

        QRCode: Text;
        BarcodeURL: Text;
        CustomerNo: Code[20];
        CustomerName: Text[100];

    local procedure GenerateQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        QRCode := BarcodeFontProvider2D.EncodeFont(Format(SalesHeader."External Document No."), BarcodeSymbology2D);
    end;

    // procedure AssignBarcodeURL(CustNo: Code[20]; CustName: text[100]; NewBarcodeURL: Text)
    // begin
    //     // Customer."No." := CustNo;
    //     // Customer.Name := CustName;
    //     BarcodeURL := NewBarcodeURL;
    // end;
}
