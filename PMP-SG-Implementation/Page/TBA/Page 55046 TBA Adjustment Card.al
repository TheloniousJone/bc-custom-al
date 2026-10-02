page 55046 "TBA Adjustment Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    //SourceTable = ;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                    Caption = 'Select Sales Entry To Adjust.';
                    TableRelation = "TBA Ledger Entry"."Entry No." where("Entry Type" = const(Sale));
                    trigger OnValidate()
                    begin
                        if EntryNo <> 0 then begin
                            IF EntryNo <> 0 THEN BEGIN
                                ContractRec.RESET;
                                ContractRec.SETRANGE("Entry No.", EntryNo);
                                IF ContractRec.FINDFIRST THEN BEGIN
                                    ContractRec.CALCFIELDS("Remaining Qty");
                                    CustRec.RESET;
                                    CustRec.GET(ContractRec."Customer No.");
                                    ItemRec.RESET;
                                    ItemRec.GET(ContractRec."Item No.");
                                    QtyRem := 0;
                                    QtyRemCSLRec.RESET;
                                    QtyRemCSLRec.SETRANGE("Apply To Doc No.", ContractRec."Document No.");
                                    QtyRemCSLRec.SETRANGE("Item No.", ContractRec."Item No.");
                                    IF QtyRemCSLRec.FINDSET THEN
                                        REPEAT
                                            QtyRem += QtyRemCSLRec.Quantity;
                                        UNTIL QtyRemCSLRec.NEXT = 0;
                                    IF QtyRem = 0 THEN
                                        SetEditable := FALSE
                                    ELSE
                                        SetEditable := TRUE;

                                END;
                            END;

                        end;
                    end;
                }
                field("DO Doc. No."; DODocNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SetEditable := FALSE;
                    end;

                }

            }
            group("Entry Details")
            {
                Editable = false;
                field("Customer No."; ContractRec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; CustRec.Name)
                {
                    ApplicationArea = all;
                }
                field("Document No."; ContractRec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; ContractRec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; ItemRec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; ContractRec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; ContractRec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Unit Of Measure"; ContractRec."Unit Of Measure Code")
                {
                    ApplicationArea = all;
                }
                field(Remarks; ContractRec.Remarks)
                {
                    ApplicationArea = all;
                }
                field("Qty Remaining"; ContractRec."Remaining Qty")
                {
                    ApplicationArea = all;
                    editable = false;
                }
                //DX        01 July 2021
                field("Bin Remarks"; ContractRec."Bin Remarks")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
            }
            group("Adjustment Details")
            {
                field(EntryType; EntryType)
                {
                    ApplicationArea = all;
                }
                field("Adjustment Date"; AdjDate)
                {
                    ApplicationArea = all;
                }
                field("Adjustment Qty"; AdjQty)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF (QtyRem - AdjQty < 0) THEN
                            ERROR('Quantity to adjust cannot be less than 0 after deducting remaining quantity');
                    end;
                }
                field("Adj. Remarks"; lRemarks)
                {
                    ApplicationArea = all;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Insert Adjustmnet Line")
                {
                    ApplicationArea = all;
                    Caption = 'Confirm Adjustment Line';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Process;
                    trigger OnAction()
                    var

                    begin
                        IF (EntryNo <> 0) AND (AdjQty <> 0) THEN BEGIN
                            if AdjQty < 0 then
                                Error('Please enter positive figures to deduct.');
                            IF DIALOG.CONFIRM('Do you want to insert an adjustment line?') THEN BEGIN
                                TBACU.InsertAdjSalesLine(ContractRec, AdjQty, AdjDate, lRemarks);
                                CurrPage.Update(false);
                            END;

                        END;

                    end;
                }
            }

        }
    }

    trigger OnClosePage()
    begin

    end;

    trigger OnInit()
    begin

        SetEditable := true;
    end;

    trigger OnOpenPage()
    begin
        AdjDate := WorkDate()
    end;

    var
        myInt: Integer;
        EntryNo: Integer;
        DODocNo: Code[20];
        ContractRec: Record "TBA Ledger Entry";
        QtyRem: Decimal;
        QtyRemCSLRec: Record "TBA Ledger Entry";
        SetEditable: Boolean;
        CustRec: Record Customer;
        ItemRec: Record item;
        EntryType: Option Adjustment;
        AdjQty: Decimal;
        AdjDate: Date;
        lRemarks: text[100];
        TBACU: Codeunit TBA;
}