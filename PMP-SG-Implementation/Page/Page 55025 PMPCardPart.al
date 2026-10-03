page 55025 PMPCardPart
{

    Caption = 'PMP Info';
    PageType = CardPart;
    SourceTable = "Sales Line";

    /*
    Location code
    Last sold qty
    last Foc qty
    Last Sold per pc price
    Date
    */

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Last Qty Sold"; EnhanceCU.GetLastItemSoldQuantity(Rec))
                {
                    ApplicationArea = all;
                }
                field("FOC Qty"; EnhanceCU.GetLastItemSoldFOCQuantity(REc))
                {
                    ApplicationArea = all;
                }
                field(Price; EnhanceCU.GetLastSoldPriceBeforeFOC(Rec))
                {
                    ApplicationArea = all;
                }
                field("Transaction Date"; EnhanceCU.GetLastSoldDate(Rec))
                {
                    ApplicationArea = all;
                }

                field("Net Available Qty"; EnhanceCU.GetNetAvailQty(rec))
                {
                    ApplicationArea = all;
                    ToolTip = 'Net Qty Available after picking is allocated.';
                }

            }
        }
    }

    var
        EnhanceCU: Codeunit "PMP-Enhancements";
        LocCode: Code[20];
        SoldQty: Decimal;
        FOCQty: Decimal;
        Price: Decimal;
        TransDate: Date;
}
