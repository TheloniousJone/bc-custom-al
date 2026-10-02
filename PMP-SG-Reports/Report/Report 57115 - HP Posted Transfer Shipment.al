report 57115 "HP Posted Transfer Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57115 - HP Posted Transfer Shipment.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(ReportCaption; ReportCaptionLbl)
            {
            }
            column(TransferNumberCaption; TransferNumberCaptionLbl)
            {
            }
            column(VoucherCaption; VoucherCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(FromWarehouseCaption; FromWarehouseCaptionLbl)
            {
            }
            column(ToWarehouseCaption; ToWarehouseCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(FromCaption; FromCaptionLbl)
            {
            }
            column(ToCaption; ToCaptionLbl)
            {
            }
            column(Header_No; "No.")
            {
            }
            column(Header_Voucher; "Transfer Order No.")
            {
            }
            column(Header_PostingDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_FromWH; "Transfer-from Code")
            {
            }
            column(Header_ToWH; "Transfer-to Code")
            {
            }
            column(Header_TransferFromName; "Transfer-from Name")
            {
            }
            column(Header_TransferFromAddress; "Transfer-from Address")
            {
            }
            column(Header_TransferFromAddress2; "Transfer-from Address 2")
            {
            }
            column(Header_TransferFromCity; "Transfer-from City")
            {
            }
            column(Header_TransferFromPostCode; "Transfer-from Post Code")
            {
            }
            column(Header_TransferToName; "Transfer-to Name")
            {
            }
            column(Header_TransferToAddress; "Transfer-to Address")
            {
            }
            column(Header_TransferToAddress2; "Transfer-to Address 2")
            {
            }
            column(Header_TransferToCity; "Transfer-to City")
            {
            }
            column(Header_TransferToPostCode; "Transfer-to Post Code")
            {
            }
            column(Header_Remarks; Remarks)
            {
            }
            column(Header_NoOfCarton; "No. of Carton")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Transfer_To_Bin_Code; "Transfer-To Bin Code")
            {
            }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    InsertIntoTemp("Transfer Shipment Line");
                end;
            }
            dataitem(SummaryLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                column(temp_External; External)
                {
                }
                column(temp_ItemNo; temp_ItemLedgerEntry."Item No.")
                {
                }
                column(temp_ItemName; Item_Description)
                {
                }
                column(temp_BatchNumber; temp_ItemLedgerEntry."Lot No.")
                {
                }
                column(temp_ExpDate; Format(temp_ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(temp_Quantity; temp_ItemLedgerEntry.Quantity)
                {
                }
                column(temp_UOM; temp_ItemLedgerEntry."Unit of Measure Code")
                {
                }
                column(temp_NoOfCarton; temp_ItemLedgerEntry."Invoiced Quantity")
                {
                }

                trigger OnPreDataItem()
                begin
                    temp_ItemLedgerEntry.Reset();
                    SetRange(Number, 1, temp_ItemLedgerEntry.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        temp_ItemLedgerEntry.FindFirst()
                    else
                        temp_ItemLedgerEntry.Next();

                    GetExternal(temp_ItemLedgerEntry."Item No.");
                    GetItemDescription(temp_ItemLedgerEntry."Item No.");
                end;

                trigger OnPostDataItem()
                begin
                    temp_ItemLedgerEntry.DeleteAll();
                end;
            }
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ReportCaptionLbl: Label 'Transfer Shipment';
        TransferNumberCaptionLbl: Label 'Transfer Number';
        VoucherCaptionLbl: Label 'Voucher';
        PostingDateCaptionLbl: Label 'Posting Date';
        FromWarehouseCaptionLbl: Label 'From Warehouse';
        ToWarehouseCaptionLbl: Label 'To Warehouse';
        PageCaptionLbl: Label 'Page';
        FromCaptionLbl: Label 'From';
        ToCaptionLbl: Label 'To';
        CompanyInfo: Record "Company Information";
        temp_ItemLedgerEntry: Record "Item Ledger Entry" temporary;
        Entry_No: Integer;
        External: Code[50];
        Item_Description: Text[100];

    local procedure InsertIntoTemp(par_TSL: Record "Transfer Shipment Line")
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        ExistedNoOfCarton: Boolean;
    begin
        ItemEntryRelation.SetCurrentKey("Source ID", "Source Type");
        ItemEntryRelation.SetRange("Source Type", 5745);
        ItemEntryRelation.SetRange("Source Subtype", 0);
        ItemEntryRelation.SetRange("Source ID", par_TSL."Document No.");
        ItemEntryRelation.SetRange("Source Batch Name", '');
        ItemEntryRelation.SetRange("Source Prod. Order Line", 0);
        ItemEntryRelation.SetRange("Source Ref. No.", par_TSL."Line No.");
        if ItemEntryRelation.FindSet() then begin
            repeat
                ItemLedgEntry.Get(ItemEntryRelation."Item Entry No.");

                temp_ItemLedgerEntry.Reset();
                temp_ItemLedgerEntry.SetRange("Lot No.", ItemLedgEntry."Lot No.");
                temp_ItemLedgerEntry.SetRange("Item No.", ItemLedgEntry."Item No.");
                if not temp_ItemLedgerEntry.FindFirst() then begin
                    if Entry_No = 0 then
                        Entry_No := 1
                    else
                        Entry_No += 1;

                    temp_ItemLedgerEntry.Reset();
                    temp_ItemLedgerEntry.Init();
                    temp_ItemLedgerEntry."Entry No." := Entry_No;
                    temp_ItemLedgerEntry."Lot No." := ItemLedgEntry."Lot No.";
                    temp_ItemLedgerEntry."Item No." := ItemLedgEntry."Item No.";
                    temp_ItemLedgerEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                    temp_ItemLedgerEntry.Quantity := ItemLedgEntry.Quantity * -1;
                    temp_ItemLedgerEntry."Unit of Measure Code" := ItemLedgEntry."Unit of Measure Code";

                    if ExistedNoOfCarton = false then begin
                        temp_ItemLedgerEntry."Invoiced Quantity" := par_TSL."No. of Carton"; //No. of Carton
                        ExistedNoOfCarton := true;
                    end else
                        temp_ItemLedgerEntry."Invoiced Quantity" := 0;

                    temp_ItemLedgerEntry.Insert(false);
                end else begin //RL 27 Jan 2022 - to cater for duplicate item to sum up repeated item/Lot qty
                    temp_ItemLedgerEntry.Quantity := temp_ItemLedgerEntry.Quantity + (ItemLedgEntry.Quantity * -1);
                    temp_ItemLedgerEntry.Modify();
                end;
            //RL 27 Jan 2022
            until ItemEntryRelation.Next() = 0;
        end else begin
            temp_ItemLedgerEntry.Reset();
            temp_ItemLedgerEntry.SetRange("Item No.", par_TSL."Item No.");
            if not temp_ItemLedgerEntry.FindFirst() then begin
                if Entry_No = 0 then
                    Entry_No := 1
                else
                    Entry_No += 1;

                temp_ItemLedgerEntry.Reset();
                temp_ItemLedgerEntry.Init();
                temp_ItemLedgerEntry."Entry No." := Entry_No;
                temp_ItemLedgerEntry."Item No." := par_TSL."Item No.";
                temp_ItemLedgerEntry.Quantity := par_TSL.Quantity;
                temp_ItemLedgerEntry."Unit of Measure Code" := par_TSL."Unit of Measure Code";
                temp_ItemLedgerEntry."Invoiced Quantity" := par_TSL."No. of Carton";
                temp_ItemLedgerEntry.Insert(false);
            end;
        end;
    end;

    local procedure GetExternal(par_ItemNo: Code[20])
    var
        ItemRef: Record "Item Reference";
    begin
        Clear(External);

        ItemRef.Reset();
        ItemRef.SetRange("Item No.", par_ItemNo);
        if ItemRef.FindFirst() then
            External := ItemRef."Reference No.";
    end;

    local procedure GetItemDescription(par_ItemNo: Code[20])
    var
        lcl_Item: Record Item;
    begin
        Clear(Item_Description);

        lcl_Item.Reset();
        lcl_Item.SetRange("No.", par_ItemNo);
        if lcl_Item.FindFirst() then
            Item_Description := lcl_Item.Description;
    end;
}