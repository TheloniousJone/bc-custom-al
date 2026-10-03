reportextension 57005 WHRegister extends "Warehouse Register - Quantity"
{
    RDLCLayout = './ReportExtLayouts/Rep-Ext57005.WHRegister.rdl';
    dataset
    {
        add("Warehouse Entry")
        {
            column(Remarks; Remarks)
            {
            }
        }
    }
}
