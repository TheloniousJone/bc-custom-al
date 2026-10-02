page 55001 "TBA Delivery Card"
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
                    Caption = 'Select Sales Entry To Deliver.';
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
                                    Driver := CustRec."Delivery Zone";
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
                field(delCharge; ContractRec."Delivery Charge")
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
                        IF (EntryType = EntryType::Delivery) AND (QtyRem - AdjQty < 0) THEN
                            ERROR('Quantity to deliver cannot be less than 0 after deducting remaining quantity');
                    end;
                }
                field("Adj. Remarks"; lRemarks)
                {
                    ApplicationArea = all;
                }
                field("Delivery Zone"; Driver)
                {
                    ApplicationArea = all;
                    Caption = 'Delivery Zone';
                    TableRelation = "Delivery Zone"."Delivery Zone";
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
                action("Add Entry")
                {
                    ApplicationArea = all;
                    Caption = 'Add Delivery To Existing DO.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Process;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CSLFilter: Record "TBA Ledger Entry";
                        CSLPage: page "TBA Ledger Entry";
                        CSLRec: Record "TBA Ledger Entry";
                        DOEntry: Integer;
                    begin
                        IF EntryNo = 0 THEN
                            ERROR('Please select existing Sales Entry first');
                        CLEAR(CSLPage);
                        CSLFilter.RESET;
                        CSLFilter.SETRANGE("Entry Type", CSLFilter."Entry Type"::Delivery);
                        CSLFilter.SETRANGE("Customer No.", CustRec."No.");
                        CSLFilter.SETRANGE("Apply To Doc No.", ContractRec."Document No.");
                        CSLPage.SETTABLEVIEW(CSLFilter);
                        CSLPage.LOOKUPMODE := TRUE;
                        CSLPage.CAPTION := 'Select Delivery Order to add to';
                        //LineNo := 10000;
                        //DespSetup.GET;
                        IF CSLPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            CSLPage.ReturnFilters(CSLRec);
                            //DOEntryNo := CSLRec."Document No.";
                            DODocNo := CSLRec."Document No.";
                        END;

                    end;
                }

                action("Insert Delivery Line")
                {
                    ApplicationArea = all;
                    Caption = 'Confirm Delivery Line';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Process;
                    trigger OnAction()
                    var

                    begin
                        IF (EntryNo <> 0) AND (AdjQty <> 0) THEN BEGIN
                            if Driver = '' then
                                Error('Please select delivery zone.');
                            IF DIALOG.CONFIRM('Do you want to insert a delivery line?') THEN BEGIN
                                IF (EntryType = EntryType::Delivery) AND (DODocNo = '') THEN
                                    TBACU.InsertDeliveryLine(AdjDate, AdjQty, lRemarks, ContractRec, Driver, DelCharge)
                                ELSE
                                    IF (EntryType = EntryType::Delivery) AND (DODocNo <> '') THEN
                                        TBACU.InsertDeliveryLineToDO(AdjQty, DODocNo, ContractRec, Driver);
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
        delCharge: Code[50];
        myInt: Integer;
        EntryNo: Integer;
        DODocNo: Code[20];
        ContractRec: Record "TBA Ledger Entry";
        QtyRem: Decimal;
        QtyRemCSLRec: Record "TBA Ledger Entry";
        SetEditable: Boolean;
        CustRec: Record Customer;
        ItemRec: Record item;
        EntryType: Option Delivery;
        AdjQty: Decimal;
        AdjDate: Date;
        lRemarks: text[100];
        TBACU: Codeunit TBA;
        Driver: Code[50];
}