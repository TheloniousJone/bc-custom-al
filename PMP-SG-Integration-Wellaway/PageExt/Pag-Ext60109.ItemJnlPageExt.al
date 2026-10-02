pageextension 60109 ItemJnlPage2Ext extends "Item Journal"
{
    layout
    {
        addafter("Item No.")
        {
            field(Checked; Rec.Checked)
            {
                ApplicationArea = all;
            }
            field(BatchNo; BatchNo)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Lot No.';
            }
            field(ExprDate; ExprDate)
            {
                ApplicationArea = all;
                Caption = 'Expiration Date';
                Editable = false;
            }
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                BatchNo := '';
                ExprDate := 0D;
                if Rec."Item No." <> xRec."Item No." then begin
                    BatchNo := WellCU.GetFirstBatch(Rec);
                    ExprDate := WellCU.GetFirstExprDate(Rec);
                end;
            end;
        }
    }

    actions
    {
        addafter("&Line")
        {
            action("Create TO")
            {
                ApplicationArea = all;
                Promoted = true;
                Visible = false;
                Image = Create;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    WellCU: Codeunit "Wellaway CU";
                    TORec: Record "Transfer Header";
                begin
                    TORec.reset;
                    TORec.ChangeCompany(WellCU.GetPMPCompanyName());
                    torec.SetRange("No.", Rec."Document No.");
                    if torec.FindFirst() then begin
                        Message(TORec."No.");
                    end;
                    if Rec.FindSet() then
                        repeat
                            WellCU.CreateTOLineByItemCode(Rec."Item No.", Rec."Quantity (Base)", TORec);
                        until Rec.next = 0;
                end;
            }
        }


    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //if Rec."Item No." <> xRec."Item No." then begin
        BatchNo := WellCU.GetFirstBatch(Rec);
        ExprDate := WellCU.GetFirstExprDate(Rec);
        //end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        //if Rec."Item No." <> xRec."Item No." then begin
        BatchNo := WellCU.GetFirstBatch(Rec);
        ExprDate := WellCU.GetFirstExprDate(Rec);
        //end;
    end;

    var
        ExprDate: Date;
        BatchNo: Code[50];
        WellCU: Codeunit "Wellaway CU";
}

