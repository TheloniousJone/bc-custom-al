report 60109 "Posted WellAway Labels"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'WellAway Label';
    RDLCLayout = './Report Layouts/ReportLayout 60109 - Posted WellAway Label.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(SalesHeader; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterHeading = 'WellAway Label';


            dataitem("Sales Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(quantity = filter('<>0'));
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
                    if "Sales Line"."Quantity (Base)" <= 1 then begin
                        TempSLRec.reset;
                        TempSLRec."Description 2" := SalesHeader."Well. Basket No.";
                        TempSLRec."Document No." := "Sales Line"."Document No.";
                        TempSLRec."Line No." := LineNo;
                        TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                        TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                        TempSLRec.Quantity := "Sales Line".Quantity;
                        TempSLRec.Description := "Sales Line".Description;
                        TempSLRec.Insert(false);
                    end else begin
                        if "Sales Line"."Quantity (Base)" div 1 > 0 then begin
                            myInt := Round("Sales Line"."Quantity (Base)", 1, '>');
                            for CurrLoop := 1 to myint do begin
                                if CurrLoop <> myInt then begin
                                    TempSLRec.reset;
                                    TempSLRec."Description 2" := SalesHeader."Well. Basket No.";
                                    TempSLRec."Document No." := "Sales Line"."Document No.";
                                    TempSLRec."Line No." := LineNo;
                                    TempSLRec."Presc. Desc" := "Sales Line"."Presc. Desc";
                                    TempSLRec."Presc. Desc 2" := "Sales Line"."Presc. Desc 2";
                                    TempSLRec.Quantity := Round(getconv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", 1), 1, '=');
                                    TempSLRec."Quantity (Base)" := CurrLoop;
                                    TempSLRec.Description := "Sales Line".Description;
                                    TempSLRec.Insert(false);
                                    LineNo += 10000;
                                    RunQty := RunQty + getconv("Sales Line"."No.", "Sales Line"."Unit of Measure Code", 1);
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
                                    TempSLRec.Description := "Sales Line".Description;
                                    TempSLRec.Insert(false);
                                    LineNo += 10000;
                                end;

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
            }

            dataitem(TempSLRec2; integer)
            {
                column(Description; TempSLRec.Description)
                {

                }
                column(Basket; tempslRec."Description 2")
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
                column(Qty; TempSLRec.Quantity)
                {

                }
                column(No_; SalesHeader."No.") { }
                column(Posting_Date; SalesHeader."Posting Date") { }
                column(PatientName; SalesHeader."Patient Name") { }
                column(PatientNRIC; PatientNRIC) { }
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
                PatientRec.Reset();
                Clear(PatientName);
                Clear(PatientNRIC);
                IF SalesHeader."Patient No." <> ' ' then begin
                    PatientRec.SetRange("No.", SalesHeader."Patient No.");
                    if PatientRec.FindFirst() then begin
                        PatientName := PatientRec.Name;
                        //PatientNRIC := PatientRec.NRIC;
                        if strlen(SalesHeader.NRIC) > 8 then
                            PatientNRIC := '*****' + CopyStr(SalesHeader.NRIC, StrLen(SalesHeader.NRIC) - 3, StrLen(SalesHeader.NRIC))
                        else
                            PatientNRIC := SalesHeader.NRIC;
                        //PatientNRIC := '*****' + CopyStr(SalesHeader.NRIC, StrLen(PatientRec.NRIC) - 3, StrLen(PatientRec.NRIC));
                    end;
                end;

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

    var
        Expiry: Date;
        BatchNo: Code[25];
        PatientNRIC: Code[15];
        PatientName: Text[100];
        SHrec: Record "Sales Header";
        SLrec: Record "Sales Line";
        PatientRec: Record Patient;
        Rerec: Record "Reservation Entry";
        TempSLRec: Record "Sales Line" temporary;
        LineNo: Integer;
        LoopQty: Decimal;
        CurrLoop: Decimal;
}
