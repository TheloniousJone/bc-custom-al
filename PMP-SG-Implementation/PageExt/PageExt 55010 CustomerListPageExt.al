pageextension 55010 CustomerListPageExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            // CL 23 July 2024
            field("Delivery Charges"; Rec."Delivery Charge")
            {
                ApplicationArea = all;
            }
            // CL 23 July 2024
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = all;
            }
            //PK 25 Oct 2024
            field("Working Hours"; Rec."Working Hours")
            {
                ApplicationArea = all;
            }
            //PK 25 Oct 2024

            // YF 09 Feb 2022
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                LookupPageId = "Customer Group List";
            }
            // YF 09 Feb 2022
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Address 2"; rec."Address 2")
            {
                ApplicationArea = all;
            }

            field(City; rec.City)
            {
                ApplicationArea = all;
            }

            field("Status Remarks"; Rec."Status Remarks")
            {
                ApplicationArea = all;

            }
            field("Status Date"; Rec."Status Date")
            {
                ApplicationArea = all;
            }
            field("WS Membership"; Rec."WS Membership")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(I9G_RequirementApproval; Rec.I9G_RequirementApproval)
            {
                ApplicationArea = all;
            }

        }
        addafter("Payments (LCY)")
        {
            field("Corporate  Sales Rep (WS)"; Rec."Corporate  Sales Rep (WS)")
            {
                ApplicationArea = all;
            }
            field("Corporate  Sales Rep (HB)"; Rec."Corporate  Sales Rep (HB)")
            {
                ApplicationArea = all;
            }
            field("Corporate  Sales Rep (HYP)"; Rec."Corporate  Sales Rep (HYP)")
            {
                ApplicationArea = all;
            }
            field("Corporate  Sales Rep (4)"; Rec."Corporate  Sales Rep (4)")
            {
                ApplicationArea = all;
                Caption = 'Corporate Sales Rep (DIY)';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("POM Customer"; Rec."POM Customer")
            {
                ApplicationArea = all;
            }

            // YF 19 Nov 2021
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
            // YF 19 Nov 2021
            field("Bill Name"; Rec."Bill Name")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Bill Contact"; Rec."Bill Contact")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill Contact field';
            }
            //RL05052023 - Start
            field("Delivery Zone"; Rec."Delivery Zone")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Zone field';
            }
            field("Wellaway Customer"; Rec."Wellaway Customer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Wellaway Customer field';
            }
            field("E-Invoicing"; Rec."E-Invoicing")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Invoicing field';
            }
            //RL05052023 - End
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(General)
        {
            action("RPA Customer Card")
            {
                //DX        25 Aug 2021
                ApplicationArea = All;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page RPACustCard;
                //DX        25 Aug 2021
            }
            action("TBA List")
            {
                ApplicationArea = All;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "TBA Ledger Entry";
                trigger OnAction()
                begin

                end;
            }
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
            action("Customer Statment - Open")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CustRec: Record Customer;
                begin
                    CurrPage.SetSelectionFilter(CustRec);
                    report.Run(57042, true, true, CustRec);
                end;
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

    var
        EnhanceCU: Codeunit "PMP-Enhancements";

}