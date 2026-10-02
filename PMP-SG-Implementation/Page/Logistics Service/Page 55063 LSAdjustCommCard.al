page 55063 LSAdjustCommCard
{

    Caption = 'LS Adjust Comm Calculation Card';
    PageType = Card;
    SourceTable = "LS Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                /*
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = all;
                    Caption = 'Select Invoice No. to adjust.';
                    TableRelation = "LS Ledger Entry"."Entry No." where(Closed = const(false));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if InvNo <> '' then begin
                            Rec.SetRange("Entry No.", EntryNo);
                            if Rec.FindFirst() then begin
                                if Rec."Calculation Method" = rec."Calculation Method"::Line then
                                    NewCalcMethod := 'Percentage'
                                else
                                    NewCalcMethod := 'Line';
                            end;
                        end;
                    end;
                }
                */
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = all;
                    Caption = 'Current Calculation Method';
                    Editable = false;
                }
                field(NewCalcMethod; NewCalcMethod)
                {
                    ApplicationArea = all;
                    Caption = 'Updated Calc. Method';
                    Editable = false;
                }

            }
        }


    }
    actions
    {
        area(Processing)
        {
            action("Update Method")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = UpdateShipment;
                trigger OnAction()
                var
                    myInt: Integer;
                    LSCU: Codeunit LS;
                begin
                    If Confirm('Are you sure you wish to update the calculation method?') then
                        LSCU.UpdateLSCalcMethod(Rec."Entry No.");
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        if Rec."Calculation Method" = rec."Calculation Method"::Line then
            NewCalcMethod := 'Percentage'
        else
            NewCalcMethod := 'Line';
    end;

    var
        InvNo: Code[20];
        EntryNo: Integer;
        NewCalcMethod: Text[50];

}
