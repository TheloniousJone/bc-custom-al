pageextension 55067 PostedInvtShptPageExt extends "Posted Invt. Shipment"
{
    layout
    {
        addbefore("External Document No.")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("External Document No.")
        {
            field("I9 Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        modify("Salesperson Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = false;
        }
    }
}
