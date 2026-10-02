page 55115 "Bin Content in PMP-WH"
{
    ApplicationArea = All;
    Caption = 'Bin Content in PMP-WH';
    PageType = List;
    SourceTable = "Bin Content";
    UsageCategory = Administration;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control37)
            {
                ShowCaption = false;
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the location code of the bin.';
                    Visible = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Bin Type Code"; Rec."Bin Type Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the code of the bin type that was selected for this bin.';
                }
                /*
                field("Lot No. Filter"; Rec."Lot No. Filter")
                {
                    ApplicationArea = All;
                }
                field("Serial No. Filter"; Rec."Serial No. Filter")
                {
                    ApplicationArea = All;
                }
                */
                field(CalcQtyAvailToTakeUOM; Rec.CalcQtyAvailToTakeUOM())
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item that is available in the bin.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetDataFromQuery();
    end;

    local procedure GetDataFromQuery()
    var
        AvailPickQtyQuery: Query 55003;
        AvailPickQtyQueryVivomixx: Query 55006;
        ItemRec: Record Item;
    begin
        if AvailPickQtyQuery.Open() then begin
            while AvailPickQtyQuery.Read() do begin
                Rec.Reset();
                Rec.Init();
                Rec."Location Code" := AvailPickQtyQuery.Location_Code;
                Rec."Bin Code" := AvailPickQtyQuery.Bin_Code;
                Rec."Item No." := AvailPickQtyQuery.Item_No;
                Rec."Variant Code" := AvailPickQtyQuery.Variant_Code;
                Rec."Unit of Measure Code" := AvailPickQtyQuery.Unit_of_Measure_Code;
                Rec."Bin Type Code" := AvailPickQtyQuery.Bin_Type_Code;
                // Rec."Lot No. Filter" := AvailPickQtyQuery.Lot_No; // Need custom field
                // Rec."Serial No. Filter" := Format(AvailPickQtyQuery.Expiration_Date); // Need custom field
                if Rec.Insert(false) then;
            end;
        end;
        AvailPickQtyQuery.Close();

        // if AvailPickQtyQueryVivomixx.Open() then begin
        //     while AvailPickQtyQueryVivomixx.Read() do begin
        //         Rec.Reset();
        //         Rec.Init();
        //         Rec."Location Code" := AvailPickQtyQueryVivomixx.Location_Code;
        //         Rec."Bin Code" := AvailPickQtyQueryVivomixx.Bin_Code;
        //         Rec."Item No." := AvailPickQtyQueryVivomixx.Item_No;
        //         Rec."Variant Code" := AvailPickQtyQueryVivomixx.Variant_Code;
        //         Rec."Unit of Measure Code" := AvailPickQtyQueryVivomixx.Unit_of_Measure_Code;
        //         Rec."Bin Type Code" := AvailPickQtyQueryVivomixx.Bin_Type_Code;
        //         // Rec."Lot No. Filter" := AvailPickQtyQuery.Lot_No; // Need custom field
        //         // Rec."Serial No. Filter" := Format(AvailPickQtyQuery.Expiration_Date); // Need custom field
        //         if Rec.Insert(false) then;
        //     end;
        // end;
        // AvailPickQtyQueryVivomixx.Close();
    end;
}
