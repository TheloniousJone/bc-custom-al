report 60108 "WellAway Labels"
{
    //DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'WellAway Label';
    //RDLCLayout = './Report Layouts/ReportLayout 60108 - WellAway Label.rdl';
    PreviewMode = PrintLayout;
    DefaultRenderingLayout = "WellAway Labels";

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterHeading = 'WellAway Label';


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = salesheader;
                RequestFilterFields = "Line No.", "No.";
                trigger OnPreDataItem()
                var

                begin
                    LineNo := 10000;
                    CurrLoop := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    RunQty: Decimal;
                begin
                    IF ("No." IN ['CHARGES', 'DISPFEE', 'SERVFEE']) THEN
                        CurrReport.SKIP;

                    if "Sales Line"."Quantity (Base)" <= 1 then begin
                        TempSLRec.reset;
                        TempSLRec."Description 2" := SalesHeader."Well. Basket No.";
                        TempSLRec."Document No." := "Sales Line"."Document No.";
                        TempSLRec."Line No." := LineNo;
                        TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                        TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                        TempSLRec.Quantity := "Sales Line".Quantity;
                        TempSLRec."Unit of Measure Code" := "Sales Line"."Unit of Measure Code";
                        TempSLRec.Description := GetUOMDesc("Sales Line"."No.", "Sales Line"."Unit of Measure Code");
                        TempSLRec."I9G Remarks" := GetShelfNo("Sales Line"."No.");
                        TempSLRec.Insert(false);
                        LineNo += 10000;
                    end else begin

                        myInt := Round("Sales Line"."Quantity (Base)", 1, '>');
                        for CurrLoop := 1 to myint do begin
                            if CurrLoop <> myInt then begin
                                TempSLRec.reset;
                                TempSLRec."Description 2" := SalesHeader."Well. Basket No.";
                                TempSLRec."Document No." := "Sales Line"."Document No.";
                                TempSLRec."Line No." := LineNo;
                                TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                                TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                                TempSLRec.Quantity := getconv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", 1);
                                TempSLRec."Quantity (Base)" := CurrLoop;
                                TempSLRec."Unit of Measure Code" := "Sales Line"."Unit of Measure Code";
                                TempSLRec.Description := GetUOMDesc("Sales Line"."No.", "Sales Line"."Unit of Measure Code");
                                TempSLRec."I9G Remarks" := GetShelfNo("Sales Line"."No.");
                                LineNo += 10000;
                                RunQty := RunQty + getconv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", 1);
                                if TempSLRec.Quantity <> 0 then
                                    TempSLRec.Insert(false);
                            end else begin
                                TempSLRec.reset;
                                TempSLRec."Description 2" := SalesHeader."Well. Basket No.";
                                TempSLRec."Document No." := "Sales Line"."Document No.";
                                TempSLRec."Line No." := LineNo;
                                TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                                TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                                //TempSLRec.Quantity := getconv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", 1);
                                TempSLRec.Quantity := "Sales Line".Quantity - RunQty;
                                TempSLRec."Quantity (Base)" := CurrLoop;
                                TempSLRec."Unit of Measure Code" := "Sales Line"."Unit of Measure Code";
                                TempSLRec.Description := GetUOMDesc("Sales Line"."No.", "Sales Line"."Unit of Measure Code");
                                TempSLRec."I9G Remarks" := GetShelfNo("Sales Line"."No.");
                                TempSLRec.Insert(false);
                                LineNo += 10000;
                            end;

                            /*
                            TempSLRec.reset;
                            TempSLRec."Document No." := "Sales Line"."Document No.";
                            TempSLRec."Line No." := LineNo;
                            TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                            TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                            TempSLRec.Quantity := GetConv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", ("Sales Line"."Quantity (Base)" mod myInt));
                            TempSLRec."Quantity (Base)" := "Sales Line"."Quantity (Base)" mod myInt;
                            TempSLRec.Description := "Sales Line".Description;
                            TempSLRec.Insert(false);
                            LineNo += 10000;
                            */
                        end;

                    end;


                end;


                /*
                column(Description; Description) { }
                column(Presc__Desc; "Presc. Desc") { }
                column(Presc__Desc_2; "Presc. Desc 2") { }
*/
                /*
                                dataitem("Reservation Entry"; "Reservation Entry")
                                {
                                    DataItemLink = "Source ID" = Field("Document No."), "Item No." = FIELD("No."), "Source Ref. No." = FIELD("Line No."), "Location Code" = field("Location Code");
                                    DataItemLinkReference = "Sales Line";
                                    DataItemTableView = where("Item Tracking" = filter('Lot No.'), "Source Type" = const(37), "Source Subtype" = Const(1));
                                    column(Expiration_Date; FORMAT(Expiry))
                                    {

                                    }
                                    column(Lot_No_; "Reservation Entry"."Lot No.")
                                    {

                                    }
                                    column(Quantity; ABS("Reservation Entry".Quantity))
                                    {

                                    }
                                    column(UOM; "Sales Line"."Unit of Measure Code")
                                    {

                                    }
                                    trigger OnAfterGetRecord()
                                    var
                                        myInt: Integer;
                                        ILERec: Record "Item Ledger Entry";
                                    begin
                                        ILERec.reset;
                                        ILERec.SetRange("Lot No.", "Reservation Entry"."Lot No.");
                                        ILERec.SetRange("Item No.", "Reservation Entry"."Item No.");
                                        if ILERec.FindFirst() then
                                            Expiry := ILERec."Expiration Date";
                                    end;

                                }
                */
                /*
                                trigger OnAfterGetRecord()
                                var
                                    ILERec: Record "Item Ledger Entry";
                                begin
                                    clear(BatchNo);
                                    Clear(Expiry);
                                    Rerec.reset;
                                    Rerec.SetRange("Source ID", "Sales Line"."Document No.");
                                    Rerec.SetRange("Item Tracking", Rerec."Item Tracking"::"Lot No.");
                                    Rerec.SetRange("Item No.", "Sales Line"."No.");
                                    Rerec.SetRange("Source Ref. No.", "Sales Line"."Line No.");
                                    //Rerec.SetRange("Source Ref. No.", "Sales Line"."Line No.");
                                    if Rerec.findfirst then begin

                                        BatchNo := Rerec."Lot No.";
                                        Expiry := Rerec."Expiration Date";
                                        if BatchNo = '' then begin
                                        end;
                                    end;
                                end
                                */

            }
            dataitem(TempSLRec2; integer)
            {
                column(Description; TempSLRec.Description)
                {

                }
                column(Basket; TempSLRec."Description 2")
                {

                }
                column(PresDesc; TempSLRec."Presc. Desc")
                {

                }
                column(PresDesc2; TempSLRec."Presc. Desc 2")
                {

                }
                column(LoopCount; TempSLRec."Line No.")
                {

                }
                column(Qty; round(TempSLRec.Quantity, 1, '='))
                {

                }
                column(UOM; TempSLRec."Unit of Measure Code")
                {
                }
                column(No_; SalesHeader."No.") { }
                column(ExternalDocNo_; SalesHeader."External Document No.") { }
                column(Posting_Date; SalesHeader."Posting Date") { }
                column(Order_Date; SalesHeader."Order Date") { }
                column(PatientName; SalesHeader."Patient Name") { }
                column(PatientNRIC; PatientNRIC) { }
                column(ShelfNo; TempSLRec."I9G Remarks") { }
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    SetRange(Number, 1, TempSLRec.count);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF Number = 1 THEN
                        TempSLRec.FINDFIRST
                    ELSE
                        TempSLRec.NEXT;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if strlen(SalesHeader.NRIC) > 8 then
                    PatientNRIC := '*****' + CopyStr(SalesHeader.NRIC, StrLen(SalesHeader.NRIC) - 3, StrLen(SalesHeader.NRIC))
                else
                    PatientNRIC := SalesHeader.NRIC;
                /*
                IF SalesHeader."Patient No." <> ' ' then begin
                    PatientRec.SetRange("No.", SalesHeader."Patient No.");
                    if PatientRec.FindFirst() then begin
                        PatientName := PatientRec.Name;
                        PatientNRIC := PatientRec.NRIC;
                    end;
                end;
*/
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    rendering
    {
        layout("WellAway Labels")
        {
            Type = RDLC;
            LayoutFile = './Report Layouts/ReportLayout 60108 - WellAway Label.rdl';
        }
        layout("WellAway Labels V2")
        {
            Type = RDLC;
            LayoutFile = './Report Layouts/ReportLayout 60108 - WellAway Label V2.rdl';
        }
    }

    local procedure GetUOMDesc(ItemNO: Code[20]; UOMCode: Code[20]): Text[100]
    var
        myInt: Integer;
        ItemUOM: Record "Item Unit of Measure";
        ItemRec: Record item;
    begin
        ItemUOM.reset;
        ItemUOM.SetRange("Item No.", ItemNO);
        ItemUOM.SetRange(Code, UOMCode);
        if ItemUOM.FindFirst() then begin
            if ItemUOM."Alternate Description" <> '' then
                exit(ItemUOM."Alternate Description")
            else begin
                ItemRec.reset;
                ItemRec.SetRange("No.", ItemNO);
                if ItemRec.FindFirst() then
                    exit(ItemRec.Description);
            end;
        end;
    end;

    local procedure GetConv(ItemNo: Code[20]; UOMCode: Code[20]; QtyBase: Decimal): Decimal
    var
        myInt: Integer;
        itemUom: Record "Item Unit of Measure";
    begin
        itemUom.reset;
        itemUom.SetRange("Item No.", ItemNo);
        itemUom.SetRange(Code, UOMCode);
        if itemUom.FindFirst() then begin
            if itemUom."Qty. per Unit of Measure" <> 0 then begin
                exit(QtyBase / itemUom."Qty. per Unit of Measure");
            end;
        end;
    end;

    local procedure GetShelfNo(ItemNO: Code[20]): Text[100]
    var
        myInt: Integer;
        ItemUOM: Record "Item Unit of Measure";
        ItemRec: Record item;
    begin

        ItemRec.reset;
        ItemRec.SetRange("No.", ItemNO);
        if ItemRec.FindFirst() then
            exit(ItemRec."Shelf No.");

    end;

    var
        Expiry: Date;
        BatchNo: Code[25];
        PatientNRIC: Code[15];
        PatientName: Text[100];
        SHrec: Record "Sales Header";
        SLrec: Record "Sales Line";
        TempSLRec: Record "Sales Line" temporary;
        PatientRec: Record Patient;
        Rerec: Record "Reservation Entry";
        LineNo: Integer;
        LoopQty: Decimal;
        CurrLoop: Decimal;
    //TempReRec: Record "Reservation Entry" temporary;

}
