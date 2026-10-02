page 57006 BIRepTagging
{

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'biRepTagging';
    DelayedInsert = true;
    EntityName = 'ProductRep';
    EntitySetName = 'ProductRep';
    PageType = API;
    SourceTable = "Product Rep Tagging";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(basic; Rec.Basic)
                {
                    Caption = 'Basic';
                }
                field(customerCode; Rec."Customer Code")
                {
                    Caption = 'Customer Code';
                }
                field(customerRelation; Rec."Customer Relation")
                {
                    Caption = 'Customer Relation';
                }
                field(discount; Rec.Discount)
                {
                    Caption = 'Discount';
                }
                field(exclusive; Rec.Exclusive)
                {
                    Caption = 'Exclusive';
                }
                field(findNext; Rec."Find Next")
                {
                    Caption = 'Find Next';
                }
                field(from; Rec.From)
                {
                    Caption = 'From';
                }
                field(itemCode; Rec."Item Code")
                {
                    Caption = 'Item Code';
                }
                field(itemRelation; Rec."Item Relation")
                {
                    Caption = 'Item Relation';
                }
                field(salesRepCode; Rec."Sales Rep. Code")
                {
                    Caption = 'Sales Rep. Code';
                }
                field(salesRepRelation; Rec."Sales Rep. Relation")
                {
                    Caption = 'Sales Rep. Relation';
                }
                field("to"; Rec."To")
                {
                    Caption = 'To';
                }
            }
        }
    }

}
