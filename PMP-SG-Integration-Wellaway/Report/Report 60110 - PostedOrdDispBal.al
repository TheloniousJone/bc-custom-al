report 60110 "Posted Ord.Disp.Bal"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Ord-Disp-Bal';
    RDLCLayout = './Report Layouts/ReportLayout 60110 - PostedOrdDispBal.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesHeader; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Ord-Disp-Bal';
            column(No_; "No.") { }
            column(Document_Date; "Document Date") { }
            column(Well__Basket_No_; "Well. Basket No.")
            {

            }
            column(Patient_Name; "Patient Name") { }
            column(Sell_to_Customer_Name;"Sell-to Customer Name"){}
            dataitem(SalesLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = salesheader;
                DataItemTableView = SORTING("Document No.", "Line No.") where(quantity = filter('<>0'));
                column(Description; Description) { }
                column(QtytoShip; Quantity) { }
                column(OrderQty; "Order Qty") { }
                column(Bal; Bal) { }
                column(Line_No_; "Line No.") { }
                trigger OnAfterGetRecord()
                begin
                    Clear(Bal);
                    Bal := SalesLine.Quantity - SalesLine."Qty Delivered";
                end;
            }
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

    var
        SLRec: Record "Sales Line";
        SHRec: Record "Sales Header";
        Bal: Decimal;
}
