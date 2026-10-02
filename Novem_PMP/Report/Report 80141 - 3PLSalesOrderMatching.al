report 80141 "3PLSalesOrderMatching"
{
    ApplicationArea = All;
    Caption = '3PL Sales Order Matching';
    UsageCategory = Administration;
    DefaultRenderingLayout = "3PL - Sales Order Matching";
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                myInt: Integer;

            begin

                NovEntryNo := 1;
                NovemSOrec.reset;
                NovemSOrec.ChangeCompany('Novem-NHC');
                NovemSOrec.SetCurrentKey(I9G_SOCreated, "Document Type");
                NovemSOrec.SetLoadFields(I9G_SOCreated, "No.", "Document Type");
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    NovemSOrec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate)
                else if (StartDate = 0D) and (EndDate <> 0D) then
                    NovemSOrec.SetFilter("Posting Date", '..%1', EndDate)
                else if (StartDate <> 0D) and (EndDate = 0D) then
                    NovemSOrec.SetFilter("Posting Date", '%1..', StartDate);
                NovemSOrec.SetRange("Document Type", PMPSOrec."Document Type"::Order);
                NovemSOrec.SetRange(I9G_SOCreated, true);
                if NovemSOrec.FindSet() then
                    repeat
                        NovemTempTable.reset;
                        NovemTempTable.SetRange(Code1, NovemSOrec."No.");
                        if not NovemTempTable.FindFirst() then begin
                            NovemTempTable2.init;
                            NovemTempTable2."Entry No." := NovEntryNo;
                            NovemTempTable2.Code1 := NovemSOrec."No.";
                            NovemTempTable2.Insert(false);
                            NovemTempTable.Copy(NovemTempTable2);
                            NovemTempTable.Insert(false);
                            NovEntryNo += 1;
                        end;
                    until NovemSOrec.next = 0;

                NovemSIrec.reset;
                NovemSIrec.ChangeCompany('Novem-NHC');
                NovemSIRec.SetCurrentKey(I9G_SOCreated);
                NovemSIrec.SetLoadFields(I9G_SOCreated, "No.");
                NovemSIrec.SetRange(I9G_SOCreated, true);
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    NovemSIrec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate)
                else if (StartDate = 0D) and (EndDate <> 0D) then
                    NovemSIrec.SetFilter("Posting Date", '..%1', EndDate)
                else if (StartDate <> 0D) and (EndDate = 0D) then
                    NovemSIrec.SetFilter("Posting Date", '%1..', StartDate);
                if NovemSIrec.FindSet() then
                    repeat
                        NovemTempTable.reset;
                        NovemTempTable.SetRange(Code1, NovemSIrec."Order No.");
                        if not NovemTempTable.FindFirst() then begin
                            NovemTempTable2.init;
                            NovemTempTable2."Entry No." := NovEntryNo;
                            NovemTempTable2.Code1 := NovemSIrec."Order No.";
                            NovemTempTable2.Boolean1 := false;
                            NovemTempTable2.Insert(false);
                            NovemTempTable.Copy(NovemTempTable2);
                            NovemTempTable.Insert(false);
                            NovEntryNo += 1;
                        end;
                    until NovemSIrec.next = 0;



                if NovemTempTable2.FindSet() then
                    repeat
                        PMPSOrec.reset;
                        PMPSOrec.ChangeCompany('PMP');
                        PMPSOrec.SetLoadFields(I9G_SOCreated, "No.", "Document Type");
                        PMPSOrec.SetCurrentKey(I9G_SOCreated, "No.", "Document Type");
                        PMPSOrec.SetRange("Document Type", PMPSOrec."Document Type"::Order);
                        PMPSOrec.SetRange(I9G_SOCreated, true);
                        PMPSOrec.SetRange("No.", NovemTempTable.Code1);
                        if PMPSOrec.FindSet() then
                            repeat
                                NovemTempTable2.Boolean1 := true;
                                NovemTempTable2.Modify(false);
                            until PMPSOrec.next = 0;

                        PMPSIrec.reset;
                        PMPSIrec.ChangeCompany('PMP');
                        PMPSIrec.SetLoadFields(I9G_SOCreated, "No.");
                        PMPSIRec.SetCurrentKey(I9G_SOCreated, "Order No.");
                        PMPSIrec.SetRange(I9G_SOCreated, true);
                        PMPSIRec.SetRange("Order No.", NovemTempTable2.Code1);
                        if PMPSIrec.FindSet() then
                            repeat
                                NovemTempTable2.Boolean1 := true;
                                NovemTempTable2.Modify(false);
                            until PMPSIrec.next = 0;


                    until NovemTempTable2.next = 0;



            end;
        }

        dataitem(loopItem; Integer)
        {
            DataItemTableView = sorting(Number);

            column(SONo; NovemTempTable2.Code1)
            {

            }
            column(Bool; format(NovemTempTable2.Boolean1))
            { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetRange(Number, 1, NovemTempTable2.Count);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Number = 1 then
                    NovemTempTable2.FindFirst()
                else
                    NovemTempTable2.next;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnInit()
        var
            myInt: Integer;
        begin
            StartDate := WorkDate();
            EndDate := WorkDate();
        end;
    }
    rendering
    {
        layout("3PL - Sales Order Matching")
        {
            Type = RDLC;
            LayoutFile = './ReportLayout/Rpt80141-SalesOrderMatching.rdl';
        }
    }

    var
        I9tempTable: Record I9G_TempTable temporary;
        I9tempTable2: Record I9G_TempTable temporary;
        NovemTempTable: Record I9G_TempTable temporary;
        NovemTempTable2: Record I9G_TempTable temporary;
        NovemSOrec: Record "Sales Header";
        NovemSIRec: Record "Sales Invoice Header";
        PMPSOrec: Record "Sales Header";
        PMPSIRec: Record "Sales Invoice Header";
        NovEntryNo: Integer;
        StartDate: Date;
        EndDate: Date;
}
