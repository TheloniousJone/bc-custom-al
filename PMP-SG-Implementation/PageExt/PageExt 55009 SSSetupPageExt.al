pageextension 55009 SSSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(Additional)
            {
                field("TBA Adjustment No. Series"; Rec."TBA Adjustment No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Default No. Series for TBA Adjustments.';
                }
                field("Def. Checking Hdr. No. Series"; Rec."Def. Checking Hdr. No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Default No. Series for Warehouse Checking Documents.';
                }
                field("Def. Driver Ship. No. Series"; Rec."Def. Driver Ship. No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Default No. Series for Driver Picking Document.';
                }
                field("Def. WH. Trip No. Series"; Rec."Def. WH. Trip No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Default No. Series for Warehouse Picking Document.';
                }
                field("Def. Stock Take No. Series"; Rec."Def. Stock Take No. Series")
                {
                    ApplicationArea = all;
                }

                field("Auto Assign Picker"; Rec."Auto Assign Picker")
                {
                    ApplicationArea = all;
                    Caption = 'Automatically create assignment entries and assign picker to warehouse trips.';
                }
                field("Auto Create Pick List"; Rec."Auto Create Pick List")
                {
                    ApplicationArea = all;
                    Caption = 'Automatically create picking lists.';
                }
                field("Auto Create WH. Docs When Rel"; Rec."Auto Create WH. Docs When Rel")
                {
                    ApplicationArea = all;
                    ToolTip = 'Enable to automatically create the warehouse documents when order is released.';
                    Caption = 'Auto create WH. Docs when released.';
                }
                field("Def. ZP Invoice Loc. Code"; Rec."Def. ZP Invoice Loc. Code")
                {
                    ApplicationArea = all;
                }
                field("Def. ZP Invoice Bin Code"; Rec."Def. ZP Invoice Bin Code")
                {
                    ApplicationArea = all;
                }

                // YF            22 Oct 2021
                field("Zuellig Def. Inv/CR Cust. Code"; Rec."Zuellig Def. Inv/CR Cust. Code")
                {
                    ApplicationArea = All;
                }
                // YF            22 Oct 2021

                field("Order Taken by To Created"; Rec."Order Taken by To Created")
                {
                    ApplicationArea = all;
                    Caption = 'Set SO Taken by to the user that created it.';
                    ToolTip = 'Enable if you wish to set the user that created the order to be the user that took it.';
                }

                // YF 14 Oct 2024
                //DX            21 Sept 2021
                /*
                field("Def. CS Lead Role ID"; Rec."Def. CS Lead Role ID")
                {
                    ApplicationArea = all;
                    Caption = 'Default CS Lead Role';
                    ToolTip = 'Select role to indicate which role is the CS Lead for allowing to release to warehouse.';
                }
                */
                field("Def. CS Lead Role"; Rec."Def. CS Lead Role")
                {
                    ApplicationArea = all;
                    Caption = 'Default CS Lead Role';
                    ToolTip = 'Select role to indicate which role is the CS Lead for allowing to release to warehouse.';
                }
                //DX            21 Sept 2021
                // YF 14 Oct 2024
                //DX            01 Aug 2021
                field("Auto Del. PL After Reg."; Rec."Auto Del. PL After Reg.")
                {
                    ApplicationArea = all;
                    Caption = 'Automated deletion of pick list after PL Register.';
                    ToolTip = 'Enable to allow system to automatically delete the Pick List after any registering, for full and partial picking.';
                }
                //DX            01 Aug 2021
                //DX        08 Aug 2021
                field("Def. Gen Prod PG for Sample"; Rec."Def. Gen Prod PG for Sample")
                {
                    ApplicationArea = all;
                    Caption = 'Def. Product Posting group for Sample orders to seggregate revenue posting.';
                }
                //DX        08 Aug 2021
                //DX        18 Aug 2021
                field("Def. Disposal Bin"; Rec."Def. Disposal Bin")
                {
                    ApplicationArea = all;
                    ToolTip = 'Default bin to auto reclass the items for Housebrand disposal based on 3 months';

                }
                field("Def. Clearance Bin"; Rec."Def. Clearance Bin")
                {
                    ApplicationArea = all;
                    ToolTip = 'Default bin to auto reclass the items for Housebrand clearance based on 6 months.';
                }
                field("Spec Disposal Bin"; Rec."Spec Disposal Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default bin to auto reclass the items for Proprietary/Specialty disposal based on 3 months.';
                }
                field("Spec Clearance Bin"; Rec."Spec Clearance Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default bin to auto reclass the items for Proprietary/Specialty clearance based on 6 months.';
                }
                field("Exchange Disposal Bin"; Rec."Exchange Disposal Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disposal with Exchange field true.';
                }
                //DX        18 Aug 2021
                field("Check Stock at Approval"; Rec."Check Stock at Approval")
                {
                    ApplicationArea = all;
                }
                group("Logistics Service")
                {
                    field("Def. LS Order No. Series"; Rec."Def. LS Order No. Series")
                    {
                        ApplicationArea = all;
                        Caption = 'Default LS No. Series for Sales orders';
                    }
                    field("Def. LS DO. No. Series"; Rec."Def. LS DO. No. Series")
                    {
                        ApplicationArea = all;
                        Caption = 'Default LS DO No.';
                    }
                    field("Def. LS Inv. No. Series"; Rec."Def. LS Inv. No. Series")
                    {
                        ApplicationArea = all;
                        Caption = 'Default LS Invoice No.';
                    }
                    field("Def. LS Revenue Acct."; Rec."Def. LS Revenue Acct.")
                    {
                        ApplicationArea = all;
                    }
                    // YF 14 Oct 2024
                    /*
                    field("Def. LS Role ID"; Rec."Def. LS Role ID")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Default User Group permission to identify LS Users.';
                    }
                    */
                    field("Def. LS User Group"; Rec."Def. LS User Group")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Default User Group permission to identify LS Users.';
                    }
                    // YF 14 Oct 2024
                    field("Def. Self Pick Method"; Rec."Def. Self Pick Method")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Default Self Pickup method to identify for Logistics Service Transactions.';
                    }
                    field("Def. LS Line Charge Amount"; Rec."Def. LS Line Charge Amount")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Default Line Charge amount for each Logistics Service Transaction.';
                    }
                    field("Def. LS Location Code"; Rec."Def. LS Location COde")
                    {
                        ApplicationArea = all;
                        Caption = 'Def. LS Location Code';
                        ToolTip = 'Location code for Logistics Service.';
                        TableRelation = Location.Code;
                    }
                    field("Def. LS Gen Prod Posting"; Rec."Def. LS Gen Prod Posting")
                    {
                        ApplicationArea = all;
                        Caption = 'Default Gen posting for LS Orders.';
                    }
                    //DX            18 July 2021
                }

            }

            group(QuickFix)
            {
                Caption = 'Quick Fix';

                field("SO Line Qty Quick Fix"; Rec."SO Line Qty Quick Fix")
                {
                    ApplicationArea = All;
                }
            }

            group(GLAccounts)
            {
                Caption = 'Default G/L Accounts';

                field("Staff Claims Payable Account"; Rec."Staff Claims Payable Account")
                {
                    ApplicationArea = All;
                }

                field("Deposit Slip Clearing Account"; Rec."Deposit Slip Clearing Account")
                {
                    ApplicationArea = All;
                }
            }
        }
        addlast(General)
        {
            field("SOA Email Body"; Rec."SOA Email Body")
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            field(I9G_InvoiceFooterMsg; Rec.I9G_InvoiceFooterMsg)
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            field(I9G_SalesTradeAgreementStaging; Rec.I9G_SalesTradeAgreementStaging)
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            field("Distribution Email"; Rec."Distribution Email")
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            //KP 25 Feb 2025 - Auto Invoice Email
            field(I9G_AutoEmailInvBody; Rec.I9G_AutoEmailInvBody)
            {
                ApplicationArea = All;
                MultiLine = true;
                ToolTip = '// - New Line';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

}