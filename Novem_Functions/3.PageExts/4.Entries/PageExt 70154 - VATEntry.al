pageextension 70154 VATEntryExt extends "VAT Entries"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field(I9G_GSTBaseAmount; Rec.I9G_GSTBaseAmount)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}