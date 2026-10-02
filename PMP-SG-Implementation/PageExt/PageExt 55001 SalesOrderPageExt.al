pageextension 55001 SalesOrderPageExt extends "Sales Order"
{

    layout
    {
        addfirst(factboxes)
        {

            part(PMPCardPart; PMPCardPart)
            {
                //DX        18 Aug 2021
                //SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Line No." = FIELD("Line No.");
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                //DX        18 Aug 2021
            }

            // YF        14 Oct 2021
            part(LotNoByBin; "Lot Numbers by Bin FactBox")
            {
                ApplicationArea = Suite, ItemTracking;
                Provider = SalesLines;
                SubPageLink = "Item No." = FIELD("No."),
                              "Variant Code" = FIELD("Variant Code"),
                              "Location Code" = FIELD("Location Code");
            }
            // YF        14 Oct 2021

        }

        // Add changes to page layout here
        addlast(General)
        {

            group(Additional)
            {
                //DX        30 Aug 2021
                group("Delivery Related")
                {
                    field(I9G_NFRemarks; rec.I9G_NFRemarks)
                    {
                        applicationArea = All;
                    }
                    field("Delivery Charge"; Rec."Delivery Charge")
                    {
                        ApplicationArea = all;
                    }
                    field("Delivery Zone"; Rec."Delivery Zone")
                    {
                        ApplicationArea = all;
                        Caption = 'Driver';
                    }
                    field("SO Placed By"; Rec."SO Placed By")
                    {
                        ApplicationArea = all;
                    }
                    field("Order Taken By"; Rec."Order Taken By")
                    {
                        ApplicationArea = all;
                    }
                    //DX        30 Aug 2021
                    field("Customer Instructions"; Rec."Customer Instructions")
                    {
                        ApplicationArea = all;
                        MultiLine = true;
                        Importance = Additional;

                    }
                    field("Picking Instructions"; Rec."Picking Instructions")
                    {
                        ApplicationArea = all;
                        MultiLine = true;
                        Importance = Additional;
                    }
                    field("Delivery Instructions"; Rec."Delivery Instructions")
                    {
                        ApplicationArea = all;
                        MultiLine = true;
                        Importance = Additional;
                    }
                    field(StatusRemarks; StatusRemarks)
                    {
                        ApplicationArea = all;
                        MultiLine = true;
                    }

                    field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
                    {
                        ApplicationArea = All;
                    }
                    field(WorkHr; WorkHr)
                    {
                        ApplicationArea = all;
                        Caption = 'Working Hours';
                        Editable = false;
                    }
                    field(I9G_Import_License_No; Rec.I9G_Import_License_No)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Import License No (For Unregistered TP) field.';
                    }
                    field("WS Membership"; Rec."WS Membership")
                    {
                        ApplicationArea = all;
                        LookupPageId = "WS Membership";
                    }
                    field("Customer Group"; Rec."Customer Group")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
                    }
                    field(I9G_ContractRef; Rec.I9G_ContractRef)
                    {
                        ApplicationArea = All;
                    }
                }


                group("LS. Related")
                {
                    field("Logistics Service"; Rec."Logistics Service")
                    {
                        ApplicationArea = all;
                        Importance = Additional;
                    }
                    field("LS Account"; Rec."LS Account")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            //DX        26 Sept 2021        #327


                            //DX        26 Sept 2021
                        end;
                    }
                }

                group("Order Related")
                {
                    field("TBA Order"; Rec."TBA Order")
                    {
                        ApplicationArea = all;

                    }
                    field("Order Status"; Rec."Order Status")
                    {
                        ApplicationArea = all;
                        //Editable = false;
                    }
                    field("Max Qty Item App. Required"; Rec."Max Qty Item App. Required")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Credit Period App. Required"; Rec."Credit Period App. Required")
                    {
                        ApplicationArea = all;
                        Importance = Additional;
                        Editable = false;
                    }
                    //DX        02 Aug 2021
                    field(Archived; Rec.Archived)
                    {
                        ApplicationArea = all;

                        Importance = Additional;
                    }
                    //DX        02 Aug 2021
                    //DX        08 Aug 2021
                    field("Samples SO"; Rec."Samples SO")
                    {
                        ApplicationArea = all;
                        Caption = 'For Sample';
                        //YF        06 Jul 2022 - Start
                        trigger OnValidate()
                        var
                            SRSetup: Record "Sales & Receivables Setup";
                            SLRec: Record "Sales Line";
                            ItemRec: Record Item;
                        begin
                            // CurrPage.SaveRecord();
                            CurrPage.Update(true);

                            SRSetup.Get;
                            SLRec.Reset();
                            SLRec.SetRange("Document No.", Rec."No.");
                            SLRec.SetRange("Document Type", Rec."Document Type");
                            SLRec.SetRange(Type, SLRec.Type::Item);
                            if SLRec.FindSet() then
                                repeat
                                    if ItemRec.Get(SLRec."No.") then begin
                                        if Rec."Samples SO" then
                                            SLRec.Validate("Gen. Prod. Posting Group", SRSetup."Def. Gen Prod PG for Sample")
                                        else
                                            SLRec.Validate("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");

                                        SLRec.Modify();
                                    end;
                                until SLRec.Next() = 0;



                        end;
                        //YF        06 Jul 2022 - End
                    }
                    field("Hold"; Rec."Hold")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Enable this to on hold the order so that any warehouse user will be prompted that this order is to be on hold.';
                    }
                    //DX        08 Aug 2021
                    //DX        17 Aug 2021

                    field("Priority Picking"; Rec."Priority Picking")
                    {
                        ApplicationArea = all;
                    }

                    //DX        17 Aug 2021
                }

                group("Chain Integration")
                {
                    // YF        24 Aug 2021        // For Integration Source Reference
                    field("PO Integration Source"; Rec."PO Integration Source")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("PO Integration Source Ref No."; Rec."PO Integration Source Ref No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Chain Pharmacy"; Rec."Chain Pharmacy")
                    {
                        ApplicationArea = all;
                        Editable = true;
                        Importance = Additional;
                    }
                    // YF        24 Aug 2021        // For Integration Source Reference
                }
            }
            field("I9G_RequirementApproval"; Rec."I9G_RequirementApproval")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1900201301)
        {
            field("DO No."; Rec."Shipping No.")
            {
                ApplicationArea = all;
            }
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = all;
            }
            field(I9G_Ready_to_Process_SO; Rec.I9G_Ready_to_Process_SO)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ready to Process_SO field.';
                Visible = false;
            }
            field(I9G_Push_to_Open_SO; Rec.I9G_Push_to_Open_SO)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Push to Open SO field.';
                Visible = false;
            }



        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }

        //DX        15 Aug 2021
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                CustRec: Record customer;
                DimSetEntry: Record "Dimension Set Entry";
            begin
                WorkHr := '';
                if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then begin
                    CustRec.reset;
                    CustRec.SetLoadFields("No.", "Working Hours", "Delivery Zone");   //DX      06 May 2023
                    CustRec.SetRange("No.", Rec."Sell-to Customer No.");
                    if CustRec.FindFirst() then begin
                        WorkHr := CustRec."Working Hours";
                        rec."Delivery Zone" := CustRec."Delivery Zone"; //RL 09 Dec 2021
                    end;


                end;
                // Message('%1', format(Rec."Dimension Set ID"));
                // DimSetEntry.Reset();
                // DimSetEntry.FilterGroup(2);
                // DimSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
                // DimSetEntry.FilterGroup(0);
                // if DimSetEntry.FindSet() then
                //     repeat
                //         Message('%1 %2', format(DimSetEntry."Dimension Set ID"), DimSetEntry."Dimension Value Code");
                //     until DimSetEntry.Next() = 0;
            end;
        }
        //DX        15 Aug 2021        

        // YF        14 Oct 2021       
        addafter(Status)
        {
            field("Out of Stock"; Rec."Out of Stock")
            {
                ApplicationArea = All;
                Caption = 'Out of Stock';
                Style = Favorable;
                StyleExpr = OOSBool;
                Editable = false;
            }

            field("Insufficient Stocks in Pick"; Rec."Insufficient Stocks in Pick")
            {
                ApplicationArea = All;
                Caption = 'Insufficient Stocks in Active Area';
                Style = Favorable;
                StyleExpr = IStkBool;
                Editable = false;
            }

            // YF 22 Nov 2021
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
            // YF 22 Nov 2021

            // YF 08 Nov 2021 // Disabled as not working as intended
            /*
            // YF 27 Oct 2021
            field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
            {
                ApplicationArea = All;
            }

            field("Invoice Discount Amount"; Rec."Invoice Discount Amount")
            {
                ApplicationArea = All;
                Editable = true; // YF 08 Nov 2021 // Bug fix/troubleshooting
            }

            field("Invoice Discount Value"; Rec."Invoice Discount Value")
            {
                ApplicationArea = All;
            }
            // YF 27 Oct 2021
            */
            // YF 08 Nov 2021 // Disabled as not working as intended

        }

        // YF        14 Oct 2021    
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
            // field("Customer Posting Group."; Rec."Customer Posting Group")
            // {
            //     ApplicationArea = all;
            //     Visible = false;
            //     Editable = true;
            // }
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

        addafter("Priority Picking")
        {
            field(I9G_Wellaway_Pick; Rec.I9G_Wellaway_Pick)
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnValidate()
                var
                    lrec_salesline: Record "Sales Line";
                begin
                    if Rec.I9G_Wellaway_Pick = true then begin
                        Rec.Validate("Location Code", 'WELLAWAY');
                        lrec_salesline.Reset();
                        lrec_salesline.SetRange("Document Type", Rec."Document Type");
                        lrec_salesline.SetRange("Document No.", Rec."No.");
                        if lrec_salesline.FindSet() then begin
                            repeat
                                if lrec_salesline.Type = lrec_salesline.type::Item then begin
                                    lrec_salesline.Validate("Location Code", 'WELLAWAY');
                                    lrec_salesline.Modify(false);
                                end;
                            until lrec_salesline.Next() = 0;
                        end;
                    end;
                end;
            }
        }
    }
    //DX        18 Aug 2021


    //DX        18 Aug 2021
    actions
    {
        // Add changes to page actions here
        addafter("Create &Warehouse Shipment")
        {
            group("Actions")
            {
                //DX        01 Jun 2021
                action("Delete Warehouse Documents")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ALERec: Record "Assignment Ledger Entry";
                    begin

                        if not (Rec."Order Status" in [Rec."Order Status"::Open, Rec."Order Status"::Processing]) then
                            Error('Picking list has been processed already, unable to delete.');

                        If confirm('Are you sure you wish to delete the warehouse documents?') then begin
                            WHCU.DeleteWHShipmentAndPicking(Rec);
                            Rec."Order Status" := rec."Order Status"::Open;
                            Rec.Modify(FALSE);
                        end;
                    end;
                }
                //DX        01 Jun 2021
            }
        }
        modify("Create &Warehouse Shipment")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedOnly = true;
            PromotedCategory = Process;

            trigger OnBeforeAction()
            var
                CustRec: Record customer;
                WHShipLineRec: Record "Warehouse Shipment Line";
                WHShipHeaderRec: Record "Warehouse Shipment Header";
                SSSetup: Record "Sales & Receivables Setup";
                CustomEventCU: Codeunit CustomEvents;
            begin
                //DX        03 Apr 2026     Created for POM to call event to check, for Sabrina request 
                CustomEventCU.OnBeforeCreateWarehouseShipmentFromSOtoWH(Rec);

                //DX        21 Sept 2021
                if NOT (PMPCU.IsCSLead()) then begin
                    Error('You are not allowed to release to warehouse, please check with your team lead.');

                end;

                //DX        21 Sept 2021

                //DX        01 Jun 2021

                CustRec.reset;
                CustRec.SetLoadFields("No.", "Mandatory Ext Doc. No."); //DX      06 May 2023
                CustRec.SetRange("No.", Rec."Sell-to Customer No.");
                if CustRec.FindFirst() then begin
                    if CompanyName = 'PMP' then
                        CustRec.TestField("Delivery Zone");

                    if CustRec."Mandatory Ext Doc. No." = true then begin
                        if Rec."External Document No." = '' then
                            Error('Please ensure Customer PO (Ext Doc No.) is entered before releasing to warehouse.');
                    end;
                    //DX        27 Jun 2021

                    Message('%1', CustRec."Working Hours");
                end;

                //DX        01 Jun 2021

                //DX        20 Aug 2021     : Just delete any warehouse when they try to create a new whdoc.
                //DX        20 Aug 2021     : If got warehouse shipment completed, just delete away and recreate again

                if WHCU.PLisValid(Rec) then
                    Error('Pick list is still outstanding, you are not allowed to create another pick list.');
                //WHCU.DeleteWHShipmentAndPicking(Rec);

                WHShipLineRec.reset;
                WHShipLineRec.SetRange("Source No.", Rec."No.");
                if WHShipLineRec.FindFirst() then begin
                    WHShipHeaderRec.reset;
                    WHShipHeaderRec.SetRange("No.", WHShipLineRec."No.");
                    if WHShipHeaderRec.FindFirst() then begin
                        WHShipHeaderRec.Validate(Status, WHShipHeaderRec.Status::Open);
                        WHShipHeaderRec.Modify(true);
                        WHShipHeaderRec.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
                    end;
                end;

                //DX        20 Aug 2021
            end;


        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }

        addlast("O&rder")
        {
            action(UpdateLot)
            {
                Caption = 'Update Lot No.';
                Image = UpdateDescription;
                Visible = false;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All; //KM20210618 

                trigger OnAction()
                var
                    lcdu_IT: Codeunit "Item Track CU";
                begin
                    //Message('%1', "No.");
                    lcdu_IT.ClearTrackingLinesSO(Rec."No.");
                    lcdu_IT.AutoPopulateTrackingSO(Rec."No.");
                    message('Item Batches selected.');
                end;
            }

            action(RefreshStockStatusFlag)
            {
                Caption = 'Refresh Stock Status Flag';
                Image = RefreshLines;
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec."Out of Stock" := Not PMPCU.CheckSOEnoughStockAll(Rec);
                    Rec."Insufficient Stocks in Pick" := Not PMPCU.CheckSOEnoughStockPickArea(Rec);
                    CurrPage.Update(true);
                    Message('Stock Status Refreshed');
                end;
            }
        }

        // YF     15 Oct 2021
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                EnhanceCU: Codeunit "PMP-Enhancements";
                CLERec: Record "Cust. Ledger Entry";
                CompanyInformation: Record "Company Information";
            begin
                // YF     15 Oct 2021
                Rec."Out of Stock" := Not PMPCU.CheckSOEnoughStockAll(Rec);
                Rec."Insufficient Stocks in Pick" := Not PMPCU.CheckSOEnoughStockPickArea(Rec);
                Rec.Modify(false);

                CompanyInformation.Get();
                if CompanyInformation.I9G_ArdencePharma = false then begin
                    if Rec."Out of Stock" Or Rec."Insufficient Stocks in Pick" then begin
                        if Not Confirm('Out of Stock or Insufficient Stock Detected. Continue?', false) then begin
                            Commit();
                            Error('Out of Stock or Insufficient Stock Detected. Action Stopped');
                        end;
                    end;
                end;
                // YF     15 Oct 2021

                //RL    08 Feb 2023
                CLERec.Reset();
                CLERec.SetLoadFields("Sell-to Customer No.", "Document Type", "Remaining Amount", "Due Date");     //DX        06 May 2023
                if (Rec."Payment Terms Code" = 'COD') or (Rec."Payment Terms Code" = 'CODND') then begin

                    CLERec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange("Document Type", Rec."Document Type"::Invoice);
                    CLERec.SetFilter("Remaining Amount", '>%1', 0);
                    CLERec.SetFilter("Due Date", '..%1', CalcDate('<-15D>', WorkDate()));       //DX        05 May 2026 Change to 15 from 60D as requested by Sabrina
                    if CLERec.FindFirst() then begin
                        Rec."Credit Period App. Required" := true;
                        Rec.Modify(false);
                    end else begin
                        Rec."Credit Period App. Required" := false;
                        Rec.Modify(false);

                    end;

                end else begin
                    CLERec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange("Document Type", Rec."Document Type"::Invoice);
                    CLERec.SetFilter("Remaining Amount", '>%1', 0);
                    CLERec.SetFilter("Due Date", '..%1', CalcDate('<-60D>', WorkDate()));   //DX        05 May 2026 Change to 15 from 60D as requested by Sabrina
                    if CLERec.FindFirst() then begin
                        Rec."Credit Period App. Required" := true;
                        Rec.Modify(false);
                    end else begin
                        Rec."Credit Period App. Required" := false;
                        Rec.Modify(false);

                    end;

                end;
                //RL    08 Feb 2023
            end;

        }
        // YF     15 Oct 2021

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                LSHRec: Record "Sales Header";
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                EnhanceCU: Codeunit "PMP-Enhancements";
                SSSetup: Record "Sales & Receivables Setup";
                CLERec: Record "Cust. Ledger Entry";
                CompanyInformation: Record "Company Information";
            begin

                // YF     15 Oct 2021
                Rec."Out of Stock" := Not PMPCU.CheckSOEnoughStockAll(Rec);
                Rec."Insufficient Stocks in Pick" := Not PMPCU.CheckSOEnoughStockPickArea(Rec);
                Rec.Modify(false);

                CompanyInformation.Get();
                if CompanyInformation.I9G_ArdencePharma = false then begin
                    if Rec."Out of Stock" Or Rec."Insufficient Stocks in Pick" then begin
                        if Not Confirm('Out of Stock or Insufficient Stock Detected. Continue?', false) then begin
                            Commit();
                            Error('Out of Stock or Insufficient Stock Detected. Action Stopped');
                        end;
                    end;
                end;
                // YF     15 Oct 2021

                if CompanyInformation.I9G_ArdencePharma = false then begin
                    //DX     06 Oct 2021
                    rec.CalcFields(Amount);
                    If Rec.Amount < 100 then
                        Message('Amount is less than $100.00, please ensure amount is correct before approval.');
                    //DX     06 Oct 2021
                end;

                //DX        01 Sept 2021
                SSSetup.reset;
                SSSetup.get;
                if SSSetup."Check Stock at Approval" then begin
                    if WHCU.AllLinesHaveStock(Rec) <> '' then
                        Error(StrSubstNo('Order item %1 has insufficient stock, not allowed to release.', WHCU.AllLinesHaveStock(Rec)));
                end;
                if Rec.Hold = true then begin
                    Error('Order is on hold, please uncheck before sending for approval.');
                end;
                //DX        01 Sept 2021                            

                //DX        20 Sept 2021
                //RL        12 Oct 2021 - Remove to avoid error
                // if EnhanceCU.SHHasEnoughStock(Rec) = false then
                //     Error('Sales order does not have enough stock, you are unable to release this order.');
                //DX        20 Sept 2021

                //RL    08 Feb 2023
                CLERec.Reset();
                CLERec.SetLoadFields("Sell-to Customer No.", "Document Type", "Remaining Amount", "Due Date"); //DX     06 May 2023

                if (Rec."Payment Terms Code" = 'COD') or (Rec."Payment Terms Code" = 'CODND') then begin

                    CLERec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange("Document Type", Rec."Document Type"::Invoice);
                    CLERec.SetFilter("Remaining Amount", '>%1', 0);
                    CLERec.SetFilter("Due Date", '..%1', CalcDate('<-15D>', WorkDate()));   //DX        05 May 2026 Change to 15 from 60D as requested by Sabrina
                    if CLERec.FindFirst() then begin
                        Rec."Credit Period App. Required" := true;
                        Rec.Modify(false);
                    end else begin
                        Rec."Credit Period App. Required" := false;
                        Rec.Modify(false);

                    end;

                end else begin
                    CLERec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    CLERec.SetRange("Document Type", Rec."Document Type"::Invoice);
                    CLERec.SetFilter("Remaining Amount", '>%1', 0);
                    CLERec.SetFilter("Due Date", '..%1', CalcDate('<-60D>', WorkDate()));   //DX        05 May 2026 Change to 15 from 60D as requested by Sabrina
                    if CLERec.FindFirst() then begin
                        Rec."Credit Period App. Required" := true;
                        Rec.Modify(false);
                    end else begin
                        Rec."Credit Period App. Required" := false;
                        Rec.Modify(false);

                    end;

                end;
                //RL    08 Feb 2023
            end;
        }
        //DX        08 Sept 2021
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                ALERec: Record "Assignment Ledger Entry";
            begin
                if not (Rec."Order Status" in [Rec."Order Status"::Open, Rec."Order Status"::Processing]) then //RL 20 Dec 2021 added 1 more condition
                    Error('Warehouse has processed this order, not allowed to reopen the SO.');
            end;

            trigger OnAfterAction()
            begin
                //DX        12 Sept 2021
                WHCU.DeleteWHShipmentAndPicking(Rec);
                Rec."Order Status" := rec."Order Status"::Open;
                Rec.Modify(FALSE);
                //DX        12 Sept 2021
            end;
        }
        //DX        08 Sept 2021

    }

    trigger OnAfterGetRecord()
    begin
        // YF        14 Oct 2021
        OOSBool := Not Rec."Out of Stock";
        IStkBool := Not Rec."Insufficient Stocks in Pick";
        // YF        14 Oct 2021
        GetStatusRemarks; //RL         28 Oct 2021

        WorkHr := '';

        CustRec.reset;
        CustRec.SetLoadFields("No.", "Working Hours");   //DX      06 May 2023
        CustRec.SetRange("No.", Rec."Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            WorkHr := CustRec."Working Hours";
        end;
    end;

    //RL         28 Oct 2021
    local procedure GetStatusRemarks()
    var
        CustRec: Record Customer;
    begin
        StatusRemarks := '';
        CustRec.Reset();
        CustRec.SetRange("No.", Rec."Bill-to Customer No.");
        if CustRec.FindFirst() then begin
            StatusRemarks := CustRec."Status Remarks";
        end;
    end;
    //RL         28 Oct 2021

    // YF 22 Nov 2021
    trigger OnOpenPage()
    begin
        IsClientOData := CurrentClientType() = ClientType::ODataV4;
    end;
    // YF 22 Nov 2021

    var
        WHCU: Codeunit "Warehouse CU";
        PMPCU: Codeunit "PMP-Enhancements";
        CustRec: Record customer;
        WorkHr: Text[250];
        OOSBool: Boolean;
        IStkBool: Boolean;
        StatusRemarks: text[250];
        IsClientOData: Boolean; // YF 22 Nov 2021
}
