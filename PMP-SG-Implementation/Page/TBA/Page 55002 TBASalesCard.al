page 55002 TBASalesCard
{
    PageType = Card;
    Caption = 'Create new TBA from Sales Invoice.';
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
                    Caption = 'Select Sales Invoice to add new TBA Record';
                    TableRelation = "Sales Invoice Header"."No.";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add Adj. Line")
            {
                ApplicationArea = all;
                Caption = 'Add Delivery To Existing DO.';
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
                            ERROR('Sales Invoice %1 already has existing TBA Entries, unable to insert.', SIHrec."No.");

                        IF DIALOG.CONFIRM('Do you want to insert sales invoice to TBA Entries?') THEN BEGIN
                            TBACU.InsertAdjLine(SIHRec."No.");
                        end;
                    END;
                END;
            }

            //DX        04 July 2021    Add adjustment into TBA to remove stock if CN
            action("Add CN. Line")
            {
                ApplicationArea = all;
                Caption = 'Add Qty Adj.';
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
                            ERROR('Sales Invoice %1 already has existing TBA Entries, unable to insert.', SIHrec."No.");

                        IF DIALOG.CONFIRM('Do you want to insert sales invoice to TBA Entries?') THEN BEGIN
                            TBACU.InsertAdjLine(SIHRec."No.");
                        end;
                    END;
                END;
            }
            //DX        04 July 2021
        }
    }

    trigger OnClosePage()
    begin

    end;

    var
        myInt: Integer;
        SIHRec: Record "Sales Invoice Header";
        CheckCSLE: Record "TBA Ledger Entry";
        TBACU: Codeunit TBA;
        AdjDate: Date;
        AdjQty: Decimal;

        SILRec: Record "Sales Invoice Line";
        EntryNo: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        DOContractRec: Record "TBA Ledger Entry";
}