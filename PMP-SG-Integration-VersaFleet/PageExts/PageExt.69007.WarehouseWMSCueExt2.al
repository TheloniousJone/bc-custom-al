pageextension 69007 WarehouseWMSCueExt2 extends "Whse. WMS Role Center"
{
    layout
    {
        addafter(Control1903327208)
        {
            part(VersaFleet; VersaCues)
            {
                ApplicationArea = all;
                Caption = 'VersaFleet';
                Visible = true;
            }
        }
    }


}