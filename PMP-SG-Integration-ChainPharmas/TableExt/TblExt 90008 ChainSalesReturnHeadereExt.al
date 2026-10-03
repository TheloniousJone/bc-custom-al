
tableextension 90008 ChainSalesReturnHeaderExt extends "Return Shipment Header"
{
    fields
    {
        field(90000; "Apply Chain Conversion"; Boolean)
        {
            Caption = 'Apply Chain Conversion';
            DataClassification = ToBeClassified;
            ToolTip = 'Enable if use packsize for this Customer. Do check for this field in Lines too. Will only apply is both Lines and Customer are enabled';
        }
    }
}
