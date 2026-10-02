reportextension 70000 VendBalanceToDate extends "Vendor - Balance to Date"
{
    RDLCLayout = './7.ReportExtLayouts/Rpt70000-VendBalanceToDate.rdl';

    dataset
    {
        add(VendLedgEntry3)
        {
            column(ExtDocNo_VendLedgEntry3; "External Document No.") { }
            column(DueDate_VendLedgEntry3; Format("Due Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
        }
    }
}