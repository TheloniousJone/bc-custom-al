pageextension 55158 CustomerPriceGroupsExt extends "Customer Price Groups"
{
    layout
    {
        addlast(Control1)
        {
            field(I9G_EmailonPriceChg; Rec.I9G_EmailonPriceChg)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}