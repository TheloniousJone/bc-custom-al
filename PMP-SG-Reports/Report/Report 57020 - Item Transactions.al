report 57020 "Item Transaction"
{
    ApplicationArea = All;
    Caption = 'Item Transactions';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57020 - Item Transactions.rdl';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type" = Filter('Sale|Purchase'));
            RequestFilterFields = "Item No.", "Posting Date";
            column(Quantity; Quantity)
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(PostingDate; FORMAT("Posting Date"))
            {
            }
            column(OrderNo; OrderNo)
            {
            }
            column(OrderType; "Order Type")
            {
            }
            column(OrderLineNo; "Order Line No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(DocumentDate; FORMAT("Document Date"))
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(InvNo; InvNo)
            {

            }
            column(DocumentType; "Document Type")
            {
            }
            column(Description; Description)
            {
            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                VLERec.reset;
                VLERec.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                if VLERec.FindFirst() then begin
                    InvNo := VLERec."Document No.";
                    SIHRec.reset;
                    SIHRec.SetRange("No.", InvNo);
                    if SIHRec.FindFirst() then begin
                        OrderNo := SIHRec."Order No.";

                    end;
                end else begin
                    InvNo := '';
                    OrderNo := '';
                end;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        InvNo: Code[20];
        VLERec: Record "Value Entry";
        SIHRec: Record "Sales Invoice Header";
        OrderNo: Code[20];
}
