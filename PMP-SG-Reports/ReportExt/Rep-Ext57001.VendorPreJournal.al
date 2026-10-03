reportextension 57001 VendorPreJournal extends "Vendor Pre-Payment Journal"
{
    RDLCLayout = './ReportExtLayouts/Rep-Ext57001.VendorPreJournal.rdl';
    dataset
    {
        add("Integer")
        {
            column(companylogo; Compinfo.Picture)
            {
            }
        }
        add("Vendor Ledger Entry")
        {
            column(Vendor_Ledger_Entry__Ext__Document_No__; "External Document No.")
            {
            }
            column(Vendor_Ledger_Entry__Ext__Document_Date; "Document Date")
            {

            }
        }
        add("Cust. Ledger Entry")
        {
            column(Cust_Ledger_Entry__EXT__Document_No__; "External Document No.")
            {
            }
            column(Cust_Ledger_Entry__EXT__Document_Date; "Document Date")
            {

            }
        }
        add("Gen. Journal Line")
        {
            column(Payment_Reference; "Payment Reference")
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
