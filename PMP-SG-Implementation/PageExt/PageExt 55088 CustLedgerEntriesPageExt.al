pageextension 55088 CustLedgerEntriesPageExt extends "Customer Ledger Entries"
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
            //DX        03 Dec 2021
            field(DocDescription; Rec.Description)
            {
                Caption = 'Description';
                ApplicationArea = all;
            }
            field(ExtDocNo; Rec."External Document No.")
            {
                Caption = 'External Doc No.';
                ApplicationArea = all;
            }
            field(OrderNo; OrderNo)
            {
                Caption = 'Order No.';
                ApplicationArea = all;
            }
            //DX        03 Dec 2021
            field(I9G_YourReference; Rec.I9G_YourReference)
            {
                Caption = 'Your Reference';
                ApplicationArea = all;
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
        addafter("Posting Date")
        {

            field("I9G_Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Date field.';
                Visible = false;
                Caption = 'Document Date';
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SIHRec: Record "Sales Invoice Header";
    begin
        OrderNo := '';
        if Rec."Document Type" = rec."Document Type"::Invoice then begin
            SIHRec.reset;
            SIHRec.SetRange("No.", Rec."Document No.");
            if SIHRec.FindFirst() then
                OrderNo := SIHRec."Order No.";
        end;
    end;

    var

        OrderNo: Code[20];
        SHRec: Record "Sales Invoice Header";
}
