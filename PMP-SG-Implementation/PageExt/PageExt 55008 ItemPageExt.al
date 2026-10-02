pageextension 55008 ItemPageExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Reorder Point")
        {
            //DX        01 July 2021
            field("Min Holding Days"; Rec."Min Holding Days")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Max Holding Days"; Rec."Max Holding Days")
            {

                ApplicationArea = all;
                ShowMandatory = true;
            }
            //DX        01 July 2021

        }
        addafter(Item)
        {
            group("Transaction Related")
            {
                field(I9G_Restriction; Rec.I9G_Restriction)
                {
                    ApplicationArea = all;
                    showmandatory = true;
                }
                field(I9G_RequiredLOU; Rec.I9G_RequiredLOU)
                {
                    ApplicationArea = all;
                    showmandatory = true;
                }
                field("Exclusive Salesperson"; Rec."Exclusive Salesperson")
                {
                    ApplicationArea = all;
                }
                field("Not Salesperson"; Rec."Not Salesperson")
                {
                    ApplicationArea = all;
                }

                field("Max Mthly Order Qty"; Rec."Max Mthly Order Qty")
                {
                    ApplicationArea = all;
                }
                //DX        08 July 2021
                field("1st Tier Price Nego."; Rec."1st Tier Price Nego.")
                {
                    ApplicationArea = all;
                }
                field("2nd Tier Price Nego."; Rec."2nd Tier Price Nego.")
                {
                    ApplicationArea = all;
                }
                //DX        08 July 2021
                //DX        17 Jun 2021            
                field("Availability Date"; Rec."Availability Date")
                {
                    ApplicationArea = all;
                }
                //DX        17 Jun 2021
                field("Item Status"; Rec."Item Status")
                {
                    ApplicationArea = All;
                    LookupPageId = "Item Status List";
                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = All;
                }
                field("Status Remarks"; Rec."Status Remarks")
                {
                    ApplicationArea = All;
                }
                field("Status Reminder Date"; Rec."Status Reminder Date")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    ShowMandatory = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }

                // YF 27 Oct 2021
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                // YF 27 Oct 2021

                // YF 18 Nov 2021
                field("Last DateTime Modified"; Rec."Last DateTime Modified")
                {
                    ApplicationArea = All;
                }
                // YF 18 Nov 2021
            }

            group(Information)
            {
                //DX        01 July 2021
                field("Packing Instructions"; Rec."Packing Instructions")
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
                field("POM Item"; Rec."POM Item")
                {
                    ApplicationArea = all;
                }
                field("Wellaway Item"; Rec."Wellaway Item")
                {
                    ApplicationArea = all;
                }
                field("Logistics Service"; Rec."Logistics Service")
                {
                    ApplicationArea = all;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = all;
                }
                field("CD Type"; rec."CD Type")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }

                //jr added more fields here. 1:45/20/5/2021

                field("Generic Name"; Rec."Generic Name")
                {
                    ApplicationArea = All;
                    MultiLine = true;

                }
                field("Forensic Group"; Rec."Forensic Group")
                {
                    ApplicationArea = All;
                    LookupPageId = "Forensic Group List";

                }
                field("Storage Condition"; Rec."Storage Condition")
                {
                    ApplicationArea = All;


                }
                field("Administration Route"; Rec."Administration Route")
                {
                    ApplicationArea = All;
                    LookupPageId = "Administration Route List";

                }
                field("Other Information"; Rec."Other Information")
                {
                    ApplicationArea = All;

                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = All;

                }
                field("Packaging Description"; Rec."Packaging Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Principal; Rec.Principal)
                {
                    ApplicationArea = All;

                }
                field(Exchangeable; Rec.Exchangeable)
                {
                    ApplicationArea = All;

                }
                field("Principal Exchange Policy"; Rec."Principal Exchange Policy")
                {
                    ApplicationArea = All;

                }
                field("Purchase Information"; Rec."Purchase Information")
                {
                    ApplicationArea = All;

                }
                field("Customer Information"; Rec."Customer Information")
                {
                    ApplicationArea = All;

                }
                field("Competitor Information"; Rec."Competitor Information")
                {
                    ApplicationArea = All;
                }
                //DX        19 July 2023
                field(POMImageURL; Rec.ImageURL)
                {
                    ApplicationArea = all;
                }


                //DX        19 July 2023
                field(SkipFEFOPicking; Rec.SkipFEFOPicking)
                {
                    ApplicationArea = all;
                    Caption = 'Skip Warehouse FEFO Picking';
                }
                //DX        04 Sept 2023
                //DX        04 Sept 2023

            }

            group("Competitor Prices")
            {
                field("Apex Competitor Price"; Rec."Apex Competitor Price")
                {
                    ApplicationArea = All;
                }

                field("Pharmazen Competitor Price"; Rec."Pharmazen Competitor Price")
                {
                    ApplicationArea = All;
                }

                field("Nex Competitor Price"; Rec."Nex Competitor Price")
                {
                    ApplicationArea = All;
                }
            }
        }
        //DX        01 June 2021
        modify("Unit Price")
        {
            Visible = false;
        }
        modify(ItemPicture)
        {
            Visible = false;
        }
        //DX        01 June 2021

        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes
        addafter("Item Category Code")
        {
            field("Warehouse Classification"; Rec."Warehouse Classification")
            {
                ApplicationArea = All;
            }
        }
        addafter("Warehouse Classification")
        {
            field("Item Sales Classification"; Rec."Item Sales Classification")
            {
                ApplicationArea = All;
            }
        }
        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes

        addafter("Unit Price")
        {
            field("Wholesale Price"; Rec."Wholesale Price")
            {
                ApplicationArea = All;
            }

            field("Retail Price"; Rec."Retail Price")
            {
                ApplicationArea = All;
            }

            field("Item Commission Group"; Rec."Item Commission Group")
            {
                ApplicationArea = All;
            }
        }

        //  YF 26 Oct 2021
        addafter("Qty. on Sales Order")
        {
            field("I9_Qty. on Blanket Sales Order"; Rec."I9_Qty. on Blanket Sales Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Transfer Inbound"; Rec."Qty. on Transfer Inbound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. on Transfer Outbound field.';
            }
            field("Qty. on Transfer Outbound"; Rec."Qty. on Transfer Outbound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. on Transfer Outbound field.';
            }
        }
        // YF 26 Oct 2021

        addafter("Global Dimension 2 Code")
        {
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field(ShortcutDim5Code; Rec.ShortcutDim5Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim6Code; Rec.ShortcutDim6Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim7Code; Rec.ShortcutDim7Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim8Code; Rec.ShortcutDim8Code)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        //DX        04 July 2021
        addfirst(Navigation_Item)
        {
            action("Sales Trade Agreements")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page PharmaSalesPriceList;
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
            action("Sales Trade Agreement Staging")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page SalesTradeAgreementStaging;
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
            action("Purchase Trade Agreements")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Price;
                RunObject = page PharmaPurchasePriceList;
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                var
                    myInt: Integer;
                    PricePage: page PharmaPurchasePriceList;
                begin



                end;
            }
            action("Historial OB Transactions")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Historial Item Transactions";
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
            //DX        14 July 2021
            action("Update Exchangeable Status")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page UpdateExchangeable;
                trigger OnAction()
                begin

                end;
            }
            //DX        14 July 2021
            //DX        25 Aug 2021
            action("POM2 Therapeutic Group")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "POM2 Therapeutic Group";
                RunPageLink = "Item Code" = field("No.");
            }
            action("POM3 Therapeutic Group")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "POM3 Therapeutic Setup";
                RunPageLink = "Item No." = field("No.");
            }
            action("Product Rep Tagging")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Product Rep Tagging";
                RunPageLink = "Item Code" = field("No.");
            }
            action("Item Re&ferences2")
            {
                ApplicationArea = All;
                Caption = 'Item Re&ferences';
                Visible = True;
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Reference Entries";
                RunPageLink = "Item No." = FIELD("No.");
                ToolTip = 'Set up a customer''s or vendor''s own identification of the item. Item references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
            }
            //DX        25 Aug 2021
        }
        //DX        04 July 2021
    }

    trigger OnInsertRecord(belowxRec: Boolean): Boolean
    begin
        if PMPLS.IsLSLogin() then begin
            Rec."Logistics Service" := true;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        if PMPLS.IsLSLogin() then begin
            Rec."Logistics Service" := true;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CompanyName = 'PMP' then begin // YF 18 Nov 2021
            if Rec."No." <> '' then begin
                if (Rec."Product Type" <> Rec."Product Type"::Branded) And (Rec."Product Type" <> Rec."Product Type"::Generic) then begin
                    Message('Product Type needs to be entered');
                    exit(false);
                end;
                if (Rec.ShortcutDim4Code = '') then begin
                    Message('Product Code needs to be entered');
                    exit(false);
                end;
                if (Rec."Global Dimension 1 Code" = '') then begin
                    Message('Business Segment needs to be entered');
                    exit(false);
                end;
                if (Rec.ShortcutDim7Code = '') then begin
                    Message('Axdim2 needs to be entered');
                    exit(false);
                end;
                if (Rec.ShortcutDim8Code = '') then begin
                    Message('Axdim3 needs to be entered');
                    exit(false);
                end;
                if (Rec."Item Status" = '') then begin
                    Message('Item Status needs to be entered');
                    exit(false);
                end;
                if (Rec."Forensic Group" = '') then begin
                    Message('Forensic Group needs to be entered');
                    exit(false);
                end;
                if (Rec."Vendor No." = '') then begin
                    Message('Vendor No. needs to be entered');
                    exit(false);
                end;
                if (Rec."Reordering Policy" = Rec."Reordering Policy"::" ") then begin
                    Message('Reordering Policy needs to be entered');
                    exit(false);
                end;

                // if (rec.I9G_RequiredLOU = true) then begin
                //     if rec.I9G_Restriction = '' then begin
                //         Message('I9G Restriction needs to be entered');
                //         exit(false);
                //     end


                // end
                // if (Rec."Min Holding Days" = 0) and (Rec."Max Holding Days" = 0 ) then begin
                //     Message('Customer Group needs to be entered');
                //     exit(false);

                // end;
            end;
        end;

        exit(true);
    end;

    var
        PMPLS: Codeunit LS;
}