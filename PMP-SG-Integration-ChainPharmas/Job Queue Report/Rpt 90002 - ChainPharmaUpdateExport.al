report 90002 ChainPharmaUpdateExport
{
    ApplicationArea = All;
    Caption = 'ChainPharmaUpdateExport';
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = Exported, "Chain Pharmacy", "No.";
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                chainCU: Codeunit ChainPharmaCU;
            begin
                chainCU.UpdatePosted(SalesInvoiceHeader, SetBool);
                Message('completed');
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
                    field(SetBool; SetBool)
                    { ApplicationArea = all; }

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        SetBool: Boolean;
}
