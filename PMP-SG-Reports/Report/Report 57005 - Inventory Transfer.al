report 57005 "Inventory Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57005 - Invnetory Transfer.rdl';

    dataset
    {
        dataitem("Item Journal Batch"; "Item Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name);
            RequestFilterFields = "Journal Template Name", Name;
            column(JournalTempName_ItemJournalBatch; "Journal Template Name")
            {
            }
            column(Name_ItemJournalBatch; Name)
            {
            }
            column(InventoryMovementCaption; InventoryMovementCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(JournalTempNameFieldCaption; "Item Journal Line".FieldCaption("Journal Template Name"))
            {
            }
            column(JournalBatchNameFieldCaption; "Item Journal Line".FieldCaption("Journal Batch Name"))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(Time; Time)
            {
            }
            dataitem("Item Journal Line"; "Item Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Location Code", "Bin Code", "Item No.", "Variant Code";
                column(JournalTempName_ItemJournalLine; "Journal Template Name")
                {
                }
                column(JournalBatchName_ItemJournalLine; "Journal Batch Name")
                {
                }
                column(ActivityType; ActivityType)
                {
                    OptionCaption = ' ,Put-away,Pick,Movement';
                }
                column(ItemJnlLineActTypeShowOutput; ActivityType <> ActivityType::" ")
                {
                }
                column(ItemJournalLineTableCaption; TableCaption + ': ' + ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineFilter; ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineHeader1ShowOutput; ItemJnlTemplate.Type in [ItemJnlTemplate.Type::Item, ItemJnlTemplate.Type::Consumption, ItemJnlTemplate.Type::Output, ItemJnlTemplate.Type::"Prod. Order"])
                {
                }
                column(ItemJnlLineHeader2ShowOutput; ItemJnlTemplate.Type = ItemJnlTemplate.Type::Transfer)
                {
                }
                column(UOM_ItemJournalLine; "Unit of Measure Code")
                {
                }
                column(Qty_ItemJournalLine; Quantity)
                {
                }
                column(BinCode_ItemJournalLine; "Bin Code")
                {
                }
                column(LocationCode_ItemJournalLine; "Location Code")
                {
                }
                column(VariantCode_ItemJournalLine; "Variant Code")
                {
                }
                column(Description_ItemJournalLine; Description)
                {
                }
                column(ItemNo_ItemJournalLine; "Item No.")
                {
                }
                column(PostingDate_ItemJournalLine; Format("Posting Date"))
                {
                }
                column(EntryType_ItemJournalLine; "Entry Type")
                {
                }
                column(QuantityBase_ItemJournalLine; "Quantity (Base)")
                {
                }
                column(QuantityFormat; Quantity)
                {
                }
                column(NewBinCode_ItemJournalLine; "New Bin Code")
                {
                }
                column(NewLocationCode_ItemJournalLine; "New Location Code")
                {
                }
                column(QuantityBaseFormat; "Quantity (Base)")
                {
                }
                column(ActivityTypeCaption; ActivityTypeCaptionLbl)
                {
                }
                column(UOMFieldCaption; FieldCaption("Unit of Measure Code"))
                {
                }
                column(QtyFieldCaption; FieldCaption(Quantity))
                {
                }
                column(BinCodeFieldCaption; FieldCaption("Bin Code"))
                {
                }
                column(LocationCodeFieldCaption; FieldCaption("Location Code"))
                {
                }
                column(VariantCodeFieldCaption; FieldCaption("Variant Code"))
                {
                }
                column(DescriptionFieldCaption; FieldCaption(Description))
                {
                }
                column(ItemNoFieldCaption; FieldCaption("Item No."))
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(EntryTypeFieldCaption; FieldCaption("Entry Type"))
                {
                }
                column(QuantityBaseFieldCaption; FieldCaption("Quantity (Base)"))
                {
                }
                column(NewBinCodeFieldCaption; FieldCaption("New Bin Code"))
                {
                }
                column(NewLocationCodeFieldCaption; FieldCaption("New Location Code"))
                {
                }
                column(Batch; Batch) { }
                column(ExpiryDate; ExpiryDate) { }

                trigger OnAfterGetRecord()
                begin
                    if ("Entry Type" in ["Entry Type"::"Positive Adjmt.", "Entry Type"::Purchase, "Entry Type"::Output]) and
                       (Quantity > 0) and
                       (ActivityType in [ActivityType::Pick, ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Negative Adjmt.", "Entry Type"::Sale, "Entry Type"::Consumption]) and
                       (Quantity < 0) and
                       (ActivityType in [ActivityType::Pick, ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Positive Adjmt.", "Entry Type"::Purchase, "Entry Type"::Output]) and
                       (Quantity < 0) and
                       (ActivityType in [ActivityType::"Put-away", ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" in ["Entry Type"::"Negative Adjmt.", "Entry Type"::Sale, "Entry Type"::Consumption]) and
                       (Quantity > 0) and
                       (ActivityType in [ActivityType::"Put-away", ActivityType::Movement])
                    then
                        CurrReport.Skip();

                    if ("Entry Type" <> "Entry Type"::Transfer) and
                       (ActivityType = ActivityType::Movement)
                    then
                        CurrReport.Skip();

                    //KM20210223 - Start
                    Clear(Batch);
                    Clear(ExpiryDate);

                    grec_RE.Reset();
                    grec_RE.SetRange("Source ID", "Item Journal Line"."Journal Template Name");
                    grec_RE.SetRange("Source Batch Name", "Item Journal Line"."Journal Batch Name");
                    grec_RE.SetRange("Source Type", 83);
                    grec_RE.SetRange("Reservation Status", grec_RE."Reservation Status"::Prospect);
                    grec_RE.SetRange("Item No.", "Item Journal Line"."Item No.");
                    grec_RE.SetRange("Source Ref. No.", "Item Journal Line"."Line No.");
                    if grec_RE.FindSet() then begin
                        repeat
                            Batch := Batch + grec_RE."Lot No." + ';';
                            //KM20210219 - Start
                            grec_TS.Reset();
                            grec_TS.SetRange("Item No.", grec_RE."Item No.");
                            grec_TS.SetRange("Location Code", grec_RE."Location Code");
                            grec_TS.SetRange("Lot No.", grec_RE."Lot No.");
                            if grec_TS.FindFirst() then begin
                                ExpiryDate := ExpiryDate + Format(grec_TS."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>') + ';';
                            end;
                        // ExpiryDate := ExpiryDate + Format(grec_RE."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>') + ';';
                        //KM20210219 - End
                        until grec_RE.Next() = 0;
                    end;
                    //KM20210223 - End
                end;

                trigger OnPreDataItem()
                begin
                    ItemJnlTemplate.Get("Item Journal Batch"."Journal Template Name");
                end;
            }
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
                    field(ActivityType; ActivityType)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Activity Type';
                        OptionCaption = ' ,Put-away,Pick,Movement';
                        ToolTip = 'Specifies the inventory movement activity that a warehouse employee will follow to move items.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemJnlLineFilter := "Item Journal Line".GetFilters;
    end;

    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLineFilter: Text;
        ActivityType: Option " ","Put-away",Pick,Movement;
        InventoryMovementCaptionLbl: Label 'Inventory Transfer';
        PageCaptionLbl: Label 'Page';
        ActivityTypeCaptionLbl: Label 'Activity Type';
        PostingDateCaptionLbl: Label 'Posting Date';
        CustName: Text[50];
        CustRec: Record 18;
        Sno: Integer;
        AbsVendLCY: Decimal;
        CompanyInfo: Record 79;
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit 365;
        gtxt_BatchDesc: Text;
        grec_Batches: Record "Gen. Journal Batch";
        grec_Approval: Record "Approval Entry";
        gcd_Approver: Text;
        gcd_Reject: Text;
        grec_RE: Record "Reservation Entry";
        Batch: Text;
        ExpiryDate: Text;
        grec_TS: Record "Tracking Specification";

    procedure InitializeRequest(NewActivityType: Option)
    begin
        ActivityType := NewActivityType;
    end;


}

