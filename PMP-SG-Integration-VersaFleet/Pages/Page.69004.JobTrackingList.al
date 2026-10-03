page 69004 "VF Job Tracking List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'VersaFleet Job Tracking List';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    SourceTable = "VF Job Tracking";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Job Type"; Rec."Job Type")
                {
                    ApplicationArea = All;
                }

                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = All;
                }

                field("PMP VersaFleet Customer ID"; Rec."PMP VersaFleet Customer ID")
                {
                    ApplicationArea = All;
                }

                field("Base Task Time From Text"; Rec."Base Task Time From Text")
                {
                    ApplicationArea = All;
                }

                field("Base Task Time To Text"; Rec."Base Task Time To Text")
                {
                    ApplicationArea = All;
                }

                field("Base Task Time Type"; Rec."Base Task Time Type")
                {
                    ApplicationArea = All;
                }

                field("Base Task Service Time"; Rec."Base Task Service Time")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Name"; Rec."PMP-WH Name")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Address"; Rec."PMP-WH Address")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Address 2"; Rec."PMP-WH Address 2")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH City"; Rec."PMP-WH City")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Country"; Rec."PMP-WH Country")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Post Code/Zip"; Rec."PMP-WH Post Code/Zip")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH E-Mail"; Rec."PMP-WH E-Mail")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Contact Person"; Rec."PMP-WH Contact Person")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Contact Number"; Rec."PMP-WH Contact Number")
                {
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }

                field("VF Job ID"; Rec."VF Job ID")
                {
                    ApplicationArea = All;
                }

                field("VF Job GUID"; Rec."VF Job GUID")
                {
                    ApplicationArea = All;
                }

                field("VF Job State"; Rec."VF Job State")
                {
                    ApplicationArea = All;
                }

                field("VF Job Archived"; Rec."VF Job Archived")
                {
                    ApplicationArea = All;
                }

                field("VF Task ID"; Rec."VF Task ID")
                {
                    ApplicationArea = All;
                }

                field("VF Task GUID"; Rec."VF Task GUID")
                {
                    ApplicationArea = All;
                }

                field("VF Task State"; Rec."VF Task State")
                {
                    ApplicationArea = All;
                }

                field("Base Job Service Time"; Rec."Base Job Service Time")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    actions
    {
        // actions here
    }

}
