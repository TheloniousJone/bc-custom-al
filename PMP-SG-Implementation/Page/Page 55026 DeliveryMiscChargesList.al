page 55026 "Delivery Misc Charges List"
{

    ApplicationArea = All;
    Caption = 'Delivery Misc Charges List';
    PageType = List;
    SourceTable = "Delivery Misc Charges";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = 55027;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field';
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field(Ice; Rec.Ice)
                {
                    ToolTip = 'Specifies the value of the Ice field';
                    ApplicationArea = All;
                }
                field("COD Amount"; Rec."COD Amount")
                {
                    ToolTip = 'Specifies the value of the COD Amount field';
                    ApplicationArea = All;
                }
                field("Cheque No And Amt Coll."; Rec."Cheque No And Amt Coll.")
                {
                    ToolTip = 'Specifies the value of the Cheque No And Amt Coll. field';
                    ApplicationArea = All;
                }
                field("NCNG Amount"; Rec."NCNG Amount")
                {
                    ToolTip = 'Specifies the value of the NCNG Amount field';
                    ApplicationArea = All;
                }
                field("Opening Hours"; Rec."Opening Hours")
                {
                    ToolTip = 'Specifies the value of the Opening Hours field';
                    ApplicationArea = All;
                }
                field(Instruction; Rec.Instruction)
                {
                    ToolTip = 'Specifies the value of the Instruction field';
                    ApplicationArea = All;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ToolTip = 'Specifies the value of the Delivey Charge field';
                    ApplicationArea = All;
                }

                field(Driver; Rec.Driver)
                {
                    ToolTip = 'Specifies the value of the Driver field';
                    ApplicationArea = All;
                }

                field("LS Account"; Rec."LS Account")
                {
                    ToolTip = 'Specifies the value of the LS Account field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
