pageextension 55102 ItemTracingPageExt extends "Item Tracing"
{
    layout
    {
        // layout changes here
        addafter("Lot No.")
        {
            field(ExpiryDate; ExpiryDate)
            {
                Caption = 'Expiry Date';
                ApplicationArea = All;
                Editable = false;
            }

            field(InvoiceNo; InvoiceNo)
            {
                Caption = 'Invoice No.';
                ApplicationArea = All;
                Editable = false;
            }
            field(ExtNo; ExtNo)
            {
                Caption = 'Ext Doc No.';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // action changes here
    }

    var
        ExpiryDate: Date;
        InvoiceNo: Code[20];
        ExtNo: Code[35];

    local procedure RefreshAdditionalData()
    var
        ILERec: Record "Item Ledger Entry";
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        InvoiceNo := '';
        ExtNo := '';
        ExpiryDate := 0D;

        ILERec.Reset;
        if ILERec.Get(Rec."Item Ledger Entry No.") then begin
            ExpiryDate := ILERec."Expiration Date";
            InvoiceNo := PMPCU.GetInvNo(ILERec);
            ExtNo := PMPCU.GetExtDocNo(ILERec);

        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshAdditionalData();
    end;

    trigger OnAfterGetRecord()
    begin
        RefreshAdditionalData();
    end;

}
