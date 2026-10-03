pageextension 55114 AssemblyOrdersList extends "Assembly Orders"
{
    layout
    {
        addafter("Due Date")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
