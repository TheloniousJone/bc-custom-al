page 55033 "Whse Act Line Card"
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
                    Caption = 'Warehouse Pick No.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                // field(MinShelf; VarMinShelf)
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Style = Favorable;
                // }

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

                field(QtyPicked; QtyPicked)
                {
                    Caption = 'Qty Picked';
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
        HasConfirmedPicking := false;
        QtyPicked := 0;
        CurrentBinQtyBase := 0;
    end;

    trigger OnOpenPage()
    begin
        HasConfirmedPicking := false;
        QtyPicked := 0;
        CurrentBinQtyBase := 0;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // QtyPicked := Rec."Qty. to Handle"; // set default pick qty
        QtyPicked := Rec."CS Pick Qty";
        CurrentBinQtyBase := GetCurrentBinQtyBase();
    end;

    trigger OnAfterGetRecord()
    begin
        // QtyPicked := Rec."Qty. to Handle"; // set default pick qty
        QtyPicked := Rec."CS Pick Qty";
        CurrentBinQtyBase := GetCurrentBinQtyBase();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //        HasConfirmedPicking := false;
        //DX           17 Sept 2021
        //        if Confirm('Confirm this Pick?', false) then
        //            HasConfirmedPicking := true;
        //DX           17 Sept 2021

        // YF 22 Sept 2021 - Not in use now but maintain status just in case
        if CloseAction = CloseAction::OK then
            HasConfirmedPicking := true;

        if CloseAction = CloseAction::Cancel then
            HasConfirmedPicking := false;
        // YF 22 Sept 2021 - Not in use now but maintain status just in case

        exit(true);
    end;

    procedure GetConfirmedPickingFlag(): Boolean
    begin
        exit(HasConfirmedPicking);
    end;

    procedure GetQtyPicked(): Decimal
    begin
        exit(QtyPicked);
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
        HasConfirmedPicking: Boolean;
        QtyPicked: Decimal;
        CurrentBinQtyBase: Decimal;
        MiniShelf: Record MinimumShelf;
}