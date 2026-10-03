page 55009 "Driver Shipping Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Driver Shipping Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")

                {
                    ApplicationArea = all;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Delivery Instructions"; Rec."Delivery Instructions")
                {
                    ApplicationArea = all;
                }
                field("Shipping Packacges"; Rec."Shipping Packacges")
                {
                    ApplicationArea = all;
                    Caption = 'Shipping Packages';
                    Editable = false;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {

        }
    }
}