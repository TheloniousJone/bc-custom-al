page 55062 "Whse PW Act Line Card"
{
    // PageType = Card;
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Warehouse Activity Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(Summary)
            {
                Editable = false;

                // itemno, description, lot, expiry
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Warehouse Putaway No.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }

                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }

                field(CurrentBinQtyBase; CurrentBinQtyBase)
                {
                    Caption = 'Current Bin Qty (Base)';
                    ApplicationArea = All;
                }

            }
            group("Pick Entry")
            {
                Editable = true;
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }

                field(QtyPutaway; QtyPutaway)
                {
                    Caption = 'Qty Putaway';
                    Editable = true;
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        // action
    }


    trigger OnInit()
    begin
        HasConfirmedPutaway := false;
        QtyPutaway := 0;
        CurrentBinQtyBase := 0;
    end;

    trigger OnOpenPage()
    begin
        HasConfirmedPutaway := false;
        QtyPutaway := 0;
        CurrentBinQtyBase := 0;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // QtyPutaway := Rec."Qty. to Handle"; // set default putaway qty
        QtyPutaway := Rec.Quantity;
        CurrentBinQtyBase := GetCurrentBinQtyBase();
    end;

    trigger OnAfterGetRecord()
    begin
        // QtyPutaway := Rec."Qty. to Handle"; // set default putaway qty
        QtyPutaway := Rec.Quantity;
        CurrentBinQtyBase := GetCurrentBinQtyBase();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        HasConfirmedPutaway := false;

        if Confirm('Confirm this Putaway?', false) then
            HasConfirmedPutaway := true;

        exit(true);
    end;

    procedure GetConfirmedPutawayFlag(): Boolean
    begin
        exit(HasConfirmedPutaway);
    end;

    procedure GetQtyPutaway(): Decimal
    begin
        exit(QtyPutaway);
    end;

    procedure GetRecordLineNo(): Integer
    begin
        exit(Rec."Line No.");
    end;

    local procedure GetCurrentBinQtyBase(): Decimal
    var
        BinContentRec: Record "Bin Content";
        QtyCounter: Decimal;
    begin
        QtyCounter := 0;

        BinContentRec.Reset;
        BinContentRec.SetRange("Location Code", Rec."Location Code");
        BinContentRec.SetRange("Bin Code", Rec."Bin Code");
        BinContentRec.SetRange("Item No.", Rec."Item No.");
        // BinContentRec.SetRange("Zone Code", 'PICK');
        // BinContentRec.SetRange("Bin Type Code", 'PICK');
        if BinContentRec.FindSet() then
            repeat
                BinContentRec.CalcFields("Quantity (Base)");
                QtyCounter := QtyCounter + BinContentRec."Quantity (Base)";
            // Message(Format(QtyCounter)); // debug
            until BinContentRec.Next() = 0;

        exit(QtyCounter);
    end;

    var
        HasConfirmedPutaway: Boolean;
        QtyPutaway: Decimal;
        CurrentBinQtyBase: Decimal;
}