pageextension 55026 VendorCardExt extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(content)
        {
            group(Additional)
            {
                field("Vendor Status"; Rec."Vendor Status")
                {
                    ApplicationArea = all;

                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = all;

                }
                field("Status Remarks"; Rec."Status Remarks")
                {
                    ApplicationArea = all;

                }
                field("Store Information"; Rec."Store Information")
                {

                    ApplicationArea = all;
                }
                field("Accpac Code"; Rec."Accpac Code")
                {
                    ApplicationArea = all;

                }
                field("Biz Registration Type"; Rec."Biz Registration Type")
                {
                    ApplicationArea = all;

                }
                //DX            14 July 2021
                field(Exchangeable; Rec.Exchangeable)
                {
                    ApplicationArea = all;
                }
                //DX            14 July 2021

                field("Freight Insurance"; Rec."Freight Insurance")
                {
                    ApplicationArea = All;
                }
                field("Ship From Country"; Rec."Ship From Country")
                {
                    ApplicationArea = All;
                }
                //DX        12 Apr 2023
                field(I9G_CreditLimitLCY; Rec.I9G_CreditLimitLCY)
                {
                    ApplicationArea = all;
                }
                //DX        12 Apr 2023
            }
        }

        addbefore("Shipment Method Code")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        addafter("Currency Code")
        {
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;

            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim5Code; Rec.ShortcutDim5Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim6Code; Rec.ShortcutDim6Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim7Code; Rec.ShortcutDim7Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim8Code; Rec.ShortcutDim8Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Preferred Bank Account Code")
        {
            field("Payment Week"; Rec."Payment Week")
            {
                ApplicationArea = All;
            }
        }
        modify("Vendor Posting Group")
        {
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = True;
        }
        modify("Gen. Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify(GLN)
        {
            Caption = 'GLN(GST Reg No.)';
        }
        modify("VAT Registration No.")
        {
            Caption = 'Exemption Certificate No.(ACRA No.)';
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(MergeDuplicate)
        {
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
        myInt: Integer;
}