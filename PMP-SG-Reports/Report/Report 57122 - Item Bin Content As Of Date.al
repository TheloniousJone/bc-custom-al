report 57122 "Item Bin Content As Of Date"
{
    ApplicationArea = All;
    Caption = 'Item Bin Content As Of Date';
    RDLCLayout = './ReportLayouts/ReportLayout 57122 - ItemBinContentAsOfDate.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(number);

            column(ItemNo; ItemNo) { }
            column(ItemDescr; ItemDescr) { }
            column(LocationCode; LocationCode) { }
            column(BinCode; BinCode) { }
            column(LotNo; LotNo) { }
            column(ExpiryDate; ExpiryDateText) { }
            column(QtyBaseAmount; QtyBaseAmount) { }
            column(ZoneCode; ZoneCode) { }
            column(BusinessSegmentCode; BusinessSegmentCode) { }

            trigger OnPreDataItem()
            begin

                if StrLen(ItemNoFilter) > 0 then
                    QueryObject.SetRange(Item_No_Filter, ItemNoFilter);

                if (RegDateFilter <> 0D) then
                    QueryObject.SetFilter(Registering_Date, '..%1', RegDateFilter);

                QueryObject.Open();
            end;

            trigger OnAfterGetRecord()
            var
                ILERec: Record "Item Ledger Entry";
                BinContent: Record "Bin Content";
                DefaultDimension: Record "Default Dimension";
            begin
                if QueryObject.Read() then begin
                    // set datafields
                    ItemNo := QueryObject.Item_No;
                    ItemDescr := QueryObject.ItemDesc;
                    LocationCode := QueryObject.Location_Code;
                    BinCode := QueryObject.Bin_Code;
                    LotNo := QueryObject.Lot_No_;
                    QtyBaseAmount := QueryObject.Base_Qty;
                    BusinessSegmentCode := QueryObject.Global_Dimension_1_Code;

                    // ExpiryDate := QueryObject.Expiration_Date;

                    ExpiryDate := 0D;

                    ILERec.Reset();
                    ILERec.SetLoadFields("Entry No.", "Item No.", "Lot No.", "Expiration Date");
                    ILERec.SetCurrentKey("Item No.", "Lot No.", "Expiration Date");
                    ILERec.SetRange("Lot No.", LotNo);
                    ILERec.SetRange("Item No.", ItemNo);
                    //ILERec.SetAscending("Entry No.", false);

                    if ILERec.FindLast() then
                        ExpiryDate := ILERec."Expiration Date";
                    // , QueryObject.Bin_Code, QueryObject.Item_No,QueryObject.Variant_Code, QueryObject.Unit_of_Measure_Code
                    BinContent.Reset();
                    BinContent.SetCurrentKey("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code");
                    BinContent.SetLoadFields("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code");
                    BinContent.SetRange("Location Code", QueryObject.Location_Code);
                    BinContent.SetRange("Bin Code", QueryObject.Bin_Code);
                    BinContent.SetRange("Item No.", QueryObject.Item_No);
                    BinContent.SetRange("Variant Code", QueryObject.Variant_Code);
                    BinContent.SetRange("Unit of Measure Code", QueryObject.Unit_of_Measure_Code);
                    if BinContent.FindFirst() then
                        ZoneCode := BinContent."Zone Code";

                    // DefaultDimension.Reset();
                    // DefaultDimension.SetRange("Table ID", 27);
                    // DefaultDimension.SetRange("No.", ItemNo);
                    // DefaultDimension.SetRange("Dimension Code", 'BUSINESS SEGMENT');
                    // if DefaultDimension.FindFirst() then
                    //     BusinessSegmentCode := DefaultDimension."Dimension Value Code";


                    ExpiryDateText := '';
                    if ExpiryDate <> 0D then
                        ExpiryDateText := Format(ExpiryDate);
                end
                else
                    CurrReport.Break();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ItemTextFilter; ItemNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Filter';
                        TableRelation = Item."No.";
                    }

                    field(RegDateTextFilter; RegDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Registration Date Filter';
                    }
                }
            }
        }
    }

    var
        QueryObject: Query ItemBinContentAsOf;

        // Filters
        ItemNoFilter: Code[20];
        RegDateFilter: Date;
        ItemTextFilter: Text;
        RegDateTextFilter: Text;

        // Date Fields
        ItemNo: Code[20];
        ItemDescr: Text[100];
        LocationCode: Code[20];
        BinCode: Code[20];
        LotNo: Code[50];
        QtyBaseAmount: Decimal;
        ExpiryDate: Date;
        ExpiryDateText: Text;
        ZoneCode: Code[20];
        BusinessSegmentCode: Code[20];

    trigger OnInitReport()
    begin
        // set default filter
        // RegDateFilter := Today;
        ItemTextFilter := '';
        RegDateTextFilter := '';
    end;

}
