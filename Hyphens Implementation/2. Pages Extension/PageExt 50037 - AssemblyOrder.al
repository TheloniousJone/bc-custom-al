pageextension 50037 AssemblyOrder extends "Assembly Order"
{
    layout
    {
        addafter("Ending Date")
        {
            field(I9G_ForecastDate; Rec.I9G_ForecastDate)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }
}