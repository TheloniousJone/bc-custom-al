pageextension 55064 PurchaseOrderPageExt extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {

            field("Internal Remarks"; Rec."Internal Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

            field("Created From Req. Wksht."; Rec."Created From Req. Wksht.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //DX        15 Aug 2021 
            field(">5K"; Rec.">5K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(">300K"; Rec.">300K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(">6 Mth"; Rec.">6 Mth Inventory")
            {
                ApplicationArea = all;
                Editable = false;
            }
            //RL    14 Jun 2022
            field("Special Instructions"; Rec."Special Instructions")
            {
                ApplicationArea = all;
            }
            //RL    14 Jun 2022

            //DX        15 Aug 2021 

            field("Logistics Service"; Rec."Logistics Service")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    SSSetup: Record "Sales & Receivables Setup";
                begin
                    if Rec."Logistics Service" = true then begin
                        SSSetup.Get;
                        if SSSetup."Def. LS Location Code" <> '' then begin
                            Rec.Validate("Location Code", SSsetup."Def. LS Location Code");
                        end;
                    end;
                end;
            }
        }

        addbefore("Shipment Method Code")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
            }
        }

        // YF 14 Feb 2022 // Additional if PO created from Assembly Order
        addlast(content)
        {
            group("Assembly Order Information")
            {
                field("Is From Assembly Order"; Rec."Is From Assembly Order")
                {
                    ApplicationArea = All;
                }
                field("AO No."; Rec."AO No.")
                {
                    ApplicationArea = All;
                }

                field("AO Item No."; Rec."AO Item No.")
                {
                    ApplicationArea = All;
                }

                field("AO Item Descr"; Rec."AO Item Descr")
                {
                    ApplicationArea = All;
                }

                field("AO Item Qty"; Rec."AO Item Qty")
                {
                    ApplicationArea = All;
                }

                field("AO Item UOM"; Rec."AO Item UOM")
                {
                    ApplicationArea = All;
                }

                field("AO Item Batch"; Rec."AO Item Batch")
                {
                    ApplicationArea = All;
                }

                field("AO Item Expiry Date"; Rec."AO Item Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("AO Item Packing Instruction"; Rec."AO Item Packing Instruction")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
        // YF 14 Feb 2022 // Additional if PO created from Assembly Order

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

        addafter("Shortcut Dimension 2 Code")
        {
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;

            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
                Visible = true;
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

    }
    actions
    {
        addafter(CopyDocument)
        {
            action("Create Principal POs")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Create;

                trigger OnAction()
                var
                    EnhanceCU: Codeunit "PMP-Enhancements";
                begin
                    /*
                    if Confirm('Are you sure you wish to create mulitple POs by Principal?') then
                        EnhanceCU.CreatePrincipalPOs(Rec);
                    */

                    if Confirm('Are you sure you wish to create mulitple POs by Principal?') then begin
                        EnhanceCU.CreatePrincipalPOsV2(Rec);
                        // CurrPage.Update(false);
                    end;

                end;
            }
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                PMPEnhanceCU: Codeunit "PMP-Enhancements";
            begin
                //DX        15 Aug 2021
                PMPEnhanceCU.PMPPOApproval(Rec);
                //DX        15 Aug 2021

            end;
        }
        //RL    20 Oct 2021
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                PMPEnhanceCU: Codeunit "PMP-Enhancements";
            begin
                PMPEnhanceCU.PMPPOApproval(Rec);
            end;
        }
        //RL    20 Oct 2021
    }

    trigger OnInsertRecord(Belowxrec: Boolean): Boolean
    var
        SSSetup: Record "Sales & Receivables Setup";
    begin
        //DX        08 Aug 2021
        if Rec."Logistics Service" = true then begin
            SSSetup.reset;
            SSSetup.get;
            if SSSetup."Def. LS Location COde" <> '' then begin
                Rec.Validate("Location Code", SSsetup."Def. LS Location COde");
                rec.Modify(TRUE);
            end;
        end;
        //DX        08 Aug 2021            
    end;

}
