pageextension 55036 WhPutAwayPageExt extends "Warehouse Put-away"
{
    layout
    {
        addbefore("No.")
        {

            field(QRCodeParameters; QRCodeParameters)
            {
                Caption = 'QR Barcode';
                ApplicationArea = All;
                ToolTip = 'Scan QR Code E.G : A01-201';

                trigger OnValidate()
                var
                    WhseActivityLineRec: Record "Warehouse Activity Line";
                    WhseActivityLineModRec: Record "Warehouse Activity Line";
                    WhsePWItemCard: Page "Whse PW Act Line Card";

                    QtyPutaway: Decimal;
                    PutawayBinCode: Text;
                    BreakBulkNo: Integer;
                    HasConfirmedPutaway: Boolean;
                    SelectedRecLineNo: Integer;
                begin
                    if StrLen(QRCodeParameters) > 0 then begin
                        QtyPutaway := 0;

                        // Match Warehouse Activity Lines
                        WhseActivityLineRec.Reset();
                        WhseActivityLineRec.SetRange("No.", Rec."No.");
                        WhseActivityLineRec.SetRange("Activity Type", WhseActivityLineRec."Activity Type"::"Put-away");
                        WhseActivityLineRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Place);
                        WhseActivityLineRec.SetRange("Bin Code", QRCodeParameters);
                        //                        WhseActivityLineRec.SetFilter("Qty. to Handle", '=0'); // disabled for now to resolve duplicate entry conflicts

                        if WhseActivityLineRec.Find('-') then begin
                            // if WhseActivityLineRec.FindFirst() then begin
                            // Set Parameters for Custom Page
                            WhsePWItemCard.SetRecord(WhseActivityLineRec);
                            // BreakBulkNo := WhseActivityLineRec."Breakbulk No.";

                            // Open Custom Page for Warehouse Activity Line Item
                            if WhsePWItemCard.RunModal() = Action::OK then begin
                                // 5. Get Feedback
                                HasConfirmedPutaway := WhsePWItemCard.GetConfirmedPutawayFlag();
                                QtyPutaway := WhsePWItemCard.GetQtyPutaway();
                                SelectedRecLineNo := WhsePWItemCard.GetRecordLineNo();

                                // Message(Format(HasConfirmedPicking) + ' / ' + Format(QtyPicked)); // debug statement

                                if HasConfirmedPutaway And (QtyPutaway > 0) then begin
                                    // Process Qty Handled in Line accordingly
                                    /*
                                    WhseActivityLineRec.Validate("Qty. Handled", 0);
                                    WhseActivityLineRec.Validate("Qty. to Handle", QtyPicked);
                                    WhseActivityLineRec.Modify();
                                    CurrPage.WhseActivityLines.Page.Update(false);
                                    */


                                    WhseActivityLineModRec.Reset;
                                    WhseActivityLineModRec.SetRange("No.", Rec."No.");
                                    WhseActivityLineModRec.SetRange("Activity Type", WhseActivityLineModRec."Activity Type"::"Put-away");
                                    //DX        25 Sept 2021
                                    WhseActivityLineModRec.SetRange("Source Line No.", WhseActivityLineRec."Source Line No.");
                                    //DX        25 Sept 2021
                                    WhseActivityLineRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Take);
                                    // WhseActivityLineModRec.SetRange("Item No.", PickItemNo); // at minimal to have this parameter
                                    // WhseActivityLineModRec.SetRange("Breakbulk No.", BreakBulkNo);
                                    //DX        28 Aug 2021     Change to modify by batch number    , now only updating one line.
                                    //WhseActivityLineModRec.SetRange("Bin Code", QRCodeParameters);
                                    WhseActivityLineModRec.SetRange("Lot No.", GetLotNo(SelectedRecLineNo, Rec."No."));
                                    //WhseActivityLineModRec.SetRange("Line No.", SelectedRecLineNo);
                                    //DX        28 Aug 2021
                                    //DX        25 Sept 2021
                                    if WhseActivityLineModRec.FindFirst() then begin
                                        WhseActivityLineModRec.Validate("Qty. to Handle", WhseActivityLineModRec."Qty. to Handle" + QtyPutaway);
                                        //WhseActivityLineModRec.Validate("Qty. to Handle (Base)", WhseActivityLineModRec."Qty. to Handle (Base)" + (QtyPutaway * WhseActivityLineModRec."Qty. per Unit of Measure"));
                                        WhseActivityLineModRec.Modify(true)
                                    end;


                                    WhseActivityLineModRec.Reset;
                                    WhseActivityLineModRec.SetRange("No.", Rec."No.");
                                    WhseActivityLineModRec.SetRange("Activity Type", WhseActivityLineModRec."Activity Type"::"Put-away");
                                    //DX        25 Sept 2021
                                    WhseActivityLineModRec.SetRange("Source Line No.", WhseActivityLineRec."Source Line No.");
                                    //DX        25 Sept 2021
                                    WhseActivityLineRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Place);
                                    // WhseActivityLineModRec.SetRange("Item No.", PickItemNo); // at minimal to have this parameter
                                    // WhseActivityLineModRec.SetRange("Breakbulk No.", BreakBulkNo);
                                    //DX        28 Aug 2021     Change to modify by batch number    , now only updating one line.
                                    //WhseActivityLineModRec.SetRange("Bin Code", QRCodeParameters);
                                    WhseActivityLineModRec.SetRange("Lot No.", GetLotNo(SelectedRecLineNo, Rec."No."));
                                    WhseActivityLineModRec.SetRange("Bin Code", WhseActivityLineRec."Bin Code");
                                    //WhseActivityLineModRec.SetRange("Line No.", SelectedRecLineNo);
                                    //DX        28 Aug 2021
                                    //DX        25 Sept 2021
                                    if WhseActivityLineModRec.findfirst() then begin
                                        WhseActivityLineModRec.Validate("Qty. to Handle", QtyPutaway);
                                        //WhseActivityLineModRec.Validate("Qty. to Handle (Base)", QtyPutaway * WhseActivityLineModRec."Qty. per Unit of Measure");
                                        WhseActivityLineModRec.Modify(true)
                                    end;

                                    //DX        25 Sept 2021
                                    //WhseActivityLineModRec.ModifyAll("Qty. Handled", 0, true);
                                    //WhseActivityLineModRec.ModifyAll("Qty. to Handle", QtyPutaway, true);
                                    //WhseActivityLineModRec.ModifyAll("Qty. to Handle (Base)", QtyPutaway * WhseActivityLineModRec."Qty. per Unit of Measure", true);



                                    CurrPage.WhseActivityLines.Page.Update(false);

                                end;
                            end;
                        end
                        else
                            Message('No record found');
                    end;

                    // Clear QR Code field for next scan
                    QRCodeParameters := '';
                end;
            }
        }
        addafter("Assignment Time")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("External Document No. 2"; Rec."External Document No.2")
            {
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        // YF 15 Oct 2021 // Alternate Method to Update SO Stock Flags during Movement or Putaway

        modify("Registered Put-aways")
        {
            ApplicationArea = All;

            trigger OnBeforeAction()
            var
                WhseActLine: Record "Warehouse Activity Line";
                ItemCode: Code[20];
                LocationCode: Code[20];
            begin
                EntryNo := 1;
                TempStagingRec.Reset;
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not TempStagingRec.IsEmpty then
                    TempStagingRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock

                WhseActLine.Reset;
                WhseActLine.SetRange("Activity Type", Rec.Type);
                WhseActLine.SetRange("No.", Rec."No.");
                WhseActLine.SetCurrentKey("Item No.", "Location Code");
                WhseActLine.SetAscending("Item No.", true);
                WhseActLine.SetAscending("Location Code", true);
                if WhseActLine.FindSet() then
                    repeat
                        if (WhseActLine."Item No." <> ItemCode) Or (WhseActLine."Location Code" <> LocationCode) then begin
                            TempStagingRec.Init();
                            TempStagingRec."Entry No." := EntryNo;
                            TempStagingRec."Item No." := WhseActLine."Item No.";
                            TempStagingRec."Document No." := WhseActLine."Location Code";
                            TempStagingRec.Insert;
                            EntryNo += 1;
                            ItemCode := WhseActLine."Item No.";
                            LocationCode := WhseActLine."Location Code";
                        end;
                    until WhseActLine.Next() = 0;

            end;

            trigger OnAfterAction()
            begin
                Clear(EnhanceCU);

                TempStagingRec.Reset;
                if TempStagingRec.FindSet() then
                    repeat
                        EnhanceCU.UpdateSOStockStatusFlags(TempStagingRec."Item No.", TempStagingRec."Document No.");
                        TempStagingRec.Delete();
                    until TempStagingRec.Next() = 0;
            end;
        }

        modify("&Register Put-away")
        {
            ApplicationArea = All;

            trigger OnBeforeAction()
            var
                WhseActLine: Record "Warehouse Activity Line";
                ItemCode: Code[20];
                LocationCode: Code[20];
            begin
                EntryNo := 1;
                TempStagingRec.Reset;
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not TempStagingRec.IsEmpty then
                    TempStagingRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock

                WhseActLine.Reset;
                WhseActLine.SetRange("Activity Type", Rec.Type);
                WhseActLine.SetRange("No.", Rec."No.");
                WhseActLine.SetCurrentKey("Item No.", "Location Code");
                WhseActLine.SetAscending("Item No.", true);
                WhseActLine.SetAscending("Location Code", true);
                if WhseActLine.FindSet() then
                    repeat
                        if (WhseActLine."Item No." <> ItemCode) Or (WhseActLine."Location Code" <> LocationCode) then begin
                            TempStagingRec.Init();
                            TempStagingRec."Entry No." := EntryNo;
                            TempStagingRec."Item No." := WhseActLine."Item No.";
                            TempStagingRec."Document No." := WhseActLine."Location Code";
                            TempStagingRec.Insert;
                            EntryNo += 1;
                            ItemCode := WhseActLine."Item No.";
                            LocationCode := WhseActLine."Location Code";
                        end;
                    until WhseActLine.Next() = 0;

            end;

            trigger OnAfterAction()
            begin
                Clear(EnhanceCU);

                TempStagingRec.Reset;
                if TempStagingRec.FindSet() then
                    repeat
                        EnhanceCU.UpdateSOStockStatusFlags(TempStagingRec."Item No.", TempStagingRec."Document No.");
                        TempStagingRec.Delete();
                    until TempStagingRec.Next() = 0;
            end;
        }

        // YF 15 Oct 2021 // Alternate Method to Update SO Stock Flags during Movement or Putaway
    }

    var
        QRCodeParameters: Text;
        EnhanceCU: Codeunit "PMP-Enhancements";
        TempStagingRec: Record "TBA Ledger Entry" temporary;
        EntryNo: Integer;


    trigger OnOpenPage()
    var
        PMPCU: Codeunit "PMP-Enhancements";
        WHActLine: Record "Warehouse Activity Line";
    begin
        //DX        16 July 2021
        if rec."No." <> '' then begin
            if Rec."Assigned User ID" = '' then begin
                //CurrPage.WhseActivityLines.PAGE.DeleteQtyToHandle;
                //DX        02 Sept 2021
                WHActLine.reset;
                WHActLine.SetRange("No.", Rec."No.");
                WHActLine.SetFilter("Item No.", '<>%1', '');
                WHActLine.SetRange("Action Type", WHActLine."Action Type"::Place);
                WHActLine.SetRange("Activity Type", WHActLine."Activity Type"::"Put-away");
                if WHActLine.FindSet() then
                    repeat
                        WHActLine.Validate("Qty. to Handle", 0);
                        WHActLine.Modify(TRUE);
                    until WHActLine.next = 0;
                //DX        02 Sept 2021
                Rec."Assigned User ID" := UserId;
                Rec."Assignment Date" := Today;
                Rec."Assignment Time" := Time;
                // Message(rec."No.");
                Rec.Modify(FALSE);
            end;
        end;
        //DX        16 July 2021
    end;

    local procedure GetLotNo(LineNo: Integer; WHDocNo: Code[20]): Code[50]
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
    begin
        WHActLine.SetRange("No.", WHDocNo);
        WHActLine.SetRange("Line No.", LineNo);
        if WHActLine.FindFirst() then begin
            exit(WHActLine."Lot No.");
        end;
    end;

    // YF 08 Nov 2021
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetFirstWhsePutawayLineDetail();
    end;

    local procedure GetFirstWhsePutawayLineDetail()
    var
        lWhseActivityLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
    begin
        lWhseActivityLineRec.Reset();
        lWhseActivityLineRec.SetRange("No.", Rec."No.");
        if lWhseActivityLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseActivityLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Purchase Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := '';
                    Rec."Source Branch" := '';
                    Rec."Source Vend/Cust No." := lPurchaseHeaderRec."Buy-from Vendor No.";
                    Rec."Source Vend/Cust Name" := lPurchaseHeaderRec."Buy-from Vendor Name";
                end;
            end;

            // Handle Sales
            if lWhseActivityLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lSalesHeaderRec."External Document No.";
                    Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lSalesHeaderRec."Sell-to Customer No.";
                    Rec."Source Vend/Cust Name" := lSalesHeaderRec."Sell-to Customer Name";
                end;
            end;

            Rec.Modify(false);

        end;
    end;

}
