report 60111 "Wellaway Sales Report"
{
    ApplicationArea = All;
    Caption = 'Wellaway Sales Report';
    RDLCLayout = './Report Layouts/ReportLayout 60111 - Wellaway Sales Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            RequestFilterFields = "Document No.", "Posting Date";
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Description2; "Description 2")
            {
            }
            column(QtyDelivered; "Qty Delivered")
            {
            }
            column(QtyToDeliver; "Qty To Deliver")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(QuantityBase; "Quantity (Base)")
            {
            }
            column(SellingPrice; "Selling Price")
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(PostingDate; format("Posting Date"))
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {

            }
            column(amount; Quantity * "Unit Price")
            {

            }
            dataitem(ShipHeader; "Sales Shipment Header")
            {
                DataItemLink = "No." = field("Document No.");
                column(ClinicNo; shipheader."Sell-to Customer No.")
                {

                }
                column(ClinicName; shipheader."Sell-to Customer Name")
                {

                }
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
}
