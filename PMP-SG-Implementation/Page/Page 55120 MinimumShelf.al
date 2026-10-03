page 55120 MinimumShelf
{
    Caption = 'Min Shelf Life';
    SourceTable = MinimumShelf;
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Product Code';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", Rec."No.");

                        if Item.FindFirst() then begin
                            Rec.Description := Item.Description;
                            CurrPage.Update(true);
                        end;
                    end;
                }

                field(Description; Rec.Description)
                {
                    Caption = 'Product Name';
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    Caption = 'Chain Pharmacy';
                    ApplicationArea = All;
                }
                field(MinShelf; Rec.MinShelf)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        MiniShelf: Record MinimumShelf;
}