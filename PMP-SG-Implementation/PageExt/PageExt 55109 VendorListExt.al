pageextension 55109 VendorListExt extends "Vendor List"
{
    layout
    {
        // layout changes here
        addafter("Payments (LCY)")
        {
            field(SystemCreatedBy; EnhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }

            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }

            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
            }
            field("Ship From Country"; Rec."Ship From Country")
            {
                ApplicationArea = all;
            }
            //DX        12 Apr 2023
            field(I9G_CreditLimitLCY; Rec.I9G_CreditLimitLCY)
            {
                ApplicationArea = all;
            }
            //DX        12 Apr 2023
        }
    }

    actions
    {
        // action changes here
        addafter(PayVendor)
        {
            action("Delayed Order")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    report.Run(57117, true, true);
                end;


            }

            action("Purchase Trade Agreements")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page PharmaPurchasePriceList;
                RunPageLink = "Vendor No." = field("No.");
                trigger OnAction()
                begin
                end;
            }
        }
    }


    var
        EnhanceCU: Codeunit "PMP-Enhancements";

}
