pageextension 55000 CustCardPageExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(Additional)
            {

                group("Billing Information")
                {

                    field("Bill Name"; Rec."Bill Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Name 2"; Rec."Bill Name 2")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Address"; Rec."Bill Address") // YF 08 Sep 2023 // remove trailing spaces
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Address 2"; Rec."Bill Address 2")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill City"; Rec."Bill City")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Contact"; Rec."Bill Contact")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Post Code"; Rec."Bill Post Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Country Code"; Rec."Bill Country Code")
                    {
                        ApplicationArea = all;
                    }

                }

                field("Mandatory Ext Doc. No."; Rec."Mandatory Ext Doc. No.")
                {
                    ApplicationArea = all;
                }
                field(I9G_DONeeded; Rec.I9G_DONeeded)
                {
                    ApplicationArea = All;
                }
                field("E-Invoicing"; Rec."E-Invoicing")
                {
                    ApplicationArea = all;
                }

                field("Customer Instructions"; Rec."Customer Instructions")
                {
                    ApplicationArea = all;
                }
                field("Picking Instructions"; Rec."Picking Instructions")
                {
                    ApplicationArea = all;
                }
                field("Delivery Instructions"; Rec."Delivery Instructions")
                {
                    ApplicationArea = all;
                }
                field("Priority Picking"; Rec."Priority Picking")
                {
                    ApplicationArea = all;
                }

                field("POM Customer"; Rec."POM Customer")
                {
                    ApplicationArea = all;
                }

                field("Wellaway Customer"; Rec."Wellaway Customer")
                {
                    ApplicationArea = all;
                }

                // YF 29 Sept 2021
                field("Wellaway Web User ID"; Rec."Wellaway Web User ID")
                {
                    ApplicationArea = All;
                }

                field("Wellaway Web User Name"; Rec."Wellaway Web User Name")
                {
                    ApplicationArea = All;
                }

                field("Wellaway Web User Email"; Rec."Wellaway Web User Email")
                {
                    ApplicationArea = All;
                }
                // YF 29 Sept 2021


                field("Logistics Service"; Rec."Logistics Service")
                {
                    ApplicationArea = all;
                }
                field("Chain Pharmacy"; Rec."Chain Pharmacy")
                {
                    ApplicationArea = all;
                }
                field("LS Percentage"; Rec."LS Percentage")
                {
                    ApplicationArea = all;
                    Caption = 'LS Percentage calculation for LS Invoices';
                }

                //jr added more fields here. 2:06/20/5/2021           
                field("Customer Status"; Rec."Customer Status")
                {
                    ApplicationArea = all;

                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = all;

                }

                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = all;
                    LookupPageId = "Delivery Charge List";
                    ShowMandatory = True;

                }
                field("Activate Commercial"; Rec."Activate Commercial")
                {
                    ApplicationArea = all;

                }
                field("Commercial Permission Group"; Rec."Commercial Permission Group")
                {
                    ApplicationArea = all;

                }
                field("Activate Forensic"; Rec."Activate Forensic")
                {
                    ApplicationArea = all;
                    Visible = false;


                }
                field("Forensic Permmission Group"; Rec."Forensic Permmission Group")
                {
                    ApplicationArea = all;
                    Caption = 'Forensic Permissions';

                }

                field("Default Shipping Cage"; Rec."Default Shipping Cage")
                {
                    ApplicationArea = all;
                    //DX        09 July 2021 revert to delivery zone field
                    Visible = false;

                }
                //DX        07 Oct 2021
                field("Single PO"; Rec."Single PO")
                {
                    ApplicationArea = all;
                    ToolTip = 'Enable to ensure each PO is tied to only 1 SO/DO/INV';
                    Caption = 'Single PO to SO';
                }
                field("I9G_Invoice Copies"; Rec."Invoice Copies")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Copies';
                    ToolTip = 'Specifies the value of the Invoice Copies field.';
                }
                //DX        07 Oct 2021
                field("WS Membership"; Rec."WS Membership")
                {
                    ApplicationArea = all;
                    LookupPageId = "WS Membership";
                }
                field("I9G_RequirementApproval"; Rec."I9G_RequirementApproval")
                {
                    ApplicationArea = All;
                }
            }
            group(Information)
            {
                field("Status Remarks"; Rec."Status Remarks")
                {
                    ApplicationArea = all;
                    MultiLine = true;

                }
                field("Acct Information"; Rec."Acct Information")
                {
                    ApplicationArea = all;
                }
                field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
                {
                    ApplicationArea = all;

                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = all;
                    LookupPageId = "Customer Group List";
                    ShowMandatory = True;

                }
                field("One-time Customer"; Rec."One-time Customer")
                {
                    ApplicationArea = all;

                }
                field("Store Information"; Rec."Store Information")
                {
                    ApplicationArea = all;
                    MultiLine = true;

                }
                field("Working Hours"; Rec."Working Hours")
                {
                    ApplicationArea = all;
                    MultiLine = true;

                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = all;
                    LookupPageId = "Delivery Zone List";

                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = all;
                    LookupPageId = "Sales Area List";

                }
                field(Accpac; Rec.Accpac)
                {
                    ApplicationArea = all;
                    LookupPageId = "Accpac List";
                    Visible = false;
                }
                field("Biz Registration Type"; Rec."Biz Registration Type")
                {
                    ApplicationArea = all;

                }
                field("Sales Rep (HYP)"; Rec."Corporate  Sales Rep (HYP)")
                {
                    ApplicationArea = all;

                }
                field("Sales Rep (WS)"; Rec."Corporate  Sales Rep (WS)")
                {
                    ApplicationArea = all;

                }
                field("Sales Rep (HB)"; Rec."Corporate  Sales Rep (HB)")
                {
                    ApplicationArea = all;
                }
                field("Sales Rep (4)"; Rec."Corporate  Sales Rep (4)")
                {
                    ApplicationArea = all;
                    caption = 'Corporate Sales Rep (DIY)';
                }
                field("Sales Rep (OH)"; Rec."Corporate  Sales Rep (5)")
                {
                    ApplicationArea = all;
                    Caption = 'Corporate Sales Rep (OH)';
                }
                field("Corporate  Sales Rep (AP)"; Rec."Corporate  Sales Rep (AP)")
                {
                    ApplicationArea = all;
                    Caption = 'Corporate Sales Rep (AP)';
                    Visible = FieldVisible1;
                }
                field("Customer Commission Group"; Rec."Customer Commission Group")
                {
                    ApplicationArea = All;
                }
                field(I9G_ShowRefNo; Rec.I9G_ShowRefNo)
                {
                    ApplicationArea = all;
                }
                field(SystemId; Rec.SystemId)
                {
                    applicationarea = all;
                    editable = false;

                }
            }

            //DX        18 Sept 2021
            group(Pharmacist)
            {
                field("MOH License No."; Rec."MOH License No.")
                {
                    ApplicationArea = all;
                }
            }
            //DX        18 Sept 2021
        }

        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes
        addafter(Blocked)
        {
            field("Customer Sales Classification"; Rec."Customer Sales Classification")
            {
                ApplicationArea = All;
            }
            //DX        31 Jan 2025
            field(I9G_PriceExtLeadTime; Rec.I9G_PriceExtLeadTime)
            {
                ApplicationArea = all;
            }
            //DX        31 Jan 2025
            // YF 27 Oct 2021
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
            }
            // YF 27 Oct 2021

            // YF 12 Nov 2021
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            // YF 12 Nov 2021

            // YF 18 Nov 2021
            field("Last DateTime Modified"; Rec."Last Modified Date Time")
            {
                ApplicationArea = All;
            }
            // YF 18 Nov 2021

            //PK
            field(I9G_Sector; Rec.I9G_Sector)
            {
                ApplicationArea = All;
            }
            field(I9G_Channel; Rec.I9G_Channel)
            {
                ApplicationArea = All;
            }
            //PK
            //KP 25 Feb 2025 - Auto Invoice Email
            field(I9G_AutoEmailInvoice; Rec.I9G_AutoEmailInvoice)
            {
                ApplicationArea = All;
            }
            field(I9G_AutoEmailInvEmailAddress; Rec.I9G_AutoEmailInvEmailAddress)
            {
                ApplicationArea = All;
            }
            //KP 25 Feb 2025 - Auto Invoice Email

        }
        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes

        addbefore("Responsibility Center")
        {
            field("Web User Email"; Rec."Web User Email")
            {
                ApplicationArea = All;
            }
            field(I9G_EmailonPriceChg; Rec.I9G_EmailonPriceChg)
            {
                ApplicationArea = All;
            }
        }
        modify("VAT Registration No.")
        {
            Caption = 'Bus. Registration No.';
        }

        addafter("Credit Limit (LCY)")
        {
            field("Credit Insurance"; Rec."Credit Insurance")
            {
                ApplicationArea = All;
            }

            field("Insurance Coverage"; Rec."Insurance Coverage")
            {
                ApplicationArea = All;
            }

            field("Coverage Date"; Rec."Coverage Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Prices Including VAT")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
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
                ShowMandatory = True;
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
        modify("Gen. Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Customer Posting Group")
        {
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Customer Price Group")
        {
            ShowMandatory = True;
        }


    }

    actions
    {
        // Add changes to page actions here
        addafter(Documents)
        {
            group("Details")
            {

                action("Delivery Schedules")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Delivery Schedule";
                    RunPageLink = "Cust No." = field("No.");
                }
                Action("Specialities")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Specialties";
                    RunPageLink = "Cust No." = field("No.");
                }
                Action("Customer Exception List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Customer Exceptions Order";
                    RunPageLink = "Cust No." = field("No.");
                }
                Action("Blocked Cust-Item List")
                {
                    ApplicationArea = All;
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Block Cust-Item";
                    RunPageLink = "Cust No." = field("No.");
                }
                action("Sales Trade Agreements")
                {
                    ApplicationArea = All;
                    Image = Create;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    // RunObject = page PharmaSalesPriceList;
                    // RunPageLink = "Sales Code" = field("No."|"Bill-to Customer No.");
                    trigger OnAction()
                    var
                        STA: Record "Pharma Sales Price";
                    begin
                        Clear(STA);
                        STA.SetFilter(STA."Sales Code", '%1|%2|%3', Rec."No.", Rec."Bill-to Customer No.", Rec."Customer Price Group");
                        Page.Run(Page::PharmaSalesPriceList, STA);

                    end;
                }
                action("Sales Trade Agreement Staging")
                {
                    ApplicationArea = All;
                    Image = Create;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        STA: Record "Sales Trade Agreement Staging";
                    begin
                        Clear(STA);
                        STA.SetFilter(STA."Sales Code", '%1|%2|%3', Rec."No.", Rec."Bill-to Customer No.", Rec."Customer Price Group");
                        Page.Run(Page::SalesTradeAgreementStaging, STA);

                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
        FieldVisible1: Boolean;

    trigger OnOpenPage()
    var
        Company: Record Company;
        CompanyInfo: Record "Company Information";
    begin
        //LK10May2024
        FieldVisible1 := false;

        CompanyInfo.Reset();
        CompanyInfo.get();
        if (CompanyInfo.Name = 'Ardence Pharma Sdn Bhd') or (CompanyInfo.Name = 'ARDENCE PHARMA SDN BHD') then begin
            FieldVisible1 := true;
        end;
        //LK10May2024
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CompanyName = 'PMP' then begin // YF 18 Nov 2021
            if Rec."No." <> '' then begin
                if (Rec."Customer Group" = '') then begin
                    Message('Customer Group needs to be entered');
                    exit(false);
                end;
                if (Rec."Delivery Charge" = '') then begin
                    Message('Delivery Charge needs to be entered');
                    exit(false);

                end;
                if (Rec."Customer Price Group" = '') then begin
                    Message('Customer Price Group needs to be entered');
                    exit(false);

                end;
            end;
        end;
        if Rec."No." <> '' then begin
            if (Rec.ShortcutDim6Code = '') then begin
                Message('Geographical Code needs to be entered');
                exit(false);
            end;
        end;

        exit(true);
    end;

}