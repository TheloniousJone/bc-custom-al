page 55088 CheckBasketStatus
{
    //DX        05 Oct 2021
    ApplicationArea = All;
    Caption = 'Check Basket Status';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    Editable = false;
    layout
    {

        area(content)
        {
            repeater(General)
            {
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Checker/Picker';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'WH Document No.';
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = all;
                    Caption = 'Basket';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Caption = 'Date';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {

            action("Check By Item.")
            {
                Caption = 'Check By Item';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    myInt: Integer;
                    EnhaceCU: Codeunit "PMP-Enhancements";
                    PLCheck: Page PLCheck;
                begin
                    if Rec.IsTemporary then begin
                        Rec.DeleteAll(false);
                    end;
                    Loaddata(true);

                end;
            }
        }
    }


    local procedure Loaddata(ByItem: Boolean)
    var
        myInt: Integer;
        ItemList: page "Item List";
        ItemRec: Record item;
        ItemFilter: code[300];
        RecRun: integer;
        RecordCount: Integer;
        WHLine: Record "Warehouse Activity Line";
        RegWHLine: Record "Registered Whse. Activity Line";
        TripLine: Record "WH Trip Line";
        CheckLine: Record "Checking Line";
        Picker: Code[50];
        Checker: Code[50];
        PLCheck: Page PLCheck;
        ALERec: Record "Assignment Ledger Entry";
        TSORec: Record "Sales Header" temporary;
        TSORec2: Record "Sales Header" temporary;
        RegWHHdr: Record "Registered Whse. Activity Hdr.";
        RegWHLine2: Record "Registered Whse. Activity Line";
        StartDate: Date;
        EndDate: Date;
    begin

        EntryNo := 1;
        if PLCheck.RunModal() = Action::OK then begin
            // 5. Get Feedback
            // HasConfirmedPicking := WhsePickItemCard.GetConfirmedPickingFlag(); // YF 22 Sept 2021 Hard coded override           
            StartDate := PLCheck.ReturnDate();
            EndDate := PLCheck.GetEndDate();
            Selitem := PLCheck.GetBasket();
            ProgressWindow.OPEN('Processing #1####################');
            ProgressWindow.UPDATE(1, 'Basket');
            ALERec.reset;
            ALERec.SetRange(Basket);
            ALERec.SetFilter("Pick By Date", '%1..%2');
            if ALERec.FindSet() then
                repeat
                    Rec."Entry No." := EntryNo;
                    Rec."Posting Date" := ALERec."Posting Date";
                    Rec."Item Reference No." := Selitem;
                    rec.Description := format(ALERec.Status);
                    if ALERec.Status = ALERec.Status::Checking then begin
                        Rec."Document No." := ALERec."Checking Doc No.";
                        rec."External Document No." := ALERec."Checker ID";
                    end else
                        if ALERec.Status = ALERec.Status::"Pending Checking" then begin
                            Rec."Document No." := ALERec."Picking Doc No.";
                            rec."External Document No." := ALERec.Picker;
                        end else
                            if ALERec.Status = ALERec.Status::Picking then begin
                                Rec."Document No." := ALERec."Picking Doc No.";
                                rec."External Document No." := ALERec.Picker;
                                if ALERec.Status = ALERec.Status::"Pending Delivery" then begin
                                    Rec."Document No." := ALERec."Invoice No.";
                                    rec."External Document No." := ALERec."Checker ID";
                                end;
                                rec.Insert(false);
                                EntryNo += 1;
                            end;
                until ALERec.next = 0;
            ProgressWindow.Close();

        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.IsTemporary then
            Rec.DeleteAll();
    end;



    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
    begin

    end;

    var
        TempILE: Record "Item Ledger Entry" temporary;
        TempILE2: Record "Item Ledger Entry" temporary;
        ProgressWindow: Dialog;
        ILERec: Record "Item Ledger Entry";
        EntryNo: integer;
        ItemRec: Record item;
        PhysStock: Decimal;
        SOStock: Decimal;
        POStock: Decimal;
        ResStock: Decimal;
        AvailStock: Decimal;
        TotalAvail: Decimal;
        ItemDesc: Text[100];

        StyleExp: Boolean;
        SelDate: Date;
        Selitem: Code[20];
}

