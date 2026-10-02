tableextension 90001 ChainCustomerExt extends Customer
{
    fields
    {
        field(90000; "Apply Chain Conversion"; Boolean)
        {
            Caption = 'Apply Chain Conversion';
            DataClassification = ToBeClassified;
            ToolTip = 'Enable if use packsize for this Customer. Do check for this field in Item Reference too. Will only apply is both Item Reference and Customer are enabled';
        }
    }
}
