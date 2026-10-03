pageextension 55089 VendLedgerEntriesPageExt extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Document Type")
        {
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = All;
            }

            field("Journal Batch Description"; Rec."Journal Batch Description")
            {
                ApplicationArea = All;
            }

            // Add system last modified at field // Begin
            field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            // Add system last modified at field // End
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            action("Compare Vendor SOA")
            {
                ApplicationArea = All;
                Image = CompareCOA;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    IntegrationCU: Codeunit "PMP Integrations";
                begin
                    Clear(IntegrationCU);
                    IntegrationCU.CompareVendorSOA();
                end;
            }
        }
    }
}
