pageextension 55003 SalesInvPageExt extends "Sales Invoice"
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
                field("Order Taken By"; Rec."Order Taken By")
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
                field(I9G_Import_License_No; Rec.I9G_Import_License_No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Import License No (For Unregistered TP) field.';
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
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
            }
        }
        // YF 08 Oct Nov 2021 // Disabled as not working as intended
        /*
        addafter(Status)
        {
            // YF 27 Oct 2021
            field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
            {
                ApplicationArea = All;
            }

            field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
            {
                ApplicationArea = All;
            }

            field("Invoice Discount Value"; Rec."Invoice Discount Value")
            {
                ApplicationArea = All;
            }
            // YF 27 Oct 2021
        }
        */
        // YF 08 Oct Nov 2021 // Disabled as not working as intended

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
        addafter("&Invoice")
        {
            group("Actions")
            {
                //DX        01 Jun 2021
                action("Generate LS Invoice")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LSList: Page "LS Ledger Entry";
                        LSRecFilter: Record "LS Ledger Entry";
                        LSSelRec: Record "LS Ledger Entry";
                        LSCU: Codeunit ls;
                        CUstRec: Record customer;
                        TotalAmt: Decimal;
                    begin
                        LSRecFilter.RESET;
                        LSRecFilter.SETRANGE("Customer No.", Rec."Sell-to Customer No.");
                        LSRecFilter.SetRange(Closed, false);
                        Clear(LSList);
                        LSList.SETTABLEVIEW(LSRecFilter);
                        LSList.LOOKUPMODE := TRUE;
                        LSList.CAPTION := 'Select list of LS lines to invoice';
                        if LSList.RunModal() = action::LookupOK then begin
                            LSList.SetSelectionFilter(LSSelRec);
                            CUstRec.reset;
                            CUstRec.SetRange("No.", Rec."Sell-to Customer No.");
                            if CUstRec.FindFirst() then begin
                                //DX        Check if customer LS is charged by what method
                                if CustRec.FindFirst() then begin
                                    if CustRec."LS Percentage" = 0 then
                                        Error('LS Percentage is currently set at 0, please set correctly before executing this process.');
                                end;
                            end;
                            if LSSelRec.FindSet() then
                                repeat
                                    TotalAmt += LSSelRec."Commission Amount";
                                    LSSelRec.Closed := true;    //DX Set to closed so that it will not trigger for invoicing again.
                                    LSSelRec."Closed By" := Rec."No.";
                                    LSSelRec.Modify(false);
                                until LSSelRec.next = 0;
                            LSCU.CreateLSInvLine(TotalAmt, rec);
                            Message('Transactions retrieved.');
                        end;
                    end;
                }
                //DX        01 Jun 2021
            }
        }

        addlast("&Invoice")
        {
            action(UpdateLot)
            {
                Caption = 'Update Lot No.';
                Image = UpdateDescription;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All; //KM20210617

                trigger OnAction()
                var
                    lcdu_IT: Codeunit "Item Track CU";
                begin
                    //Message('%1', "No.");
                    lcdu_IT.ClearTrackingLinesSO(Rec."No.");
                    lcdu_IT.AutoPopulateTrackingSO(Rec."No.");
                end;
            }

        }
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
        modify(PostAndNew)
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
        LSCU: Codeunit LS;
}