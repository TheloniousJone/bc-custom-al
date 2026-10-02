report 60107 "Ord.Disp.Bal"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Ord-Disp-Bal';
    RDLCLayout = './Report Layouts/ReportLayout 60107 - OrdDispBal.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
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
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(PatientAddress; "ship-to Address" + ' ' + "Ship-to Post Code") { }
            column(PatientContact; "Ship-to Contact") { }
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
