page 55057 UpdateExchangeable
{

    Caption = 'Update Exchangeable Status';
    PageType = Card;
    SourceTable = Item;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ItemCode; ItemCode)
                {
                    Caption = 'Select Item Code.';
                    ApplicationArea = all;
                    TableRelation = Item."No.";
                }
                field(ItemBatch; ItemBatch)
                {
                    Caption = 'Select Item Batch.';
                    ApplicationArea = all;
                    TableRelation = "Item Ledger Entry"."Lot No." where("Item No." = field("No."));
                }
                field(UpdatedBool; UpdatedBool)
                {
                    Caption = 'Select updated exchangeable status.';
                    ApplicationArea = all;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Update)
            {
                Caption = 'Confirm Update.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    myInt: Integer;
                    EnhaceCU: Codeunit "PMP-Enhancements";
                begin
                    if (ItemBatch = '') or (ItemCode = '') then
                        Error('Please select Item code and Item Batch before processing.')
                    else begin
                        EnhaceCU.UpdateExchangeable(ItemCode, ItemBatch, UpdatedBool);
                    end;



                end;


            }
        }
    }

    var
        ItemCode: Code[20];
        ItemBatch: code[50];
        UpdatedBool: Boolean;
}
