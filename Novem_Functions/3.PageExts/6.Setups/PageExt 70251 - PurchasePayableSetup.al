pageextension 70251 PurchasePayableSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        addafter(Archiving)
        {
            group(Reporting)
            {
                Caption = 'Reporting';
                field(I9G_CreditNoteFooter; Rec.I9G_CreditNoteFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Credit Note Footer field.';
                }
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