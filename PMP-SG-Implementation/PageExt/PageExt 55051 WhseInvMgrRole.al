pageextension 55051 WhseInvMgrRole extends "Whse. Basic Role Center"
{
    layout
    {

    }
    actions
    {
        addfirst(creation)
        {
            group(Orders)
            {
                action("LS Sales Orders")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page "LS Sales Order List";
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
                //DX        02 Aug 2021
                action("Archived Sales Orders")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = page ArchiveSOList;
                }
                //DX        02 Aug 2021
            }
        }
        addafter("&Purchase Order")
        {

            group(Process)
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
                action("TBA List")
                {
                    ApplicationArea = All;
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


                action("Trolley List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Trolley List";
                }

                action("Item Status List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Item Status List";
                }
                action("POM2 Therapeutic Group")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "POM2 Therapeutic Group";
                }
                action("POM3 Therapeutic Group")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "POM3 Therapeutic Setup";
                }
                action("Forensic Group List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Forensic Group List";
                }
                action("Administration Route List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Administration Route List";
                }
                action("Customer Group List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Group List";
                }
                action("Delivery Zone List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Zone List";
                }
                action("Delivery Charge List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Charge List";
                }
                action("Sales Area List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Sales Area List";
                }
                action("Accpac List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Accpac List";
                }
                action("Picker List")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Picker List";
                }
                action("Delivery Schedules")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Schedule";
                }
                //DX        17 June 2021
                action("Customer Exceptions")
                {
                    ApplicationArea = All;
                    Image = ShowList;
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
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Specialties List";
                }

                action("Customer Specialties")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Specialties";
                }
                action("Block Cust-item")
                {
                    ApplicationArea = All;
                    Image = ShowList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Block Cust-Item";
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
}
