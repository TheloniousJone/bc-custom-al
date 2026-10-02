pageextension 55107 RegWhsePutawayListExt extends "Registered Whse. Put-aways"
{
    layout
    {
        // layout changes here
        addafter("Sorting Method")
        {
            // YF 08 Nov 2021
            field("Source Doc Type"; Rec."Source Doc Type")
            {
                Caption = 'Source Document Type';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Doc No."; Rec."Source Doc No.")
            {
                Caption = 'Source Document No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Ext Doc No."; Rec."Source Ext Doc No.")
            {
                Caption = 'Source External Document No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Vend/Cust No."; Rec."Source Vend/Cust No.")
            {
                Caption = 'Source Vendor/Customer No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Vend/Cust Name"; Rec."Source Vend/Cust Name")
            {
                Caption = 'Source Vendor/Customer Name';
                ApplicationArea = All;
                Editable = false;
            }

            field("Source Branch"; Rec."Source Branch")
            {
                Caption = 'Source Branch';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // action changes here
    }

}
