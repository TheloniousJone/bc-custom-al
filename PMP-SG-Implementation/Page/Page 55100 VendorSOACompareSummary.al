page 55100 "Vendor SOA Comparison List"
{

    ApplicationArea = All;
    Caption = 'Vendor SOA Comparison List';
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

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Vendor No.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VLE Posting Date';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Template Invoice No.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VLE Document No.';
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Template Amount';
                }

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VLE Amount';
                }

                field("Amount Incl GST"; Rec."Amount Incl GST")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Difference';
                }
            }
        }
    }

}
