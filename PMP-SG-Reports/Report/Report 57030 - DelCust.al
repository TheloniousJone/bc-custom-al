report 57030 DelCust
{
    Caption = 'DelCust';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                CustRec: Record Customer;
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                CustRec.reset;
                if CustRec.FindFirst() then begin
                    if CustRec."No." = '' then begin
                        CustRec.Delete(false);
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
}
