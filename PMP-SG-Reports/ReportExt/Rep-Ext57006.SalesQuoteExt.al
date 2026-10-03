reportextension 57006 SalesQuoteExt extends "Standard Sales - Quote"
{
    WordLayout = './ReportExtLayouts/Rep-Ext57006.SalesQuote.docx';
    dataset
    {
        add(Line)
        {
            column(FOCQty; FormattedFOCQuantity)
            {
            }
            column(SellingPrice; FormattedSellingPrice)
            {

            }
            column(OrderQty_Line; FormattedOrderQuantity)
            {
            }

        }

        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if Line."FOC Qty" = 0 then
                    FormattedFOCQuantity := ''
                else
                    FormattedFOCQuantity := Format(Line."FOC Qty", 0, '<Precision,0:5><Standard Format,0>');

                if Line."Order Qty" = 0 then
                    FormattedOrderQuantity := ''
                else
                    FormattedOrderQuantity := Format(Line."Order Qty", 0, '<Precision,0:5><Standard Format,0>');

                if Line."Selling Price" = 0 then
                    FormattedSellingPrice := ''
                else
                    FormattedSellingPrice := Format(Line."Selling Price", 0, '<Precision,2:5><Standard Format,0>');
            end;
        }
    }

    var
        FormattedSellingPrice: Text;
        FormattedFOCQuantity: Text;
        FormattedOrderQuantity: Text;
}
