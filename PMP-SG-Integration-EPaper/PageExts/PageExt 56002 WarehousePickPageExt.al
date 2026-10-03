pageextension 56002 WhsePickPageEpaperExt extends "Warehouse Pick"
{
    layout
    {
        // Add changes to page layout here
        addbefore("No.")
        {
            field(QRCodeParameters; QRCodeParameters)
            {
                Caption = 'QR Barcode';
                ApplicationArea = All;
                //DX        08 July 2021
                ToolTip = 'Scan QR Code E.G : SKU0001|A01-201|BAT000201|PCS';
                //DX        08 July 2021
                trigger OnValidate()
                var
                    WhseActivityLineRec: Record "Warehouse Activity Line";
                    WhseActivityLineModRec: Record "Warehouse Activity Line";
                    WhsePickItemCard: Page "Whse Act Line Card";

                    CodeList: List of [Text];
                    HasMalformedCode: Boolean;
                    HasConfirmedPicking: Boolean;
                    QtyPicked: Decimal;

                    PickNo: Text;
                    PickItemNo: Text;
                    PickBinCode: Text;
                    PickBatchNo: Text;
                    PickUOM: Text;

                    BreakBulkNo: Integer;

                    IntegrationCU: Codeunit "EPaper Integrations";
                    Picker: Record Picker;
                begin
                    HasMalformedCode := false;
                    HasConfirmedPicking := false;
                    QtyPicked := 0;

                    // 1. Get String and Sort Out Data
                    // Format - ITEMNO|BINCODE|BATCHNO|UNIT OF MEASURE
                    // Example: SKU0001|A01-201|BAT000201|PCS
                    PickNo := Rec."No.";

                    CodeList := QRCodeParameters.Split('|');
                    if CodeList.Count <> 4 then
                        HasMalformedCode := true
                    else begin
                        PickItemNo := CodeList.Get(1);
                        PickBinCode := CodeList.Get(2);
                        PickBatchNo := CodeList.Get(3);
                        PickUOM := CodeList.Get(4);
                    end;

                    if HasMalformedCode then
                        Error('QR Code/Barcode is malformed');

                    // Message(PickNo + ' / ' + PickItemNo + ' / ' + PickBinCode); // Debug Message

                    // 2. Match Warehouse Activity Lines
                    WhseActivityLineRec.Reset();
                    WhseActivityLineRec.SetRange("No.", PickNo);
                    WhseActivityLineRec.SetRange("Activity Type", WhseActivityLineRec."Activity Type"::Pick);
                    WhseActivityLineRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Take);
                    WhseActivityLineRec.SetRange("Item No.", PickItemNo); // at minimal to have this parameter

                    if StrLen(PickBinCode) > 0 then
                        WhseActivityLineRec.SetRange("Bin Code", PickBinCode);
                    if StrLen(PickBatchNo) > 0 then
                        WhseActivityLineRec.SetRange("Lot No.", PickBatchNo);
                    if StrLen(PickUOM) > 0 then
                        WhseActivityLineRec.SetRange("Unit of Measure Code", PickUOM);

                    // WhseActivityLineRec.SetFilter("Qty. to Handle", '<>0'); // disabled for now to resolve duplicate entry conflicts
                    if WhseActivityLineRec.Find('-') then begin
                        // if WhseActivityLineRec.FindFirst() then begin
                        // 3. Set Parameters for Custom Page
                        WhsePickItemCard.SetRecord(WhseActivityLineRec);
                        BreakBulkNo := WhseActivityLineRec."Breakbulk No.";

                        // 4. Open Custom Page for Warehouse Activity Line Item
                        // if WhsePickItemCard.RunModal() = Action::OK then begin // YF 18 May 2022 // Customer requirement hacky fix
                        HasConfirmedPicking := true; // YF 18 May 2022 // Customer requirement hacky fix
                        if HasConfirmedPicking then begin // YF 18 May 2022 // Customer requirement hacky fix
                            // 5. Get Feedback
                            // HasConfirmedPicking := WhsePickItemCard.GetConfirmedPickingFlag(); // YF 22 Sept 2021 Hard coded override
                            HasConfirmedPicking := true; // YF 22 Sept 2021 Hard coded override
                            // QtyPicked := WhsePickItemCard.GetQtyPicked(); // YF 18 May 2022 // Customer requirement hacky fix
                            QtyPicked := WhseActivityLineRec."CS Pick Qty"; // YF 18 May 2022 // Customer requirement hacky fix

                            // Message(Format(HasConfirmedPicking) + ' / ' + Format(QtyPicked)); // debug statement

                            if HasConfirmedPicking And (QtyPicked > 0) then begin
                                //DX        26 Sept 2021       Update the first take line for picking screen.
                                WhseActivityLineModRec.Reset;
                                WhseActivityLineModRec.SetRange("No.", Rec."No.");
                                WhseActivityLineModRec.SetRange("Activity Type", WhseActivityLineModRec."Activity Type"::"Pick");
                                WhseActivityLineModRec.SetRange("Source Line No.", WhseActivityLineRec."Source Line No.");
                                WhseActivityLineModRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Take);
                                WhseActivityLineModRec.SetRange("Lot No.", WhseActivityLineRec."Lot No.");
                                WhseActivityLineModRec.SetRange("Bin Code", WhseActivityLineRec."Bin Code");
                                //DX        28 Aug 2021
                                //DX        25 Sept 2021
                                if WhseActivityLineModRec.FindFirst() then begin
                                    WhseActivityLineModRec.Validate("Qty. to Handle", QtyPicked);
                                    //WhseActivityLineModRec.Validate("Qty. to Handle", WhseActivityLineModRec."Qty. to Handle" + QtyPicked);
                                    WhseActivityLineModRec.Modify(true)
                                end;
                                Commit();
                                //DX        26 Sept 2021        If scan bin code and there are multiple bins for same batch, need to filter by bin and lot no. to get the exact line.
                                WhseActivityLineModRec.Reset;
                                WhseActivityLineModRec.SetRange("No.", Rec."No.");
                                WhseActivityLineModRec.SetRange("Activity Type", WhseActivityLineModRec."Activity Type"::"Pick");
                                WhseActivityLineModRec.SetRange("Source Line No.", WhseActivityLineRec."Source Line No.");
                                WhseActivityLineModRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Place);
                                WhseActivityLineModRec.SetRange("Lot No.", WhseActivityLineRec."Lot No.");
                                //WhseActivityLineModRec.SetRange("Line No.", SelectedRecLineNo);
                                //DX        28 Aug 2021
                                //DX        25 Sept 2021
                                if WhseActivityLineModRec.findfirst() then begin
                                    //WhseActivityLineModRec.Validate("Qty. to Handle", QtyPicked);
                                    WhseActivityLineModRec.Validate("Qty. to Handle", WhseActivityLineModRec."Qty. to Handle" + QtyPicked);
                                    WhseActivityLineModRec.Modify(true)
                                end;
                                Commit();

                                /*
                                                                WhseActivityLineModRec.Reset;
                                                                WhseActivityLineModRec.SetRange("No.", PickNo);
                                                                WhseActivityLineModRec.SetRange("Activity Type", WhseActivityLineModRec."Activity Type"::Pick);
                                                                // WhseActivityLineRec.SetRange("Action Type", WhseActivityLineRec."Action Type"::Take);
                                                                WhseActivityLineModRec.SetRange("Item No.", PickItemNo); // at minimal to have this parameter
                                                                WhseActivityLineModRec.SetRange("Breakbulk No.", BreakBulkNo);
                                                                WhseActivityLineModRec.SetRange("Lot No.", WhseActivityLineRec."Lot No."); // YF 23 Sep 2021 // Quick Fix for list of items if break bulk no. all zero

                                                                // WhseActivityLineModRec.ModifyAll("Qty. Handled", 0, true);

                                                                WhseActivityLineModRec.ModifyAll("Qty. to Handle", QtyPicked, true);
                                                                WhseActivityLineModRec.ModifyAll("Qty. to Handle (Base)", QtyPicked * WhseActivityLineModRec."Qty. per Unit of Measure", true);
                                                                Commit();
                                                                // CurrPage.WhseActivityLines.Page.Update(false);
                                                                CurrPage.WhseActivityLines.Page.Update(true);
                                */
                                CurrPage.WhseActivityLines.Page.Update(true);
                                // Turn off ETag LED
                                Picker.Reset;
                                Picker.SetRange("User ID", Rec."Assigned User ID");
                                if Picker.Find('-') then begin
                                    IntegrationCU.ProcessSwitchOffETag(WhseActivityLineRec."Bin Code", Picker."E Tag ID");
                                    if UserId = 'BCADMIN' then
                                        Message('[DEBUG] LED OFF Function Triggered for Shelf ' + WhseActivityLineRec."Bin Code" + ' Color ' + Format(Picker."E Tag ID")); // Debug Message
                                end;
                            end;
                        end;
                    end
                    else
                        Message('No record found');

                    // 6. Clear QR Code field for next scan
                    QRCodeParameters := '';
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnDeleteRecord(): Boolean
    var
        WHLine: Record "WH Trip Line";
    begin
        WHLine.reset;
        whline.SetRange("Doc No.", Rec."No.");
        if WHLine.FindFirst() then begin
            Error('Warehouse has already processed this picking list, Warehouse will need to delete this picking trip first before the picking list can be deleted.');

        end;
    end;

    var
        QRCodeParameters: Text;
}