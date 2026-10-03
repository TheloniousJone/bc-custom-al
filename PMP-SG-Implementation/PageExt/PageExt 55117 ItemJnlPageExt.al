pageextension 55117 ItemJnlPageExt extends "Item Journal"
{
    layout
    {
        addafter("Location Code")
        {
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
        }
        //RL    12 Jan 2022
        addafter(Description)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
            field("Selected Lot"; SelectedItemTrackingLot)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Selected Expiry"; SelectedExpiry)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        //RL    12 Jan 2022

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ReservEntry: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
    begin
        SelectedItemTrackingLot := '';
        SelectedExpiry := 0D;

        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", Rec."Item No.");
        ReservEntry.SetRange("Source Type", 83);
        ReservEntry.SetRange("Source Subtype", 3);
        ReservEntry.SetRange("Source ID", Rec."Journal Template Name");
        ReservEntry.SetRange("Source Batch Name", rec."Journal Batch Name");
        ReservEntry.Setrange("Source Ref. No.", rec."Line No."); //RL 15 Dec 2021 - cater for multiple lines of the same item
        if ReservEntry.FindFirst() then begin
            SelectedItemTrackingLot := ReservEntry."Lot No.";
            ILERec.Reset;
            ILERec.SetRange("Item No.", Rec."Item No.");
            ILERec.SetRange("Lot No.", SelectedItemTrackingLot);
            if ILERec.FindLast() then
                SelectedExpiry := ILERec."Expiration Date";
        end;


    end;

    // YF 21 Feb 2022
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Reset;
        ItemJnlBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlBatch.SetRange(Name, Rec."Journal Batch Name");
        if ItemJnlBatch.FindFirst() then begin
            if ItemJnlBatch."Gen. Prod. Posting Group" <> '' then
                Rec.Validate("Gen. Prod. Posting Group", ItemJnlBatch."Gen. Prod. Posting Group");
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Reset;
        ItemJnlBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlBatch.SetRange(Name, Rec."Journal Batch Name");
        if ItemJnlBatch.FindFirst() then begin
            if ItemJnlBatch."Gen. Prod. Posting Group" <> '' then
                Rec.Validate("Gen. Prod. Posting Group", ItemJnlBatch."Gen. Prod. Posting Group");
        end;
    end;
    // YF 21 Feb 2022

    var
        SelectedItemTrackingLot: code[20];
        SelectedExpiry: Date;

}