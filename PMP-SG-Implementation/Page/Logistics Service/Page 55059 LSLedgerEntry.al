page 55059 "LS Ledger Entry"
{

    ApplicationArea = All;
    Caption = 'LS Ledger Entry';
    PageType = List;
    SourceTable = "LS Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field';
                    ApplicationArea = All;
                }

                field("LS Account"; Rec."LS Account")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field("Ext. Doc No."; Rec."Ext. Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field("FOC Quantity"; Rec."FOC Quantity")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                }
                field("Amount Incl GST"; Rec."Amount Incl GST")
                {
                    ToolTip = 'Specifies the value of the Amount Incl GST field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field';
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field';
                    ApplicationArea = All;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = all;
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    ApplicationArea = all;
                }

                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Adjust Calc. Method")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = AdjustEntries;
                trigger OnAction()
                var
                    myInt: Integer;
                    LSREc: Record "LS Ledger Entry";
                    LSPage: Page LSAdjustCommCard;
                begin
                    if Rec.Closed = true then
                        Error('Cannot adjust entries that have been closed already.');
                    CurrPage.SetSelectionFilter(LSREc);
                    Page.Run(55063, LSREc);
                end;
            }
        }
    }
}
