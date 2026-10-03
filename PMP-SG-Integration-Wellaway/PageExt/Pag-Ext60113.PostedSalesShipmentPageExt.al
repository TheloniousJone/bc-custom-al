pageextension 60113 PostedSalesShipmentPageExt extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Order Status")
        {
            field("Order Invoiced in PMP"; Rec."Order Invoiced in PMP")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Print Delivery Recipient")
            {
                ApplicationArea = all;
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    ShipRec: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(ShipRec);
                    Report.Run(60105, true, false, ShipRec);
                end;
            }
            action("Print Posted Wellaway Label")
            {
                ApplicationArea = all;
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    ShipRec: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(ShipRec);
                    Report.Run(60109, true, false, ShipRec);
                end;
            }
            action("Print Posted Order Display Balance")
            {
                ApplicationArea = all;
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    ShipRec: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(ShipRec);
                    Report.Run(60110, true, false, ShipRec);
                end;
            }
        }
    }
}
