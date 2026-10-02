pageextension 60108 WellSalesOrderListPageExt extends "Sales Order List"
{
    layout
    {
        addafter("Order Status")
        {
            field("Patient Name"; Rec."Patient Name")
            {
                ApplicationArea = all;
            }
            field("Order Invoiced in PMP"; Rec."Order Invoiced in PMP")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Create Transfer Journals")
            {
                ApplicationArea = all;
                Visible = VisibleBool;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Process;
                trigger OnAction()
                var
                    myInt: Integer;
                    SOPage: Page "Transfer Creation";
                begin
                    SOPage.RunModal();
                end;
            }
            action("View Wellaway Sales Report")
            {
                ApplicationArea = all;
                Visible = VisibleBool;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Process;
                RunObject = report 60111;
                trigger OnAction()
                var
                    myInt: Integer;

                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if WellCU.IsWellawayCompany() then
            VisibleBool := true else
            VisibleBool := false;
    end;

    var
        WellCU: Codeunit "Wellaway CU";
        VisibleBool: Boolean;
}
