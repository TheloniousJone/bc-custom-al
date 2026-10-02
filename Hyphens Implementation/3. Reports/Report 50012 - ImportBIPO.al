report 50012 ImportBIPO
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnPreDataItem()
            begin
                clear(gcdu_Hyphens);
                gcdu_Hyphens.ImportBIPO(gcd_Template, gcd_Batch, gdt_PostingDate);
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
                    field(gdt_PostingDate; gdt_PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                }
            }
        }


    }

    var
        gdt_PostingDate: Date;
        gcdu_Hyphens: Codeunit "Hyphens CU";
        gcd_Template: Code[10];
        gcd_Batch: Code[10];

    procedure GetTemplateBatch(Template: Code[10]; Batch: Code[10])
    begin
        Clear(gcd_Template);
        Clear(gcd_Batch);

        gcd_Template := Template;
        gcd_Batch := Batch;
    end;
}