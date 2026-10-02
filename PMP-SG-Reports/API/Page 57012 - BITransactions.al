page 57012 BITransactions
{

    ApplicationArea = All;
    Caption = 'BITransactionsAPI';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    UsageCategory = Lists;
    SourceTableTemporary = true;
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
                field("DATE_ASOF"; Format(DateFilterValue, 0, '<Year4>-<Month,2>-<Day,2>')) // YF 22 Dec 2021
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
                field(PostingDate; rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(VARIANTCODE; rec."Variant Code")
                {
                    ApplicationArea = all;
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
            DateFilterText := CopyStr(DateFilterText, StrLen(DateFilterText) + 1 - 8, 8); // YF 22 Dec 2021 // Hacky workaround for filtering
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
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetLoadFields("No.", "Location Filter", "Bin Filter", "Lot No. Filter", "Qty. on Sales Order", "Qty. on Purch. Order", "Vendor No.");
            //ItemRec.SetCurrentKey("No.", "Location Filter", "Bin Filter", "Lot No. Filter");
            ItemRec.SetRange("No.", Rec."Item No.");
            ItemRec.SetFilter("Location Filter", Rec."Location Code");
            ItemRec.SetFilter("Bin Filter", Rec."External Document No.");
            ItemRec.SetFilter("Lot No. Filter", '%1', Rec."Lot No.");
            ItemRec.CalcFields(ItemRec."Qty. on Sales Order", ItemRec."Qty. on Purch. Order");
            if ItemRec.FindFirst() then begin
                VendorNo := ItemRec."Vendor No.";
                //SOQty := ItemRec."Qty. on Sales Order";
                //POQty := ItemRec."Qty. on Purch. Order";
            end;

        end;

    end;

    Procedure SetPageData(Datefil: Date)
    Var
        nextRowno: Integer;
        Myquery: query "Lot Numbers by Bin Custom";
        ILERec: Record "Item Ledger Entry";
    Begin
        /*

        Myquery.Open();
        while MyQuery.Read() do begin
            NextRowNo := NextRowNo + 1;
            Rec."Entry No." := NextRowNo;
            Rec."Item No." := Myquery.Item_No;
            Rec.Description := Myquery.Description;
            Rec."External Document No." := Myquery.Bin_Code;
            Rec."Expiration Date" := Myquery.Expiration_Date;
            Rec."Lot No." := format(Myquery.Lot_No);
            Rec."Location Code" := Myquery.Location_Code;
            Rec.Quantity := Myquery.Sum_Qty_Base;
            Rec."Unit of Measure Code" := Myquery.Unit_of_Measure_Code;
            Rec.Insert(FALSE);
        End;
        Myquery.Close();
        */
        ILERec.reset;
        ILERec.SetLoadFields(Quantity, "Item No.", Description, "Expiration Date", "Location Code", "Unit of Measure Code", Quantity, "Posting Date", "Variant Code"); //DX        19 May 2025
        if Datefil <> 0D then
            ILERec.SetFilter("Posting Date", '..%1', Datefil);

        if ILERec.FindSet() then
            repeat
                NextRowNo := NextRowNo + 1;
                Rec."Entry No." := NextRowNo;
                Rec."Item No." := ILERec."Item No.";
                Rec.Description := ILERec.Description;
                Rec."External Document No." := '';
                Rec."Expiration Date" := ILERec."Expiration Date";
                Rec."Lot No." := ILERec."Lot No.";
                Rec."Location Code" := ILERec."Location Code";
                Rec.Quantity := ILERec.Quantity;
                Rec."Unit of Measure Code" := ILERec."Unit of Measure Code";
                Rec."Posting Date" := ILERec."Posting Date";
                Rec."Variant Code" := ILERec."Variant Code";
                Rec.Insert(FALSE);
            until ILERec.next = 0;


    end;

    var
        VendorNo: Code[50];
        POQty: Decimal;
        SOQty: Decimal;
        DateFilterText: Text;
        DateFilterValue: date;
}



