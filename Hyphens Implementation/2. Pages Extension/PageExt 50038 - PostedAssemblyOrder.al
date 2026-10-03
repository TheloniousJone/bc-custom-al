pageextension 50038 PostedAssemblyOrder extends "Posted Assembly Order"
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