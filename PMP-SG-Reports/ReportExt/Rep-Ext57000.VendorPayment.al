reportextension 57000 "Vendor Payment" extends "Vendor - Payment Receipt"
{
    RDLCLayout = './ReportExtLayouts/Rep-Ext57000.VendorPayment.rdl';
    dataset
    {
        add(PageLoop)
        {
            column(companylogo; Compinfo.Picture)
            {
            }
        }
        add(VendLedgEntry2)
        {
            column(ExternalDocumentNo_VendLedgEntry2; "External Document No.")
            {
            }
        }
        add(VendLedgEntry1)
        {
            column(ExternalDocumentNo_VendLedgEntry1; "External Document No.")
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
}
