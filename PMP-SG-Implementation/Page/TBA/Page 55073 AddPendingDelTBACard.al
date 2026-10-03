page 55073 "Add Pending Del TBA Card"
{
    PageType = Card;
    Caption = 'Add Pending Delivery';
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Sales Line";

    //SourceTable = ;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Name"; SHName)
                {
                    ApplicationArea = all;
                }
                field("Address"; SHAdd)
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit Of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
            }


            group("Pending Delivery Details")
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
                        IF (rec.Quantity - AdjQty < 0) THEN
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
                    Caption = 'Confirm Pending Delivery Line';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Process;
                    trigger OnAction()
                    var
                        TBARec: Record "TBA Ledger Entry";
                    begin
                        TBARec.reset;
                        TBARec.SetRange("Sales Order No.", Rec."Document No.");
                        TBARec.SetRange("Item No.", Rec."No.");
                        if TBARec.FindFirst() then
                            Error('TBA Pending Delivery already exists for this line, please check again.');
                        
                        IF (AdjQty <> 0) THEN BEGIN
                            if AdjQty < 0 then
                                Error('Please enter positive figures to deduct.');
                            IF DIALOG.CONFIRM('Do you want to insert a pending delivery line?') THEN BEGIN
                                TBACU.InserPendDeliveryLine(Rec, AdjQty, AdjDate, lRemarks);
                                CurrPage.Update(false);
                                CurrPage.Close();
                                ;
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

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SHAdd := '';
        SHName := '';
        if Rec."Sell-to Customer No." <> '' then begin
            SHRec.reset;
            SHRec.SetRange("No.", Rec."Document No.");
            if SHRec.FindFirst() then begin
                SHAdd := SHRec."Sell-to Address";
                SHName := SHRec."Sell-to Customer Name";
            end;
        end;
        //AdjQty := Rec.Quantity;

    end;

    var
        myInt: Integer;
        EntryNo: Integer;
        SONo: Code[20];
        DODocNo: Code[20];
        ContractRec: Record "TBA Ledger Entry";
        QtyRem: Decimal;
        QtyRemCSLRec: Record "TBA Ledger Entry";
        SetEditable: Boolean;
        CustRec: Record Customer;
        ItemRec: Record item;
        EntryType: Option "Pending Delivery";
        AdjQty: Decimal;
        AdjDate: Date;
        lRemarks: text[100];
        TBACU: Codeunit TBA;
        SHRec: Record "Sales Header";
        SHAdd: Text[100];
        SHName: text[100];
}