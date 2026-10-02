page 55085 "Import Chain Unapplied List"
{

    ApplicationArea = All;
    Caption = 'Import Chain Unapplied List';
    PageType = List;
    SourceTable = "LS Ledger Entry";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Import File Name';
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Import Sheet Name';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
            }
        }
    }

}
