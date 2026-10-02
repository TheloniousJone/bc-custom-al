pageextension 55002 SalesShipmentPageExt extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            group(Additional)
            {
                field(I9G_NFRemarks; rec.I9G_NFRemarks)
                {
                    applicationArea = All;
                }
                field("SO Placed By"; Rec."SO Placed By")
                {
                    ApplicationArea = all;
                }
                field("Customer Instructions"; Rec."Customer Instructions")
                {
                    ApplicationArea = all;
                }
                field("Picking Instructions"; Rec."Picking Instructions")
                {
                    ApplicationArea = all;
                }
                field("Delivery Instructions"; Rec."Delivery Instructions")
                {
                    ApplicationArea = all;
                }
                field("Order Status"; Rec."Order Status")
                {
                    ApplicationArea = all;
                }
                field("Logistics Service"; Rec."Logistics Service")
                {
                    ApplicationArea = all;
                }
                //DX        17 Aug 2021
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = all;
                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = all;
                    Caption = 'Driver';
                }
                //DX        17 Aug 2021

                field("LS Account"; Rec."LS Account")
                {
                    ApplicationArea = All;
                }

                field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
                {
                    ApplicationArea = All;
                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
                }

            }
        }
        //RL    12 Jan 2022
        addafter("Shipping Agent Code")
        {
            field("Arrival Port"; Rec."Arrival Port")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.")
        {
            field("Sub-Acct Name"; Rec."Sub-Acct Name")
            {
                ApplicationArea = all;
            }
        }
        //RL    12 Jan 2022  
        addafter("Branch/Subsidiary")
        {
            field(I9G_Wellaway_Pick; Rec.I9G_Wellaway_Pick)
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}