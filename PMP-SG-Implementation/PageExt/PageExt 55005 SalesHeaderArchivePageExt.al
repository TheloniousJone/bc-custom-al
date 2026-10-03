pageextension 55005 SalesHeaderArchivePageExt extends "Sales Order Archive"
{
    layout
    {

        // Add changes to page layout here
        addlast(General)
        {
            group(Additional)
            {
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
                field(Invoice; rec.Invoice)
                {
                    ApplicationArea = All;
                }
                field(I9G_Import_License_No; Rec.I9G_Import_License_No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Import License No (For Unregistered TP) field.';
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
        //RL    12 Jan 2022  
        addafter(I9G_Import_License_No)
        {
            field(I9G_Wellaway_Pick; Rec.I9G_Wellaway_Pick)
            {
                ApplicationArea = all;
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