pageextension 55082 PostedPurchInvoicePageExt extends "Posted Purchase Invoice"
{
    layout
    {
        addbefore("Shipment Method Code")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
            }
        }

        addafter(Corrective)
        {
            field("Internal Remarks"; Rec."Internal Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }

        // YF 03 Mar 2022
        addafter("Purchaser Code")
        {
            field("Country of Purchase Code"; Rec."Country of Purchase Code")
            {
                ApplicationArea = All;
            }
            field("Ship From Country"; Rec."Ship From Country")
            {
                ApplicationArea = all;
            }

            // Add system last modified at field // Begin
            field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            // Add system last modified at field // End
        }
        // YF 03 Mar 2022        
    }
}
