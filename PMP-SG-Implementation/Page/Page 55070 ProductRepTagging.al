page 55070 "Product Rep Tagging"
{
    
    ApplicationArea = All;
    Caption = 'Product Rep Tagging';
    PageType = List;
    SourceTable = "Product Rep Tagging";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Relation"; Rec."Item Relation")
                {
                    ToolTip = 'Specifies the value of the Item Relation field';
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                }
                field("Customer Relation"; Rec."Customer Relation")
                {
                    ToolTip = 'Specifies the value of the Customer Relation field';
                    ApplicationArea = All;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field';
                    ApplicationArea = All;
                }
                field("Sales Rep. Relation"; Rec."Sales Rep. Relation")
                {
                    ToolTip = 'Specifies the value of the Sales Rep. Relation field';
                    ApplicationArea = All;
                }
                field("Sales Rep. Code"; Rec."Sales Rep. Code")
                {
                    ToolTip = 'Specifies the value of the Sales Rep. Code field';
                    ApplicationArea = All;
                }
                field(Exclusive; Rec.Exclusive)
                {
                    ToolTip = 'Specifies the value of the Exclusive field';
                    ApplicationArea = All;
                }
                field(From; Rec.From)
                {
                    ToolTip = 'Specifies the value of the From field';
                    ApplicationArea = All;
                }
                field("To"; Rec."To")
                {
                    ToolTip = 'Specifies the value of the To field';
                    ApplicationArea = All;
                }
                field(Basic; Rec.Basic)
                {
                    ToolTip = 'Specifies the value of the Basic field';
                    ApplicationArea = All;
                }
                field(Discount; Rec.Discount)
                {
                    ToolTip = 'Specifies the value of the Discount field';
                    ApplicationArea = All;
                }
                field("Find Next"; Rec."Find Next")
                {
                    ToolTip = 'Specifies the value of the Find Next field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
