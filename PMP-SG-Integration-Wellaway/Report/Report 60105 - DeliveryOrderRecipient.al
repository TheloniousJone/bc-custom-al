report 60105 "Delivery Order Recipient"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Delivery Order - Recipient';
    RDLCLayout = './Report Layouts/ReportLayout 60105 - Delivery Order Recipient.rdl';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Delivery Order - Recipient';
            column(No; "No.")
            {
            }
            column(Document_Date; "Document Date") { }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoCustomerName2; "Sell-to Customer Name 2")
            {
            }
            column(SelltoAddress; "Sell-to Address")
            {
            }
            column(SelltoAddress2; "Sell-to Address 2")
            {
            }
            column(SelltoCity; "Sell-to City")
            {
            }
            column(SelltoCountry; "Sell-to County")
            {
            }
            column(SelltoCountryRegionCode; "Sell-to Country/Region Code")
            {
            }
            column(SelltoPostCode; "Sell-to Post Code")
            {
            }
            column(ShiptoCode; "Ship-to Code")
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(ShiptoName2; "Ship-to Name 2")
            {
            }
            column(ShiptoAddress; "Ship-to Address")
            {
            }
            column(ShiptoAddress2; "Ship-to Address 2")
            {
            }
            column(ShiptoCity; "Ship-to City")
            {
            }
            column(ShiptoCountry; "Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode; "Ship-to Country/Region Code")
            {
            }
            column(ShiptoPostCode; "Ship-to Post Code")
            {
            }
            column(DeliveryInstructions; "Delivery Instructions")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(Order_No_; "Order No.") { }
            column(CompanyPic; CompanyInfor.Picture)
            {
            }
            column(CopanyAdd; CompanyInfor.Address)
            {
            }
            column(CompanyTel; CompanyInfor."Phone No.") { }
            column(CompanyCoNo; CompanyInfor."Registration No.") { }
            column(CompanyGSTNo; CompanyInfor."VAT Registration No.") { }
            //DX        07 Oct 2021
            column(External_Document_No_; "External Document No.")
            {

            }
            //DX        07 Oct 2021
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(No_; "No.") { }
                column(Description; Description) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Type; Type) { }
                column(Order_Qty; "Order Qty") { }
                column(Quantity_Invoiced; "Quantity Invoiced") { }
                //Cancel Qty
                column(Batch; Batch) { }
                column(ExpiryDate; ExpiryDate) { }
                column(Remarks; Remarks) { }
                column(Selling_Price; "Selling Price") { }
                column(To_Del__Amt; "To Del. Amt") { }

                trigger OnAfterGetRecord()
                begin
                    Clear(Batch);
                    Clear(ExpiryDate);
                    ILJRec.Reset();
                    ILJRec.SetRange("Document Type", ILJRec."Document Type"::"Sales Shipment");
                    ILJRec.SetRange("Document No.", "Sales Shipment Line"."Document No.");
                    ILJRec.SetRange("Item No.", "Sales Shipment Line"."No.");
                    if ILJRec.FindSet() then begin
                        repeat
                            Batch := ILJRec."Lot No.";
                            ExpiryDate := ILJRec."Expiration Date";
                        until ILJRec.Next() = 0;
                    end;
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


    trigger OnInitReport();
    begin
        CompanyInfor.GET;
        CompanyInfor.CALCFIELDS(Picture);
    end;



    var
        ExpiryDate: Date;
        Batch: Code[50];
        Remarks: Text[250];
        ILJRec: Record "Item Ledger Entry";
        SSHRec: Record "Sales Shipment Header";
        SSLRec: Record "Sales Shipment Line";
        CompanyInfor: Record "Company Information";
        ILETemp: Record "Item Ledger Entry" temporary;
        ItemTrackDocMngt: Codeunit "Item Tracking Doc. Management";

}
