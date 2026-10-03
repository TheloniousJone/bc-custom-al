page 70003 I9G_PstdDirectTransferUpdate
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Direct Trans. Header";
    SourceTableTemporary = true;
    Caption = 'Posted Direct Transfer - Update';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(I9G_CaseNumber; Rec.I9G_CaseNumber)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(I9G_CaseDR; Rec.I9G_CaseDR)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(I9G_DateUsed; Rec.I9G_DateUsed)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(I9G_DeliveryDate; Rec.I9G_DeliveryDate)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
            group("Transfer Details")
            {
                Caption = 'Transfer Details';
                field(I9G_Remarks; Rec.I9G_Remarks)
                {
                    ApplicationArea = All;
                    Editable = true;
                    MultiLine = true;
                }
                field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
                {
                    ApplicationArea = All;
                    Editable = true;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        xDirectTransferHeader := Rec;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged() then
                CODEUNIT.Run(CODEUNIT::I9G_DirectTransferHeaderEdit, Rec);
    end;

    var
        xDirectTransferHeader: Record "Direct Trans. Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged := (Rec.I9G_Remarks <> xDirectTransferHeader.I9G_Remarks) or
          (Rec.I9G_InternalRemarks <> xDirectTransferHeader.I9G_InternalRemarks) or
          (Rec.I9G_CaseNumber <> xDirectTransferHeader.I9G_CaseNumber) or
          (Rec.I9G_DateUsed <> xDirectTransferHeader.I9G_DateUsed) or
          (Rec.I9G_DeliveryDate <> xDirectTransferHeader.I9G_DeliveryDate) or
          (Rec.I9G_CaseDR <> xDirectTransferHeader.I9G_CaseDR);
    end;

    procedure SetRec(DirectTransferHeader: Record "Direct Trans. Header")
    begin
        Rec := DirectTransferHeader;
        Rec.Insert();
    end;
}

