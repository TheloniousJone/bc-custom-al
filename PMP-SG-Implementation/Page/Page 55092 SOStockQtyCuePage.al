page 55092 SOStockQtyCuePage
{

    Caption = 'SO Stock Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(StockCueContainer)
            {
                Caption = 'Sales Line Stock Alert';
                field("Unarchived SO OOS"; Rec."Unarchived SO OOS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Unarchived SO OOS field.';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }


                field("SO Lines without Stock"; Rec."SO Lines without Stock")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Line Out of Stock';
                    Image = Document;
                    DrillDownPageId = "SO No Stock Qty List";
                }

                field("SO Lines to Replenish"; Rec."SO Lines to Replenish")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Line Insufficient Stocks in Active Area';
                    Image = Document;
                    DrillDownPageId = "SO Replenish Stock Qty List";
                }
                field("STO Replenished"; Rec."STO Replenished")
                {
                    ApplicationArea = All;
                    Caption = 'STO Items Replenished';
                    Image = Document;
                    DrillDownPageId = "Sales Lines";
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.get then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}
