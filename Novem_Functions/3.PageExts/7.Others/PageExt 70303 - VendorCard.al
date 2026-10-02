pageextension 70303 VendorCardExt_Novem extends "Vendor Card"
{
    layout
    {
        addlast("Address & Contact")
        {
            field(I9G_ContactDetail; Rec.I9G_ContactDetail)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }

    trigger OnAfterGetRecord()
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