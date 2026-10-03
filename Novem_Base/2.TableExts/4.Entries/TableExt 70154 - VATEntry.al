tableextension 70154 VATEntry extends "VAT Entry"
{
    fields
    {
        field(70000; I9G_GSTBaseAmount; Decimal)
        {
            Caption = 'GST Base Amount';
            AutoFormatType = 1;
        }
    }
}