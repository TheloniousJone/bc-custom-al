page 55060 AddNewLS
{
    PageType = Card;
    Caption = 'Create new LS from Sales Invoice.';
    ApplicationArea = All;
    UsageCategory = Tasks;
    //SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(Details)
            {
                field(SIHRECNo; SIHRec."No.")
                {
                    ApplicationArea = all;
                    Caption = 'Select Sales Invoice to add new LS Record';
                    TableRelation = "Sales Invoice Header"."No.";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add New Transaction")
            {
                ApplicationArea = all;
                Caption = 'Add Invoice to LS.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Process;
                trigger OnAction()
                begin
                    IF SIHrec."No." <> '' THEN BEGIN
                        CheckCSLE.RESET;
                        CheckCSLE.SETRANGE("Document No.", SIHrec."No.");
                        IF CheckCSLE.COUNT > 0 THEN
                            ERROR('Sales Invoice %1 already has existing LS Entries, unable to insert.', SIHrec."No.");

                        IF DIALOG.CONFIRM('Do you want to insert sales invoice to LS Entries?') THEN BEGIN
                            PMPCU.InsertAdjLine(SIHRec."No.");
                        end;
                    END;
                END;
            }


        }
    }

    trigger OnClosePage()
    begin

    end;

    var
        myInt: Integer;
        SIHRec: Record "Sales Invoice Header";
        PMPCU: Codeunit LS;
        AdjDate: Date;
        AdjQty: Decimal;

        SILRec: Record "Sales Invoice Line";
        EntryNo: Integer;
        ContractLERec: Record "LS Ledger Entry";
        CheckCSLE: record "LS Ledger Entry";
        DOContractRec: Record "LS Ledger Entry";
}