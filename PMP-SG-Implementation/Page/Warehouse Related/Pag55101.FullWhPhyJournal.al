page 55101 FullWhPhyJournal
{

    ApplicationArea = All;
    Caption = 'FullWhPhyJournal';
    PageType = List;
    SourceTable = "Warehouse Journal Line";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = All;
                }
                field("Registering Date"; Rec."Registering Date")
                {
                    ToolTip = 'Specifies the value of the Registering Date field.';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.';
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Phys. Inventory"; Rec."Phys. Inventory")
                {
                    ToolTip = 'Specifies the value of the Phys. Inventory field.';
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ToolTip = 'Specifies the value of the Zone Code field.';
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.';
                    ApplicationArea = All;
                }
                field("Qty. (Calculated)"; Rec."Qty. (Calculated)")
                {
                    ToolTip = 'Specifies the value of the Qty. (Calculated) field.';
                    ApplicationArea = All;
                }
                field("Qty. (Phys. Inventory)"; Rec."Qty. (Phys. Inventory)")
                {
                    ToolTip = 'Specifies the value of the Qty. (Phys. Inventory) field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
