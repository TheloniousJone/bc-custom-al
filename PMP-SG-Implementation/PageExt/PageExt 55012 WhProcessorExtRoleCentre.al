pageextension 55012 WhProcessorRoleCentreExt extends 9000
{

    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(TBA; TBACuePage)
            {
                ApplicationArea = all;
                Caption = 'TBA';
                Visible = true;
            }
            part("PMP SOs"; "PMP Activities Cue")
            {
                ApplicationArea = all;
                Caption = 'Company';
                Visible = true;
            }
            part(Dashboard; CuePage)
            {
                ApplicationArea = all;
                Caption = 'Warehouse';
                Visible = true;
            }


            // YF 14 Oct 2021
            part(SOStockQtyCuePage; SOStockQtyCuePage)
            {
                ApplicationArea = All;
                Caption = 'Sales Line Stock Status';
                Visible = true;
            }
            // YF 14 Oct 2021
            //RL    15 Dec 2021

            //RL    15 Dec 2021
            //SJ 20 Dec 2023
            part(OngoingSalesOrderCuePage; OngoingSalesOrderCuePage)
            {
                ApplicationArea = All;
                Caption = 'Ongoing Sales Order';
                Visible = true;
            }
            //SJ 20 Dec 2023
        }
    }
    actions
    {
        addfirst(embedding)
        {
            action("WH Trip List")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "WH Trip List";

            }
            action("Checkings")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Checking List";
            }
        }

        // Add changes to page actions here
        addfirst(creation)
        {
            group(Orders)
            {
                action("LS Sales Orders")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page "LS Sales Order List";
                }
                //DX        02 Aug 2021
                action("Archived Sales Orders")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page ArchiveSOList;
                }
                //DX        02 Aug 2021
            }
        }
        addafter("Sales & Purchases")
        {
            group(Additional)
            {
                action("All WH Trip List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "WH Trip List";

                }
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
                    Image = List;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "TBA Ledger Entry";
                }
                action("LS List")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Image = List;
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

            }
            group("Master Data")
            {


                action("Item Status List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Item Status List";
                }
                action("Forensic Group List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Forensic Group List";
                }
                action("Administration Route List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Administration Route List";
                }
                action("Customer Group List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Group List";
                }
                action("Delivery Zone List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Zone List";
                }
                action("Delivery Charge List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Charge List";
                }
                action("Sales Area List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Sales Area List";
                }
                action("Accpac List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Accpac List";
                }
                action("Picker List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Picker List";
                }
                action("Delivery Schedules")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Schedule";
                }
                //DX        17 June 2021
                action("Customer Exceptions")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Exceptions Order";
                }
                //DX        17 June 2021
                //DX        01 July 2021
                action("Specialties")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Specialties List";
                }

                action("Customer Specialties")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Specialties";
                }
                action("Block Cust-item")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Block Cust-Item";
                }
                action("LS Commission Matrix")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page "LS Commission Matrix";
                }
                //DX        01 July 2021
                //DX        08 Aug 2021
                action(Principal)
                {
                    ApplicationArea = all;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page Princpal;
                }
                //DX        08 Aug 2021
            }

        }
    }

    var
        myInt: Integer;
}