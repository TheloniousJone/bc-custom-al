page 55119 "Sales Target"
{
    ApplicationArea = All;
    Caption = 'Sales Target';
    PageType = List;
    SourceTable = "Sales Target";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    LookupPageId = "Sales Target BU";
                }
                // field("Area"; Rec."Area")
                // {
                //     ApplicationArea = All;
                // }
                field(Version; Rec.Version)
                {
                    ApplicationArea = All;
                }
                field(Forecast; Rec.Forecast)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}