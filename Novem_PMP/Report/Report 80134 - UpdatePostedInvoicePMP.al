report 80134 "UpdatePostedInvoicePMP"
{
    ApplicationArea = All;
    Caption = 'UpdatePostedInvoicePMP';

    ProcessingOnly = true;

    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                thirdCU.UpdateInvNoAtNovem(NovemInvNo, PMPInvoiceNo);
                thirdCU.UpdateShipNoAtNovem(NovemSHipNo, PmpShipNo);
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
                    field(NovemInvNo; NovemInvNo)
                    {
                        ApplicationArea = all;
                    }
                    field(PMPInvoiceNo; PMPInvoiceNo)
                    {
                        ApplicationArea = all;
                    }
                    field(NovemShipNo; NovemShipNo)
                    {
                        ApplicationArea = all;
                    }
                    field(PMPShipNo; PMPShipNo)
                    {
                        ApplicationArea = all;
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
    var
        PMPInvoiceNo: code[20];
        NovemInvNo: code[20];
        thirdCU: Codeunit I9G_ThirdPartyLogisticCU;
        NovemSHipNo: code[20];
        PmpShipNo: code[20];
}
