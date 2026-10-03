pageextension 70076 ShipToAddressList extends "Ship-to Address List"
{
    layout
    {
        addfirst(Control1)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field(CustomerName; CustomerName)
            {
                ApplicationArea = All;
                Caption = 'Customer Name';
            }
        }
        addafter("Name 2")
        {
            field(SalespersonCode; SalespersonCode)
            {
                ApplicationArea = All;
                Caption = 'Salesperson Code';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        Clear(CustomerName);
        Clear(SalespersonCode);

        Customer.Reset();
        if Customer.Get(Rec."Customer No.") then begin
            CustomerName := Customer.Name;
            SalespersonCode := Customer."Salesperson Code";
        end;
    end;

    var
        CustomerName: Text[100];
        SalespersonCode: Code[10];
}