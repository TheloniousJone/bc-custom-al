pageextension 55004 SalesCrMemoPageExt extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            group(Additional)
            {
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
                field(Rebill; Rec.Rebill)
                {
                    ApplicationArea = all;
                }
                field("Rebill SO"; Rec."Rebill SO")
                {
                    ApplicationArea = all;
                }
                //DX        22 Aug 2021

                field("LS Account"; Rec."LS Account")
                {
                    ApplicationArea = All;
                }

                field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
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
        addafter("Shipment Date")
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
        addafter("Shortcut Dimension 2 Code")
        {
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;

            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
                Visible = true;
            }
            field(ShortcutDim5Code; Rec.ShortcutDim5Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim6Code; Rec.ShortcutDim6Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim7Code; Rec.ShortcutDim7Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim8Code; Rec.ShortcutDim8Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        //DX        17 Sept 2021
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                CustRec: Record customer;
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    CustRec.reset;
                    CustRec.get(Rec."Sell-to Customer No.");
                    if CustRec."Mandatory Ext Doc. No." = true then begin
                        if Rec."External Document No." = '' then
                            Error('Please ensure Customer PO (Ext Doc No.) is entered before releasing to warehouse.');
                    end;
                end;

            end;
        }

        //DX        17 Sept 2021
    }

    var
        myInt: Integer;
}