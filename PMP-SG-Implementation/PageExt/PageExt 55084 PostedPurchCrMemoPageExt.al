pageextension 55084 PostedPurchaseCrMemoPageExt extends "Posted Purchase Credit Memo"
{
    layout
    {
        addbefore("Ship-to")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
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
        }
        // YF 03 Mar 2022        
    }
}
