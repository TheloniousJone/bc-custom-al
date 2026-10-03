pageextension 55200 I9PMP_ValueEntries extends "Value Entries"
{
    layout
    {
        addlast(Control1)
        {
            // Add system last modified at field // Begin
            field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            // Add system last modified at field // End

            /*
            field("I9G Item Ledger Entry No."; Rec."Item Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Ledger Entry No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G Document No."; Rec."Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the document number on the entry.';
                Visible = false;
            }
            field("I9G Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the entry''s posting date.';
                Visible = false;
            }
            field("I9G Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the document date.';
                Visible = false;
            }
            field("I9G Document Type"; Rec."Document Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the document type that the entry belongs to.';
                Visible = false;
            }
            field("I9G Document Line No."; Rec."Document Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number of the document that the entry originated from.';
                Visible = false;
            }
            field("I9G Description"; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a description of the entry.';
                Visible = false;
            }
            field("I9G Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the location that the entry is linked to.';
                Visible = false;
            }
            field("I9G Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                Visible = false;
            }
            field("I9G Source Posting Group"; Rec."Source Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which salesperson or purchaser is assigned to the entry.';
                Visible = false;
            }
            field("I9G User ID"; Rec."User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G Source Code"; Rec."Source Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G Applies-to Entry"; Rec."Applies-to Entry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the entry has been part of an apply entries process.';
                Visible = false;
            }
            field("I9G Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                Visible = false;
            }
            field("I9G Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                Visible = false;
            }
            field("I9G Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies where the entry originated.';
                Visible = false;
            }
            field("I9G External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                Visible = false;
            }
            field("I9G Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code explaining why the item was returned.';
                Visible = false;
            }
            field("I9G Discount Amount"; Rec."Discount Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the amount of the discount.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 3, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 4, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 5, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 6, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 7, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 8, which is one of dimension codes that you set up in the General Ledger Setup window.';
                Visible = false;
            }
            field("I9G Variance Type"; Rec."Variance Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Variance Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G Partial Revaluation"; Rec."Partial Revaluation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies that the value entry has been created by partial revaluation of an item.';
                Visible = false;
            }
            field("I9G Dimension Set ID"; Rec."Dimension Set ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related job.';
                Visible = false;
            }
            field("I9G Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related job task.';
                Visible = false;
            }
            field("I9G Job Ledger Entry No."; Rec."Job Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the entry number of the job ledger entry that the value entry is linked to.';
                Visible = false;
            }
            field("I9G Capacity Ledger Entry No."; Rec."Capacity Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the capacity ledger entry that the value entry is linked to.';
                Visible = false;
            }
            field("I9G Type"; Rec.Type)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G No."; Rec."No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                Visible = false;
            }
            field("I9G Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expected cost amount that was posted to the general ledger for this value entry.';
                Visible = false;
            }
            field("I9G Cost per Unit (ACY)"; Rec."Cost per Unit (ACY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unit cost of the item on this entry, in the additional reporting currency.';
                Visible = false;
            }
            field("I9G Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expected cost, in the additional reporting currency.';
                Visible = false;
            }
            field("I9G Cost Posted to G/L (ACY)"; Rec."Cost Posted to G/L (ACY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the cost amount that was posted to the general ledger for this value entry in the additional reporting currency.';
                Visible = false;
            }
            field("I9G Valued by Average Cost"; Rec."Valued by Average Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if this value entry has been valued by the average cost calculation.';
                Visible = false;
            }
            field("I9G Item Charge No."; Rec."Item Charge No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item charge number that this value entry is linked to.';
                Visible = false;
            }
            field("I9G Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G Order Type"; Rec."Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which type of transaction that the entry is created from.';
                Visible = false;
            }
            field("I9G Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the order that created the entry.';
                Visible = false;
            }
            field("I9G Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number of the order that created the entry.';
                Visible = false;
            }
            field("I9G SystemCreatedAt"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                Visible = false;
            }
            field("I9G SystemCreatedBy"; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                Visible = false;
            }
            field("I9G SystemId"; Rec.SystemId)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                Visible = false;
            }
            field("I9G SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            field("I9G SystemModifiedBy"; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                Visible = false;
            }
            */
        }
    }

    actions
    {
        // Add actions here if needed
    }

    var
    // Add variables here if needed
}