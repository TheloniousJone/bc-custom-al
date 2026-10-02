report 59003 "Retire POM Reference"
{
    ApplicationArea = All;
    Caption = 'Retire POM Reference';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = Sorting(Number) where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                POMCU: Codeunit POM2;
            begin
                Clear(POMCU);
                POMCU.RetirePOMReference(POMReferenceNo, StartDate, EndDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filtering)
                {
                    field(POMReferenceNo; POMReferenceNo)
                    {
                        Caption = 'POM Reference No.';
                        ApplicationArea = All;
                    }

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
    }

    var
        POMReferenceNo: Text[35];
        StartDate: Date;
        EndDate: Date;
}
