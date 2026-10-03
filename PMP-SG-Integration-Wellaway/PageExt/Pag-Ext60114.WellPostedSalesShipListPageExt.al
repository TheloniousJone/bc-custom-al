pageextension 60114 WellPostedSalesShipListPageExt extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Order Invoiced in PMP"; Rec."Order Invoiced in PMP")
            {
                ApplicationArea = all;
            }
            //DX        12 Oct 2021
            field("Created By"; WellCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            //DX        12 Oct 2021
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Amend Wellaway Invoiced Status")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    WellCU: Codeunit "Wellaway CU";
                    CustList: Page "Customer List";
                    CustRec: Record customer;
                    selCustRec: Record customer;

                begin
                    if WellCU.IsWellawayCompany() then begin
                        page.run(60111);
                    end else
                        Error('Please only execute this function in the Wellaway Company.');
                end;
            }
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
        }
    }
    var
        WellCU: Codeunit "Wellaway CU";
}
