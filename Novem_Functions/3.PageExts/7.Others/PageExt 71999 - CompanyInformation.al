pageextension 71999 CompanyInformationExt extends "Company Information"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("I9G_BankAddress"; Rec.I9G_BankAddress)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Bank Address field.';
            }
            field(I9G_BankCode; Rec.I9G_BankCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Bank Code field.';
            }
            field(I9G_Paynow; Rec.I9G_Paynow)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the PayNow field.';
            }
            field(I9G_DocumentRequired; Rec.I9G_DocumentRequired)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Documents Required field.';
            }
            field(I9G_QRCode; Rec.I9G_QRCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the QR Code field.';
            }
        }
        addlast("System Indicator")
        {
            field(I9G_Novem; Rec.I9G_Novem)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Novem field.';
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}