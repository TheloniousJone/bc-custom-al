page 55086 CheckItemPick
{

    ApplicationArea = All;
    Caption = 'Check Item Picking Transaction';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        /*
          Rec."Entry No." := EntryNo;
                                    rec."Item No." := RegWHLine."Item No.";
                                    Rec.Description := RegWHLine.Description;
                                    rec.Quantity := RegWHLine.Quantity;
                                    rec."Lot No." := RegWHLine."Lot No.";
                                    rec."Document No." := RegWHLine."Whse. Activity No.";
                                    rec."External Document No." := 'Registered';
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWHLine."Whse. Activity No.");
                                    if ALERec.FindFirst() then begin
                                        rec."Item Reference No." := ALERec.Picker;
                                        Rec."Serial No." := ALERec.Basket;
                                        rec."Package No." := ALERec."2nd Basket Code";*/
        area(content)
        {
            repeater(General)
            {
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'WH Picking No.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = all;
                    Caption = 'Trip No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field(ItemDesc; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = all;
                    Caption = 'Picker';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = all;
                    Caption = 'Basket';
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = all;
                    Caption = 'Cold Basket';
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
        EndDate: Date;
    begin

        EntryNo := 1;
        if PLCheck.RunModal() = Action::OK then begin
            // 5. Get Feedback
            // HasConfirmedPicking := WhsePickItemCard.GetConfirmedPickingFlag(); // YF 22 Sept 2021 Hard coded override           
            SelDate := PLCheck.ReturnDate();
            EndDate := PLCheck.GetEndDate();
            Selitem := PLCheck.GetItem();
            ProgressWindow.OPEN('Processing #1#################### PL for item #2#####################');
            ProgressWindow.UPDATE(1, 'unregistered');
            ProgressWindow.Update(2, Selitem);

            WHLine.reset;
            WHLine.SetFilter("Starting Date", '%1..%2', SelDate, EndDate);
            WHLine.SetRange("Item No.", Selitem);
            WHLine.SetRange("Source Document", WHLine."Source Document"::"Sales Order");
            WHLine.SetRange("Activity Type", WHLine."Activity Type"::Pick);
            WHLine.SetRange("Action Type", WHLine."Action Type"::Take);
            if WHLine.FindSet() then
                repeat
                    TSORec.reset;
                    TSORec.SetRange("No.", WHLine."No.");
                    if not (TSORec.FindFirst()) then begin
                        TSORec2.reset;
                        TSORec2."No." := WHLine."No.";
                        TSORec2.Insert(FALSE);
                        TSORec.copy(TSORec2);
                        TSORec.Insert(FALSE);
                    end;

                    if TSORec2.FindSet() then
                        repeat
                            WHLine.reset;
                            WHLine.SetFilter("Starting Date", '%1..%2', SelDate, EndDate);
                            WHLine.SetRange("No.", TSORec2."No.");
                            WHLine.SetRange("Source Document", WHLine."Source Document"::"Sales Order");
                            WHLine.SetRange("Activity Type", WHLine."Activity Type"::Pick);
                            WHLine.SetRange("Action Type", WHLine."Action Type"::Take);
                            if WHLine.FindSet() then
                                repeat
                                    Rec."Entry No." := EntryNo;
                                    rec."Item No." := WHLine."Item No.";
                                    Rec.Description := WHLine.Description;
                                    rec.Quantity := WHLine.Quantity;
                                    rec."Lot No." := WHLine."Lot No.";
                                    rec."Document No." := WHLine."No.";
                                    rec."External Document No." := 'Unregistered';
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", WHLine."No.");
                                    if ALERec.FindFirst() then begin
                                        rec."Item Reference No." := ALERec.Picker;
                                        Rec."Serial No." := ALERec.Basket;
                                        rec."Package No." := ALERec."2nd Basket Code";
                                        Rec."Job Task No." := ALERec."Trip Doc No.";
                                    end;
                                    rec.insert(false);
                                    EntryNo += 1;
                                until WHLine.next = 0;
                        until tsorec2.next = 0;
                until WHLine.next = 0;

            ProgressWindow.OPEN('Processing #1#################### PL for item #2#####################');
            ProgressWindow.UPDATE(1, 'registered');
            ProgressWindow.Update(2, Selitem);

            if TSORec.IsTemporary then
                TSORec.DeleteAll(false);
            if TSORec2.IsTemporary then
                TSORec.DeleteAll(false);
            RegWHLine.reset;
            //RegWHLine.SetRange("Starting Date", SelDate);
            RegWHLine.SetRange("Item No.", Selitem);
            RegWHLine.SetRange("Source Document", RegWHLine."Source Document"::"Sales Order");
            RegWHLine.SetRange("Activity Type", RegWHLine."Activity Type"::Pick);
            RegWHLine.SetRange("Action Type", RegWHLine."Action Type"::Take);
            if RegWHLine.FindSet() then
                repeat
                    RegWHHdr.reset;
                    RegWHHdr.SetRange("No.", RegWHLine."No.");
                    RegWHHdr.SetFilter("Registering Date", '%1..%2', SelDate, EndDate);
                    if RegWHHdr.FindFirst() then begin
                        TSORec.reset;
                        TSORec.SetRange("No.", RegWHLine."Source No.");
                        if not (TSORec.FindFirst()) then begin
                            TSORec2.reset;
                            TSORec2."No." := RegWHLine."Source No.";
                            TSORec2.Insert(FALSE);
                            TSORec.copy(TSORec2);
                            TSORec.Insert(FALSE);
                        end;

                        if TSORec2.FindSet() then
                            repeat
                                RegWHLine2.reset;
                                RegWHLine2.SetRange("Source No.", TSORec2."No.");
                                RegWHLine2.SetRange("Source Document", RegWHLine2."Source Document"::"Sales Order");
                                RegWHLine2.SetRange("Activity Type", RegWHLine2."Activity Type"::Pick);
                                RegWHLine2.SetRange("Action Type", RegWHLine2."Action Type"::Take);
                                if RegWHLine2.FindSet() then
                                    repeat
                                        Rec."Entry No." := EntryNo;
                                        rec."Item No." := RegWHLine2."Item No.";
                                        Rec.Description := RegWHLine2.Description;
                                        rec.Quantity := RegWHLine2.Quantity;
                                        rec."Lot No." := RegWHLine2."Lot No.";
                                        RegWHHdr.reset;
                                        RegWHHdr.SetRange("No.", RegWHLine2."No.");
                                        if RegWHHdr.FindFirst() then begin
                                            ALERec.reset;
                                            ALERec.SetRange("Picking Doc No.", RegWHHdr."Whse. Activity No.");
                                            if ALERec.FindFirst() then begin
                                                rec."Item Reference No." := ALERec.Picker;
                                                Rec."Serial No." := ALERec.Basket;
                                                rec."Package No." := ALERec."2nd Basket Code";
                                                Rec."Job Task No." := ALERec."Trip Doc No.";
                                            end;
                                        end;
                                        rec."Document No." := RegWHHdr."Whse. Activity No.";
                                        rec."External Document No." := 'Registered';

                                        rec.insert(false);
                                        EntryNo += 1;
                                    until RegWHLine2.next = 0;
                            until tsorec2.next = 0;
                    end;
                until WHLine.next = 0;
            ProgressWindow.CLOSE;
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

