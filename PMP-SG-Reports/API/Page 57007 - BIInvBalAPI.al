page 57007 BIInvBalAPI
{

    SourceTableTemporary = true;

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BIInvBalAPI';
    DelayedInsert = true;
    EntityName = 'BIInvBalAPI';
    EntitySetName = 'BIInvBalAPI';
    PageType = API;
    SourceTable = "Item Ledger Entry";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DISTRIBUTORID; VendorNo)
                {
                    ApplicationArea = all;
                }
                field(WAREHOUSEID; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field(LOCATIONID; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(AXPRODUCTID; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("DATE_ASOF"; DateFilterText)
                {
                    ApplicationArea = all;
                }
                field(BATCHID; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }
                field(EXPDATE; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field(UNITID; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field(QTY; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("VALUE"; '')
                {
                    ApplicationArea = all;
                }
                field("RESERVEDQTY"; '')            //***
                {
                    ApplicationArea = all;
                }
                field(OPENSO_QTY; SOQty)
                {
                    ApplicationArea = all;
                }
                field(OPENPO_QTY; POQty)
                {
                    ApplicationArea = all;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;

    begin
        DateFilterText := Rec.GetFilter("Posting Date"); //RL 14 Dec 2021 change from Document date to posting date
        if DateFilterText <> '' then begin
            Evaluate(DateFilterValue, DateFilterText);
            SetPageData(DateFilterValue); //Call to the custom function to fill the temp table
        end else
            SetPageData(0D);
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ItemRec: Record item;
    begin

        Rec.Quantity := CalcBackDateQty(DateFilterValue, Rec."Item No.");
        rec.Modify(FALse);

    end;

    local procedure CalcBackDateQty(DateFil: Date; ItemCode: Code[20]): Decimal
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        myDec: Decimal;
    begin
        ILERec.reset;
        ILERec.SetLoadFields(Quantity);
        ILERec.SetRange("Item No.", ItemCode);
        if DateFil <> 0D then
            ILERec.SetFilter("Posting Date", '..%1', DateFil);
        if ILERec.FindSet() then
            repeat
                myDec += ILERec.Quantity;
            until ILERec.next = 0;
        exit(myDec);
    end;

    Procedure SetPageData(Datefil: Date)
    Var
        nextRowno: Integer;
        Myquery: query "Lot Numbers by Bin Custom";
        ILERec: Record "Item Ledger Entry";
        CompInfo: Record "Company Information";
        ItemRec: Record item;
    Begin

        CompInfo.reset;
        CompInfo.get;
        ItemRec.reset;
        if ItemRec.FindSet() then
            repeat
                NextRowNo := NextRowNo + 1;
                Rec."Entry No." := NextRowNo;
                Rec."Item No." := ItemRec."No.";
                Rec.Description := ItemRec.Description;
                Rec."External Document No." := '';
                Rec."Expiration Date" := 0D;
                Rec."Lot No." := '';
                Rec."Location Code" := '';
                Rec.Quantity := 0;
                Rec."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                Rec.Insert(FALSE);
            until ItemRec.next = 0;


        /*
        while MyQuery.Read() do begin
            NextRowNo := NextRowNo + 1;
            Rec."Entry No." := NextRowNo;
            Rec."Item No." := Myquery.Item_No;
            Rec.Description := Myquery.Description;
            Rec."External Document No." := Myquery.Bin_Code;
            Rec."Expiration Date" := Myquery.Expiration_Date;
            Rec."Lot No." := Myquery.Lot_No;
            Rec."Location Code" := Myquery.Location_Code;
            Rec.Quantity := Myquery.Sum_Qty_Base;
            Rec."Unit of Measure Code" := Myquery.Unit_of_Measure_Code;
            Rec.Insert(FALSE);
        End;
        */

    end;

    var
        VendorNo: Code[50];
        POQty: Decimal;
        SOQty: Decimal;
        DateFilterText: Text;
        DateFilterValue: date;
}



