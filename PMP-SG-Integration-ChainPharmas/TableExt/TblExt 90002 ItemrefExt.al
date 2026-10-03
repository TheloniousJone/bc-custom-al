tableextension 90002 ChainItemrefExt extends "Item Reference"
{
    fields
    {
        field(90000; "Apply Chain Conversion"; Boolean)
        {
            Caption = 'Apply Chain Conversion';
            DataClassification = ToBeClassified;
            ToolTip = 'Enable if use packsize for this item. Do check for this field in Customer too. Will only apply is both Item Reference and Customer are enabled';
        }
    }
}
