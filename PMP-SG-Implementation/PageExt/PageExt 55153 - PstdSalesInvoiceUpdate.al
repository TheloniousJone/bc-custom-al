pageextension 55153 PstdSalesInvoiceUpdate extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter("Company Bank Account Code")
        {
            //DX        21 Feb 2024
            field("Bill-to Post Code"; Rec."Bill-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Sell-to Post Code"; Rec."Sell-to Post Code")
            {
                ApplicationArea = all;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }

            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Status field.', Comment = '%';
            }
            //DX        21 Feb 2024
        }
    }

    actions
    {

    }
}