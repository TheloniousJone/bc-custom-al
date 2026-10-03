report 70060 SalesAnalysBySalesEmployee
{
    Caption = 'Sales Analysis by Sales Employee';
    DefaultLayout = RDLC;
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './6.ReportLayouts/Rpt70060-SalesAnalysRpBySalesEmployee.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Customer Group";
            dataitem("CustLedgerEntry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Customer No.", "Posting Date") where("Document Type" = const(Invoice));
                RequestFilterFields = "Posting Date", "Shortcut Dimension 7 Code";

                // column(Customer_Group; Customer."Customer Group") { }
                // column(SNNO; SNNO) { }
                // column(Sales_Employee_Code; "Shortcut Dimension 7 Code") { }
                // column(Document_Type; "Document Type") { }
                // column(Amount_LCY; "Amount (LCY)") { }
                // column(Sales__LCY_; "Sales (LCY)") { }
                // column(IsApplied; IsApplied) { }
                // dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                // {
                //     DataItemLinkReference = CustLedgerEntry;
                //     DataItemLink = "Applied Cust. Ledger Entry No." = field("Entry No.");
                //     DataItemTableView = sorting("Customer No.", "Document No.", "Posting Date") where("Entry Type" = const(Application));

                //     trigger OnAfterGetRecord()
                //     begin


                //         Clear(IsApplied);
                //         if "Document Type" = "Document Type"::"Credit Memo" then
                //             IsApplied := true;
                //     end;

                // }

                trigger OnPreDataItem()
                begin
                    "CustLedgerEntry".SetAutoCalcFields("Shortcut Dimension 7 Code");
                end;

                trigger OnAfterGetRecord()
                begin
                    InsertCustLedgerIntoTemp(CustLedgerEntry, Customer."Customer Group");
                end;
            }

            trigger OnAfterGetRecord()
            begin
            end;

        }
        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(Customer_Group; I9G_TempTableRec.code1) { }
            column(Sales_Employee_Code; I9G_TempTableRec.code2) { }
            column(DocType; I9G_TempTableRec.Option1) { }
            column(SNNO; I9G_TempTableRec.Integer2) { }
            column(InvNum; I9G_TempTableRec.Integer1) { }
            column(Sales_LCY; I9G_TempTableRec.Decimal1) { }
            column(Profit_LCY; I9G_TempTableRec.Decimal2) { }
            trigger OnPreDataItem()
            begin
                I9G_TempTableRec.Reset();
                SetRange(Number, 1, I9G_TempTableRec.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    I9G_TempTableRec.FindFirst()
                else
                    I9G_TempTableRec.Next();
            end;

            trigger OnPostDataItem()
            begin
                I9G_TempTableRec.DeleteAll();
            end;
        }

    }

    trigger OnInitReport()
    var
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    trigger OnPreReport()
    var
    begin
        SNNO := 0;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        I9G_TempTableRec: Record I9G_TempTable temporary;
        SNNO: Integer;
        IsApplied: Boolean;
        EntryNo: Integer;

    local procedure InsertCustLedgerIntoTemp(var CustLedgerEntry: Record "Cust. Ledger Entry"; CustGroup: Code[20])
    var
        DetailedCustLedgEnt: Record "Detailed Cust. Ledg. Entry";
    begin
        SNNO := 0;

        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;

        CustLedgerEntry.CalcFields("Shortcut Dimension 7 Code", "Amount (LCY)");

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code2, CustLedgerEntry."Shortcut Dimension 7 Code");
        if not I9G_TempTableRec.FindFirst() then begin
            DetailedCustLedgEnt.Reset();
            DetailedCustLedgEnt.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
            DetailedCustLedgEnt.SetRange("Entry Type", DetailedCustLedgEnt."Entry Type"::Application);
            DetailedCustLedgEnt.SetRange(DetailedCustLedgEnt."Document Type", DetailedCustLedgEnt."Document Type"::"Credit Memo");
            if not DetailedCustLedgEnt.FindFirst() then begin

                I9G_TempTableRec.Reset();
                I9G_TempTableRec.Init();
                I9G_TempTableRec."Entry No." := EntryNo;
                I9G_TempTableRec.Code1 := CustGroup;
                I9G_TempTableRec.Code2 := CustLedgerEntry."Shortcut Dimension 7 Code"; // B
                I9G_TempTableRec.Option1 := CustLedgerEntry."Document Type"; // C
                I9G_TempTableRec.Integer1 := 1; // C
                I9G_TempTableRec.Integer2 := SNNO + 1; // A

                I9G_TempTableRec.Decimal1 := CustLedgerEntry."Sales (LCY)"; // D
                I9G_TempTableRec.Decimal2 := CustLedgerEntry."Profit (LCY)"; // E

                I9G_TempTableRec.Insert();
            end
            else begin
                CurrReport.Skip();
            end;
        end
        else begin
            DetailedCustLedgEnt.Reset();
            DetailedCustLedgEnt.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
            DetailedCustLedgEnt.SetRange("Entry Type", DetailedCustLedgEnt."Entry Type"::Application);
            DetailedCustLedgEnt.SetRange(DetailedCustLedgEnt."Document Type", DetailedCustLedgEnt."Document Type"::"Credit Memo");
            if not DetailedCustLedgEnt.FindFirst() then begin
                I9G_TempTableRec.Integer1 += 1; // C

                I9G_TempTableRec.Decimal1 += CustLedgerEntry."Sales (LCY)"; // D
                I9G_TempTableRec.Decimal2 += CustLedgerEntry."Profit (LCY)"; // E

                I9G_TempTableRec.Modify();
            end
            else begin
                CurrReport.Skip();
            end;

        end;

    end;
}