page 57014 SalesTargetAPI
{
    ApplicationArea = All;
    Caption = 'Sales Target API';
    PageType = List;
    SourceTable = "Sales Target";
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = ALL;
                }
                field("Status Date"; Rec.Date)
                {
                    ApplicationArea = ALL;
                }
                field("ShortcutDim3Code"; Rec."Business Unit")
                {
                    ApplicationArea = ALL;
                }
                field("Version"; Rec.Version)
                {
                    ApplicationArea = ALL;
                }
                field("Forecast"; Rec.Forecast)
                {
                    ApplicationArea = ALL;
                }
                field(Sector; Sector)
                {
                    ApplicationArea = ALL;
                }
                field(Channel; Channel)
                {
                    ApplicationArea = ALL;
                }
                //DX        14 Dec 2024
                field(customer_guid; CustGUID)
                {

                }
                //DX        14 Dec 2024
            }
        }
    }

    var
        Sector: text[100];
        Channel: text[100];
        CustGUID: text[100];

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        Clear(Sector);
        Clear(Channel);
        clear(CustGUID);
        Customer.Reset();
        Customer.SetLoadFields("No.", I9G_Channel, I9G_Sector, SystemId);       //DX        14 Dec 24       Performance
        Customer.SetCurrentKey("No.");
        Customer.SetRange("No.", Rec."Customer No.");
        if Customer.FindFirst() then begin
            Sector := Customer.I9G_Sector;
            Channel := Customer.I9G_Channel;
            CustGUID := Customer.SystemId;      //DX        14 Dec 224
        end;

    end;
}