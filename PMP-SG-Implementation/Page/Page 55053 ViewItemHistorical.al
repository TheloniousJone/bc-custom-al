page 55053 ViewItemHistorical
{

    Caption = 'View Item Historical';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field';
                    ApplicationArea = All;
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                    ToolTip = 'Specifies the value of the Sales Amount (Actual) field';
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ToolTip = 'Specifies the value of the Cost Amount (Actual) field';
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        StartDate: Date;
        EndDate: date;

    procedure LoadData(ItemNo: Code[20]; CustNo: code[20])
    var
        myInt: Integer;
        HistRec: Record "Historical Item Sales";
        ILErec: Record "Item Ledger Entry";
    begin
        myInt := 1;
        EndDate := today;
        StartDate := CalcDate('<-1Y>', Today);
        HistRec.reset;
        HistRec.SetRange("Source No.", CustNo);
        HistRec.SetRange("Item No.", ItemNo);
        HistRec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        if HistRec.FindSet() then
            repeat
                rec.Reset();
                Rec.Init();
                Rec."Entry No." := myInt;
                Rec."Document No." := HistRec."Document No.";
                Rec."Item No." := HistRec."Item No.";
                Rec.Quantity := HistRec.Quantity;
                rec."Lot No." := HistRec."Lot No.";
                rec."Expiration Date" := HistRec."Expiration Date";
                //if HistRec."Entry Type" = HistRec."Entry Type"::"Sales Shipment" then
                //    Rec."Document Type" := Rec."Document Type"::"Sales Shipment";
                Rec."Sales Amount (Actual)" := HistRec."Sales Amount";
                rec."Cost Amount (Actual)" := HistRec."Cost Amount";
                Rec.Insert(TRUE);
                myInt += 1;
            //Rec."Unit of Measure Code" := HistRec.                
            until HistRec.next = 0;

        ILErec.reset;
        ILErec.SetRange("Source Type", ILErec."Source Type"::Customer);
        ILErec.SetRange("Source No.", CustNo);
        ILErec.SetRange("Item No.", ItemNo);
        ILErec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        if ILErec.FindSet() then
            repeat
                Rec.reset;
                rec.Init();
                Rec."Entry No." := myInt;
                Rec."Document No." := ILErec."Document No.";
                Rec."Item No." := ILErec."Item No.";
                Rec.Quantity := ILErec.Quantity;
                rec."Lot No." := ILErec."Lot No.";
                rec."Expiration Date" := ILErec."Expiration Date";
                if ILErec."Entry Type" = ILErec."Document Type"::"Sales Shipment" then
                    Rec."Document Type" := Rec."Document Type"::"Sales Shipment";
                Rec."Sales Amount (Actual)" := ILErec."Sales Amount (Actual)";
                rec."Cost Amount (Actual)" := ILErec."Cost Amount (Actual)";
                Rec.Insert(TRUE);
                myInt += 1;
            until ILErec.Next() = 0;


        /*
              IF Rec."No." = '' THEN
                                ERROR('Please enter Item Number First');
                            IF (Rec.Type <> Rec.Type::Item) AND (Rec."No." <> '') THEN
                                ERROR('Please make sure Sales Line Type is Item and Item No. is filled in before clicking on this');
                            CLEAR(ILEPage);
                            ILEFilter.RESET;
                            // Filter by item transactions only
                            ILEFilter.SETFILTER("Entry Type", FORMAT(ILEFilter."Entry Type"::Sale));
                            ILEFilter.SETFILTER("Item No.", Rec."No.");
                            ILEFilter.setrange("Source Type", ILEFilter."Source Type"::Customer);
                            ILEFilter.SetRange("Source No.", Rec."Sell-to Customer No.");

                            ILEPage.LOOKUPMODE := false;
                            ILEPage.SetTableView(ILEFilter);
                            ILEPage.CAPTION := 'Item Transactions';
                            if ILEPage.RunModal() = Action::OK then begin

                            end;
        */
    end;
}
