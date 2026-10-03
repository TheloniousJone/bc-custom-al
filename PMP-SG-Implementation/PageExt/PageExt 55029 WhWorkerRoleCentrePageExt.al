pageextension 55029 WhWorkerRoleCentrePageExt extends 9009
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        addfirst(embedding)
        {
            action("Open WH Trip List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "WH Trip List";
                RunPageLink = "Trip End" = filter(0DT);
            }
            action("Completed WH Trip List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "WH Trip List";
                RunPageLink = "Trip End" = filter(<> 0DT);

            }
            action("All WH Trip List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "WH Trip List";

            }
            action("Delivery Misc Charge List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Delivery Misc Charges List";

            }
            action("TBA List")
            {
                ApplicationArea = All;
                Visible = false;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "TBA Ledger Entry";
            }
            action("LS List")
            {
                ApplicationArea = All;
                Image = List;
                Visible = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "LS Ledger Entry";
            }
            action("Checking List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Checking List";
            }
            action("Stock Take List")
            {
                ApplicationArea = All;
                Image = List;
                Visible = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Stock Take List";
            }
        }


        // Add changes to page actions here
        addafter("Reference Data")
        {
            group(Additional)
            {
                action("System Assignment List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Assignment List";
                }
                action("Zuelig Invoices List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Zuellig Invoices";
                }
                action("PMP Unregistered Picks")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page UnregPLList;
                }
                action("PMP Registered Picks")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page RegWHLinesList;
                }

                action("LS Sales Orders")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page "LS Sales Order List";
                }


            }


        }
    }

    var
        myInt: Integer;
}