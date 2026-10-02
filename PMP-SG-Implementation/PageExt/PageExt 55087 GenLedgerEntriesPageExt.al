pageextension 55087 GenLedgerEntriesPageExt extends "General Ledger Entries"
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
        }

        // YF 18 May 2022
        addafter(Amount)
        {
            field("Foreign Currency Code"; Rec."Foreign Currency Code")
            {
                ApplicationArea = All;
                Caption = 'Foreign Currency Code';
            }

            field("Foreign Currency Amount"; Rec."Foreign Currency Amount")
            {
                ApplicationArea = All;
                Caption = 'Foreign Currency Amount';
            }

            field("Foreign Currency Exchange Rate"; Rec."Foreign Currency Exchange Rate")
            {
                ApplicationArea = All;
                Caption = 'Foreign Currency Exchange Rate';
                DecimalPlaces = 2 : 5;
            }
            field(I9G_YourReference; Rec.I9G_YourReference)
            {
                Caption = 'Your Reference';
                ApplicationArea = all;
            }
        }
        // YF 18 May 2022    

        // RL 22 Aug 2022
        addlast(Control1)
        {
            field(I9G_NotInBISales; NotInBISales)
            {
                ApplicationArea = All;
                Caption = 'Not in BISales';
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
    var
        NotInBISales: Boolean;

    trigger OnAfterGetRecord()
    begin

        NotInBISales := false;

        if (Rec."Gen. Prod. Posting Group" = 'MISC') AND (Rec."Source Code" = 'SALES') then
            NotInBISales := true;

    end;
}
