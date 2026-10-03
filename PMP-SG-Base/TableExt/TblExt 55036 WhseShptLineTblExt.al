tableextension 55036 WhseShptLineTblExt extends "Warehouse Shipment Line"
{

    fields
    {
        field(55000; "Delete After Post"; Boolean)
        {
            Caption = 'Can Delete After Post';
        }
        field(55084; MinShelf; Date)
        {
            Caption = 'Min Shelf Life';
        }

    }

}