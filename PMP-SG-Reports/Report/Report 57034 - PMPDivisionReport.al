report 57034 "PMP Division Report"
{
    ApplicationArea = All;
    Caption = 'PMP Division Report';
    RDLCLayout = './ReportLayouts/ReportLayout 57034 - PMP Division Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            //DataItemTableView = where("Income/Balance" = filter('INCOME'));
            RequestFilterFields = "G/L Account No.";
            column(No; "G/L Account No.")
            {
            }
            column(Name; "G/L Account Name")
            {
            }
            column(DimVal; "Global Dimension 1 Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Amount; Amount)
            {

            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;

                GLAcct: Record "G/L Account";
            begin


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
                    Caption = 'General';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
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


    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        StartDate := CalcDate('CM-1M+1D', WorkDate());
        EndDate := CalcDate('<CM>', WorkDate());
    end;

    var
        StartDate: Date;
        EndDate: Date;

        WSVal: Decimal;
        NewBizVal: Decimal;
        TotalVal: Decimal;
        WellVal: Decimal;
        DimVal: Code[20];
        GLName: Text[100];
}
