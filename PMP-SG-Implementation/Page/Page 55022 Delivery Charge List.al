page 55022 "Delivery Charge List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Delivery Charge";
    
    Caption = 'Delivery Charge List';

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ToolTip = 'Specifies the value of the Delivery Charge field';
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;

                }

                //DX        17 Aug 2021
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                //DX        17 Aug 2021

            }
        }
    }
}