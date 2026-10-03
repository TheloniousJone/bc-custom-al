page 55016 "Checking Details List"
{

    ApplicationArea = All;
    Caption = 'Checking Details List';
    PageType = List;
    SourceTable = "Checking Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ToolTip = 'Specifies the value of the Doc No. field';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field';
                    ApplicationArea = All;
                }
                field(Cubage; Rec.Cubage)
                {
                    ToolTip = 'Specifies the value of the Cubage field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field';
                    ApplicationArea = All;
                }

                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }

                field("Qty. Base"; Rec."Qty. Base")
                {
                    ToolTip = 'Specifies the value of the Qty. Base field';
                    ApplicationArea = All;
                }
                field("Qty. Per Unit Of Measure"; Rec."Qty. Per Unit Of Measure")
                {
                    ToolTip = 'Specifies the value of the Qty. Per Unit Of Measure field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field';
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
