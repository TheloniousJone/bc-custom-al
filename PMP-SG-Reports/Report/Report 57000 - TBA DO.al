report 57000 "TBA DO"
{
    ApplicationArea = All;
    Caption = 'TBA DO';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57000 - TBA DO.rdl';
    PreviewMode = PrintLayout;
    Permissions = TableData 27 = rimd, Tabledata 36 = rimd, TableData 112 = rimd;

    dataset
    {

        dataitem(TBALedgerEntry; "TBA Ledger Entry")
        {
            DataItemTableView = where("Entry Type" = const(DElivery));

            column(Picture; CompRec.Picture)
            {

            }
            column(EntryNo; "Entry No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(ItemDescription; "Item Description")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(UnitOfMeasureCode; "Unit Of Measure Code")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(ApplyToDocNo; "Apply To Doc No.")
            {
            }
            column(RemainingQty; "Remaining Qty")
            {
            }
            column(SIHRecNo; SIHRec."No.")
            {

            }
            //DX        05 Sept 2021
            column(DelZone; SIHRec."Delivery Zone")
            {

            }
            column(DelCharge; SIHRec."Delivery Charge")
            {

            }
            //DX        05 Sept 2021
            column(Batch_No_; "Batch No.")
            {

            }
            column(Expiration_Date; "Expiration Date")
            {

            }

            column(SelltoAddress; SIHRec."Sell-to Address")
            {

            }
            column(SelltoAddress2; SIHRec."Sell-to Address 2")
            {

            }
            column(CustName; SIHRec."Sell-to Customer Name")
            {

            }
            column(CustNo; SIHRec."Sell-to Customer No.")
            {

            }
            column(PostCode; SIHRec."Sell-to Country/Region Code" + SIHRec."Sell-to Post Code")
            {

            }
            dataitem(OrgDetails; Integer)
            {
                DataItemTableView = sorting(number) order(ascending);
                column(OrgItemNo; OrgCSLERec."Item No.")
                {

                }
                column(OrgPostDate; OrgCSLERec."Posting Date")
                {

                }
                column(OrgItemDesc; OrgCSLERec."Item Description")
                {

                }
                column(OrgQty; OrgCSLERec."Quantity")
                {

                }
                column(OrgUOM; OrgCSLERec."Unit Of Measure Code")
                {

                }
                column(RemQty; OrgCSLERec."Remaining Qty")
                {

                }
                column(OrgBatch; OrgCSLERec."Batch No.")
                {

                }
                column(CurrQty; CurrQty)
                {

                }
                column(OrgExprDate; FORMAT(OrgCSLERec."Expiration Date"))
                {

                }


                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    OrgCSLERec.SETCURRENTKEY("Document No.", "Entry Type");
                    SETRANGE(Number, 1, OrgCSLERec.COUNT);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF Number = 1 THEN
                        OrgCSLERec.FINDFIRST
                    ELSE
                        OrgCSLERec.NEXT;

                    CurrQty := CalcBackdateBalQty(TBALedgerEntry."Entry No.", OrgCSLERec, OrgCSLERec."Item No.");

                end;
            }
            dataitem(DODetails; Integer)
            {
                DataItemTableView = sorting(number) order(ascending);


                column(DOEntryNo; CSLEDOTemp."Entry No.")
                {

                }
                column(DOSellToCustNo; CSLEDOTemp."Customer No.")
                {

                }
                column(DODocNo; CSLEDOTemp."Document No.")
                {

                }
                column(DOItemNo; CSLEDOTemp."Item No.")
                {

                }
                column(DOEntryType; CSLEDOTemp."Entry Type")
                {

                }
                column(DOQty; CSLEDOTemp.Quantity)
                {

                }
                column(DODate; FORMAT(CSLEDOTemp."Posting Date"))
                {

                }
                column(DOUOM; CSLEDOTemp."Unit Of Measure Code")
                {

                }
                column(DORemark; CSLEDOTemp.Remarks)
                {

                }
                column(DOItemDesc; TempItemRec.Description)
                {

                }
                column(DOBatch; CSLEDOTemp."Batch No.")
                {

                }
                column(DOExprDate; format(CSLEDOTemp."Expiration Date"))
                {

                }
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    CSLEDOTemp.SETCURRENTKEY("Document No.", "Entry Type");
                    SETRANGE(Number, 1, CSLEDOTemp.COUNT);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF Number = 1 THEN
                        CSLEDOTemp.FINDFIRST

                    ELSE
                        CSLEDOTemp.NEXT;

                    if CSLEDOTemp."Item No." <> '' then begin
                        TempItemRec.RESET;
                        TempItemRec.GET(CSLEDOTemp."Item No.");
                    end;

                end;
            }
            dataitem(HistDetails; Integer)
            {
                DataItemTableView = sorting(number) order(ascending);


                column(HistEntryNo; CSLETemp."Entry No.")
                {

                }
                column(HisSellToCustNo; CSLETemp."Customer No.")
                {

                }
                column(HistDocNo; CSLETemp."Document No.")
                {

                }
                column(HistItemNo; CSLETemp."Item No.")
                {

                }
                column(HistEntryType; CSLETemp."Entry Type")
                {

                }
                column(HistQty; CSLETemp.Quantity)
                {

                }
                column(HistDate; FORMAT(CSLETemp."Posting Date"))
                {

                }
                column(HistUOM; CSLETemp."Unit Of Measure Code")
                {

                }
                column(HistRemark; CSLETemp.Remarks)
                {

                }
                column(HistItemDesc; TempItemRec.Description)
                {

                }
                column(HistBatch; CSLETemp."Batch No.")
                {

                }
                column(HistExprDate; FORMAT(CSLETemp."Expiration Date"))
                {

                }
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    CSLETemp.SETCURRENTKEY("Document No.", "Entry Type");
                    SETRANGE(Number, 1, CSLETemp.COUNT);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF Number = 1 THEN
                        CSLETemp.FINDFIRST

                    ELSE
                        CSLETemp.NEXT;

                    IF CSLETemp."Item No." <> '' THEN BEGIN
                        TempItemRec.RESET;
                        TempItemRec.GET(CSLETemp."Item No.");
                    END;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                SIHRec.RESET;
                SIHRec.SETRANGE(SIHRec."No.", TBALedgerEntry."Apply To Doc No.");
                IF SIHRec.FINDFIRST THEN BEGIN END;
                PopulateOrgSalesTbl(0, TBALedgerEntry."Apply To Doc No.");
                PopulateCurrDOTbl(0, TBALedgerEntry."Document No.");
                IF NOT CheckIfFirstDO(TBALedgerEntry."Entry No.") THEN BEGIN
                    PopulateHistTbl(TBALedgerEntry."Entry No.", TBALedgerEntry."Apply To Doc No.");
                END;
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

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompRec.reset;
        CompRec.get;
        CompRec.CalcFields(Picture);
    end;

    LOCAL PROCEDURE CheckIfFirstDO(EntryNo: Integer) IsFirst: Boolean;
    VAR
        CSLERec: Record "TBA Ledger Entry";
    BEGIN
        CSLERec.RESET;
        CSLERec.SETFILTER("Entry No.", '<%1', EntryNo);
        CSLERec.SETFILTER("Entry Type", FORMAT(CSLERec."Entry Type"::Delivery));
        IF CSLERec.COUNT = 0 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    END;

    LOCAL PROCEDURE PopulateHistTbl(EntryNo: Integer; DocNo: Code[20]);
    VAR
        CSLERec: Record "TBA Ledger Entry";
        x: Integer;
    BEGIN
        CSLETemp.DELETEALL;
        CSLERec.RESET;
        CSLERec.SETFILTER("Entry No.", '<%1', EntryNo);
        CSLERec.SETFILTER("Entry Type", '<>%1', CSLERec."Entry Type"::Sale);
        //CSLERec.SETFILTER("Entry Type",'%1',CSLERec."Entry Type"::Delivery);
        CSLERec.SETFILTER("Apply To Doc No.", '%1', DocNo);
        x := 1;
        CLEAR(CSLETemp);
        IF CSLERec.FINDSET THEN
            REPEAT

                CSLETemp.RESET;
                CSLETemp.INIT;
                CSLETemp."Entry No." := CSLERec."Entry No.";
                CSLETemp."Entry Type" := CSLERec."Entry Type";
                CSLETemp."Apply To Doc No." := CSLERec."Apply To Doc No.";
                CSLETemp."Document No." := CSLERec."Document No.";
                CSLETemp."Customer No." := CSLERec."Customer No.";
                CSLETemp."Item No." := CSLERec."Item No.";
                CSLETemp.Quantity := CSLERec.Quantity;
                CSLETemp."Posting Date" := CSLERec."Posting Date";
                CSLETemp."Unit Of Measure Code" := CSLERec."Unit Of Measure Code";
                CSLETemp."Expiration Date" := CSLERec."Expiration Date";
                CSLETemp."Batch No." := CSLERec."Batch No.";
                //CSLETemp.COPY(CSLERec);
                //CSLETemp."Entry No." := x;
                CSLETemp.INSERT;
                x += 1;
            UNTIL CSLERec.NEXT = 0;
    END;

    PROCEDURE SetFilter(InputDoc: Code[20]);
    BEGIN
        DocNo := InputDoc;
    END;

    LOCAL PROCEDURE PopulateCurrDOTbl(EntryNo: Integer; DocNo: Code[20]);
    VAR
        CSLERec: Record "TBA Ledger Entry";
        x: Integer;
    BEGIN
        CSLEDOTemp.DELETEALL;
        CSLERec.RESET;
        CSLERec.SETFILTER("Document No.", '%1', DocNo);
        CLEAR(CSLEDOTemp);
        IF CSLERec.FINDSET THEN
            REPEAT
                CSLEDOTemp.RESET;
                CSLEDOTemp.INIT;
                CSLEDOTemp."Entry No." := CSLERec."Entry No.";
                CSLEDOTemp."Entry Type" := CSLERec."Entry Type";
                CSLEDOTemp."Apply To Doc No." := CSLERec."Apply To Doc No.";
                CSLEDOTemp."Document No." := CSLERec."Document No.";
                CSLEDOTemp."Customer No." := CSLERec."Customer No.";
                CSLEDOTemp."Item No." := CSLERec."Item No.";
                CSLEDOTemp.Quantity := CSLERec.Quantity;
                CSLEDOTemp."Batch No." := CSLERec."Batch No.";
                CSLEDOTemp."Expiration Date" := CSLERec."Expiration Date";
                CSLEDOTemp."Posting Date" := CSLERec."Posting Date";
                CSLEDOTemp."Unit Of Measure Code" := CSLERec."Unit Of Measure Code";
                //CSLETemp.COPY(CSLERec);
                //CSLETemp."Entry No." := x;
                CSLEDOTemp.INSERT;

            UNTIL CSLERec.NEXT = 0;
    END;

    LOCAL PROCEDURE PopulateOrgSalesTbl(EntryNo: Integer; DocNo: Code[20]);
    VAR
        CSLERec: Record "TBA Ledger Entry";
        x: Integer;
        ItemRec: Record Item;
    BEGIN
        OrgCSLERec.DELETEALL;
        CSLERec.RESET;
        CLEAR(CSLERec);
        CSLERec.SETFILTER("Document No.", '%1', DocNo);
        CSLERec.SETFILTER("Entry Type", FORMAT(CSLERec."Entry Type"::Sale));
        CLEAR(OrgCSLERec);
        IF CSLERec.FINDSET THEN
            REPEAT
                OrgCSLERec.RESET;
                OrgCSLERec.INIT;
                OrgCSLERec."Entry No." := CSLERec."Entry No.";
                OrgCSLERec."Entry Type" := CSLERec."Entry Type";
                OrgCSLERec."Apply To Doc No." := CSLERec."Apply To Doc No.";
                OrgCSLERec."Document No." := CSLERec."Document No.";
                OrgCSLERec."Customer No." := CSLERec."Customer No.";

                OrgCSLERec."Item No." := CSLERec."Item No.";

                IF CSLERec."Item No." <> '' THEN BEGIN
                    ItemRec.RESET;
                    ItemRec.GET(CSLERec."Item No.");
                END;
                OrgCSLERec."Item Description" := ItemRec.Description;
                OrgCSLERec.Quantity := CSLERec.Quantity;
                OrgCSLERec."Posting Date" := CSLERec."Posting Date";
                OrgCSLERec."Unit Of Measure Code" := CSLERec."Unit Of Measure Code";
                OrgCSLERec."Expiration Date" := CSLERec."Expiration Date";
                OrgCSLERec."Batch No." := CSLERec."Batch No.";
                //CSLETemp.COPY(CSLERec);
                //CSLETemp."Entry No." := x;
                OrgCSLERec.INSERT;

            //    MESSAGE(OrgCSLERec."Item No.");
            //    MESSAGE(ItemRec.Description);


            UNTIL CSLERec.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcBackdateBalQty(EntryNo: Integer; OrgCSLE: Record "TBA Ledger Entry" temporary; ItemNo: Code[10]) BalQty: Decimal;
    VAR
        LCSLERec: Record "TBA Ledger Entry";
        BalQtyOnHand: Decimal;
    BEGIN
        LCSLERec.RESET;
        LCSLERec.SETFILTER("Entry No.", '<=%1', GetLastDocNoEntryNo(TBALedgerEntry."Document No."));
        LCSLERec.SETFILTER("Entry Type", '<>%1', LCSLERec."Entry Type"::Sale);
        LCSLERec.SETRANGE("Apply To Doc No.", TBALedgerEntry."Apply To Doc No.");
        LCSLERec.SETRANGE("Item No.", ItemNo);
        LCSLERec.SetRange("Batch No.", OrgCSLE."Batch No."); //RL 25 Apr 2022 - additional filter for batch
        //LCSLERec.SETRANGE("Sell-To Customer No.",OrgCSLE."Sell-To Customer No.");
        IF LCSLERec.FINDSET THEN
            REPEAT
                BalQtyOnHand += LCSLERec.Quantity;
            UNTIL LCSLERec.NEXT = 0;
        BalQtyOnHand := BalQtyOnHand + OrgCSLE.Quantity;

        EXIT(BalQtyOnHand);
    END;

    LOCAL PROCEDURE GetLastDocNoEntryNo(DocNo: Text) entry: Integer;
    VAR
        LCSLRec: Record "TBA Ledger Entry";
    BEGIN
        LCSLRec.RESET;
        LCSLRec.SETRANGE("Document No.", DocNo);
        IF LCSLRec.FINDLAST THEN
            EXIT(LCSLRec."Entry No.");
    END;

    var
        SIHRec: Record "Sales Invoice Header";
        CustRec: record Customer;
        CompRec: record "Company Information";
        CSLETemp: Record "TBA Ledger Entry" temporary;
        TempItemRec: Record Item;
        CSLEDOTemp: Record "TBA Ledger Entry" temporary;
        OrgCSLERec: Record "TBA Ledger Entry" temporary;
        CurrQty: Decimal;
        DocNo: Code[20];
    //CSLETemp : record 
}
