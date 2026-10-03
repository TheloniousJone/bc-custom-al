report 57130 "Calculate Bin Replenishment2"
{
    Caption = 'Calculate Bin Replenishment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bin Content"; "Bin Content")
        {
            DataItemTableView = SORTING("Location Code", "Item No.", "Variant Code", "Warehouse Class Code", Fixed, "Bin Ranking") ORDER(Descending) WHERE(Fixed = FILTER(true));
            RequestFilterFields = "Bin Code", "Item No.";

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
            begin
                ItemRec.Get("Item No.");
                if ItemRec."Global Dimension 1 Code" = GlobalDimension1Value then
                    Replenishmt.ReplenishBin("Bin Content", AllowBreakbulk);
            end;

            trigger OnPostDataItem()
            begin
                if not Replenishmt.InsertWhseWkshLine() then
                    if not HideDialog then
                        Message(Text000);
            end;

            trigger OnPreDataItem()
            var
                ItemRec: Record Item;
                ItemRec2: Record Item;
            begin
                SetRange("Location Code", LocationCode);

                // SetRange("Item Global Dimension 1 Code", GlobalDimension1Value);
                // SetFilter("Item No.", FilterItemNoTxt);
                // Item.SetRange("No.", Item."No." where );

                // FilterItemNoTxt := '';

                // ItemRec.SetRange("Global Dimension 1 Code", GlobalDimension1Value);
                // ItemRec2.SetRange("Global Dimension 1 Code", GlobalDimension1Value);
                // if ItemRec.FindSet() and ItemRec2.FindLast() then begin
                //     repeat
                //         // if ItemRec.Next() = 0 then begin
                //         //     FilterItemNoTxt += ItemRec."No.";
                //         // end else begin
                //         //     FilterItemNoTxt += ItemRec."No." + '|';
                //         // end;

                //         if ItemRec."No." <> ItemRec2."No." then begin
                //             FilterItemNoTxt += ItemRec."No." + '|';
                //         end else begin
                //             FilterItemNoTxt += ItemRec."No.";
                //         end;
                //     until ItemRec.Next() = 0;
                // end;

                // Message(FilterItemNoTxt);
                //SetRange("Item No.", FilterItemNoTxt);

                Replenishmt.SetWhseWorksheet(
                  WhseWkshTemplateName, WhseWkshName, LocationCode, DoNotFillQtytoHandle);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(WorksheetTemplateName; WhseWkshTemplateName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Worksheet Template Name';
                        TableRelation = "Whse. Worksheet Template";
                        ToolTip = 'Specifies the name of the worksheet template that applies to the movement lines.';

                        trigger OnValidate()
                        begin
                            if WhseWkshTemplateName = '' then
                                WhseWkshName := '';
                        end;
                    }
                    field(WorksheetName; WhseWkshName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Worksheet Name';
                        ToolTip = 'Specifies the name of the worksheet the movement lines will belong to.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            WhseWorksheetName.SetRange("Worksheet Template Name", WhseWkshTemplateName);
                            WhseWorksheetName.SetRange("Location Code", LocationCode);
                            if PAGE.RunModal(0, WhseWorksheetName) = ACTION::LookupOK then
                                WhseWkshName := WhseWorksheetName.Name;
                        end;

                        trigger OnValidate()
                        begin
                            WhseWorksheetName.Get(WhseWkshTemplateName, WhseWkshName, LocationCode);
                        end;
                    }
                    field(LocCode; LocationCode)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Location Code';
                        TableRelation = Location;
                        ToolTip = 'Specifies the location at which bin replenishment will be calculated.';
                    }
                    field(AllowBreakbulk; AllowBreakbulk)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Allow Breakbulk';
                        ToolTip = 'Specifies that the bin will be replenished from bin content that is stored in another unit of measure if the item is not found in the original unit of measure.';
                    }
                    field(DoNotFillQtytoHandle; DoNotFillQtytoHandle)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Do Not Fill Qty. to Handle';
                        ToolTip = 'Specifies that the Quantity to Handle field on each worksheet line must be filled manually. ';
                    }
                    field(GlobalDimension1Value; GlobalDimension1Value)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Business Segment';
                        TableRelation = "Dimension Value".Code where("Dimension Code" = filter('BUSINESS SEGMENT'),
                                                                        Blocked = const(false));
                        // trigger OnValidate()
                        // var
                        //     ItemRec: Record Item;
                        //     BinContent: Record "Bin Content";
                        // begin
                        //     FilterItemNoTxt := '';

                        //     ItemRec.SetRange("Global Dimension 1 Code", GlobalDimension1Value);
                        //     if ItemRec.FindSet() then begin
                        //         repeat
                        //             if ItemRec.Next() > 1 then begin
                        //                 // FilterItemNoTxt += ItemRec."No." + '|';
                        //             end else begin
                        //                 FilterItemNoTxt += ItemRec."No.";
                        //             end;
                        //         until ItemRec.Next() = 0;
                        //     end;

                        // BinContent.Reset();
                        // BinContent.SetRange("Item Global Dimension 1 Code", '');
                        // if BinContent.FindSet() then begin
                        //     repeat
                        //         Item.Reset();
                        //         Item.SetRange("No.", BinContent."Item No.");
                        //         if Item.FindFirst() then begin
                        //             BinContent."Item Global Dimension 1 Code" := Item."Global Dimension 1 Code";
                        //             BinContent.Modify();
                        //         end;
                        //     until BinContent.Next() = 0;
                        // end;
                        // end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        var
            ItemRec: Record Item;
            BinContent: Record "Bin Content";
        begin
            FilterItemNoTxt := '';

            ItemRec.SetRange("Global Dimension 1 Code", GlobalDimension1Value);
            if ItemRec.FindSet() then begin
                repeat
                    if ItemRec.Next() > 1 then begin
                        // FilterItemNoTxt += ItemRec."No." + '|';
                    end else begin
                        FilterItemNoTxt += ItemRec."No.";
                    end;
                until ItemRec.Next() = 0;
            end;
        end;
    }

    labels
    {
    }

    var
        WhseWorksheetName: Record "Whse. Worksheet Name";
        Replenishmt: Codeunit Replenishment;
        Text000: Label 'There is nothing to replenish.';
        GlobalDimension1Value: Code[20];
        FilterItemNoTxt: Text;

    protected var
        WhseWkshTemplateName: Code[10];
        WhseWkshName: Code[10];
        AllowBreakbulk: Boolean;

        DoNotFillQtytoHandle: Boolean;
        HideDialog: Boolean;
        LocationCode: Code[10];

    procedure InitializeRequest(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10]; AllowBreakbulk2: Boolean; HideDialog2: Boolean; DoNotFillQtytoHandle2: Boolean)
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
        AllowBreakbulk := AllowBreakbulk2;
        HideDialog := HideDialog2;
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
    end;
}

