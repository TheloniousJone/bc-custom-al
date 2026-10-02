page 57020 ItemBinContentAsOfDate
{
    Caption = 'Item Bin Content As Of Date';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ItemBinContentAsQueryTable;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;



    layout
    {
        area(content)
        {
            field(ItemTextFilter; ItemNoFilter)
            {
                ApplicationArea = All;
                Caption = 'Item Filter';
                TableRelation = Item."No.";

                trigger OnValidate()
                begin
                    GetQueryObjectData();
                    CurrPage.Update();
                end;

            }

            field(RegDateTextFilter; RegDateFilter)
            {
                ApplicationArea = All;
                Caption = 'Registration Date Filter';

                trigger OnValidate()
                begin
                    GetQueryObjectData();
                    CurrPage.Update();
                end;
            }
            repeater(General)
            {
                field(I9G_ItemNo; Rec.I9G_ItemNo)
                {
                    ApplicationArea = All;
                }
                field(I9G_ItemDescr; Rec.I9G_ItemDescr)
                {
                    ApplicationArea = All;
                }
                field(I9G_LocationCode; Rec.I9G_LocationCode)
                {
                    ApplicationArea = All;
                }
                field(I9G_BinCode; Rec.I9G_BinCode)
                {
                    ApplicationArea = All;
                }
                field(I9G_LotNo; Rec.I9G_LotNo)
                {
                    ApplicationArea = All;
                }
                field(I9G_ExpiryDate; Rec.I9G_ExpiryDate)
                {
                    ApplicationArea = All;
                }
                field(I9G_QtyBaseAmount; Rec.I9G_QtyBaseAmount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ExpiryDateText: Text;
        ItemNoFilter: Code[20];
        RegDateFilter: Date;
        ItemTextFilter: Text;
        RegDateTextFilter: Text;
        QueryObject: Query ItemBinContentAsOf;


    trigger OnInit()
    var
        ItemRec: Record Item;
    begin
        // RegDateFilter := Today;
        // if ItemRec.Get() then
        //     ItemNoFilter := ItemRec."No.";
    end;

    trigger OnOpenPage()
    begin
        GetQueryObjectData();
        CurrPage.Update();
    end;


    procedure GetQueryObjectData()
    var
        ILERec: Record "Item Ledger Entry";
    begin
        if StrLen(ItemNoFilter) > 0 then
            QueryObject.SetRange(Item_No_Filter, ItemNoFilter)
        else
            QueryObject.SetRange(Item_No_Filter);
        if RegDateFilter <> 0D then
            QueryObject.SetFilter(Registering_Date, '..%1', RegDateFilter)
        else
            QueryObject.SetFilter(Registering_Date, '');

        QueryObject.SetFilter(Base_Qty, '<>%1', 0);


        Rec.DeleteAll();
        if QueryObject.Open() then begin
            while QueryObject.Read() do begin
                Rec.Init();
                Rec.I9G_Row := Rec.I9G_Row + 1;
                Rec.I9G_ItemNo := QueryObject.Item_No;
                Rec.I9G_ItemDescr := QueryObject.ItemDesc;
                Rec.I9G_LocationCode := QueryObject.Location_Code;
                Rec.I9G_BinCode := QueryObject.Bin_Code;
                Rec.I9G_LotNo := QueryObject.Lot_No_;
                Rec.I9G_QtyBaseAmount := QueryObject.Base_Qty;

                Rec.I9G_ExpiryDate := 0D;

                ILERec.Reset();
                ILERec.SetCurrentKey("Item No.", "Lot No.");
                ILERec.SetLoadFields("Entry No.", "Item No.", "Lot No.", "Expiration Date");
                ILERec.SetRange("Item No.", Rec.I9G_ItemNo);
                ILERec.SetRange("Lot No.", Rec.I9G_LotNo);

                //ILERec.SetCurrentKey("Entry No.");
                //ILERec.SetAscending("Entry No.", false);

                if ILERec.findlast() then
                    Rec.I9G_ExpiryDate := ILERec."Expiration Date";

                // ExpiryDateText := '';
                // if Rec.I9G_ExpiryDate <> 0D then
                //     ExpiryDateText := Format(Rec.I9G_ExpiryDate);

                Rec.Insert();
            end;
            QueryObject.Close();
        end;
    end;
}