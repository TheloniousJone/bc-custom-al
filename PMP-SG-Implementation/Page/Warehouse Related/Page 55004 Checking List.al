page 55004 "Checking List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checking Header";
    Editable = false;
    CardPageId = "Checking Card";
    SourceTableView = sorting("No.") order(descending);
    layout

    {
        area(Content)
        {
            repeater(Details)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;

                }

                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;

                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Basket No."; Rec."Basket No.")
                {
                    ApplicationArea = all;
                }
                field("2nd Basket No."; Rec."2nd Basket No.")
                {
                    ApplicationArea = all;
                }

                field(Picker; Rec.Picker)
                {
                    ApplicationArea = All;

                }
                field("Shipping Bin"; Rec."Shipping Bin")
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Zone';
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {

        area(Processing)
        {


            action("Check Picking Lists for Item")
            {

                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SetPriorities;
                RunObject = page CheckItemPick;
                trigger OnAction()
                var

                begin

                end;
            }
        }
    }


    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //DX        30 Aug 2021
        /*
        Rec.FilterGroup(2);
        Rec.SetFilter(SystemCreatedBy, '%1|%2', '', EnhanceCU.GetUserGUID());

        Rec.FilterGroup(0);
        //DX        30 Aug 2021
        */
        rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());
    end;

    var
        PMPCU: Codeunit "Warehouse CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
}