page 59001 "POM2 Order List"
{

    ApplicationArea = All;
    Caption = 'POM2 Staging Order List';
    PageType = List;
    SourceTable = POM2HeaderTbl;

    UsageCategory = Lists;
    Editable = true;
    CardPageId = POM2Order;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(PurchaseOrderID; Rec.PurchaseOrderID)
                {
                    ToolTip = 'Specifies the value of the PurchaseOrderID field';
                    ApplicationArea = All;
                }
                field("Customer Account"; Rec."Customer Account")
                {
                    ToolTip = 'Specifies the value of the Customer Account field';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field';
                    ApplicationArea = All;
                }
                field(LoginID; Rec.LoginID)
                {
                    ToolTip = 'Specifies the value of the lOGINid field';
                    ApplicationArea = All;
                }
                field(OrderBy; Rec.OrderBy)
                {
                    ToolTip = 'Specifies the value of the OrderBy field';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field';
                    ApplicationArea = All;
                }
                field("Terms Of Payment"; Rec."Terms Of Payment")
                {
                    ToolTip = 'Specifies the value of the Terms Of Payment field';
                    ApplicationArea = All;
                }
                field(ContactPerson; Rec.ContactPerson)
                {
                    ToolTip = 'Specifies the value of the ContactPerson field';
                    ApplicationArea = All;
                }
                field(StreetName; Rec.StreetName)
                {
                    ToolTip = 'Specifies the value of the StreetName field';
                    ApplicationArea = All;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ToolTip = 'Specifies the value of the Country/Region field';
                    ApplicationArea = All;
                }
                field("Zip Code"; Rec."Zip Code")
                {
                    ToolTip = 'Specifies the value of the Zip Code field';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field';
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the value of the Telephone field';
                    ApplicationArea = All;
                }
                field(TransactionDate; Rec.TransactionDate)
                {
                    ToolTip = 'Specifies the value of the TransactionDate field';
                    ApplicationArea = All;
                }
                field(PhysicalPOID; Rec.PhysicalPOID)
                {
                    ToolTip = 'Specifies the value of the PhysicalPOID field';
                    ApplicationArea = All;
                }
                field(Fax; Rec.Fax)
                {
                    ToolTip = 'Specifies the value of the Fax field';
                    ApplicationArea = All;
                }
                field(OnlineDiscountAmount; Rec.OnlineDiscountAmount)
                {
                    ToolTip = 'Specifies the value of the OnlineDiscountAmount field';
                    ApplicationArea = All;
                }
                field(OnlineDiscountPercent; Rec.OnlineDiscountPercent)
                {
                    ToolTip = 'Specifies the value of the OnlineDiscountPercent field';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    ApplicationArea = All;
                }
                field(Created; Rec.Created)
                {
                    ToolTip = 'Specifies the value of the Created field';
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ToolTip = 'Specifies the value of the Process Remarks field';
                    ApplicationArea = All;
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = all;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Creation)
        {
            action("Generate Order")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    myInt: Integer;
                    POMCU: Codeunit POM2;
                begin
                    if Confirm('Are you sure you wish to create orders?') then begin
                        CurrPage.SetSelectionFilter(POMRec);
                        if POMRec.FindSet() then
                            repeat
                                POMCU.CreateOrder(POMRec.PurchaseOrderID);
                            until POMRec.next = 0;
                        if POMCU.NoOfOrdersCreated() + POMCU.NoOfLinesCreated() <> 0 then
                            Message(StrSubstNo('%1 orders created, %2 Lines Created/Updated.', POMCU.NoOfOrdersCreated(), POMCU.NoOfLinesCreated()));
                    end;

                end;
            }
        }

        area(Processing)
        {
            action("Import Headers XMLPort")
            {
                ApplicationArea = All;
                Caption = 'Import Headers via XMLPort';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Import POM PO Header", false, true);
                end;
            }

            action("Import Lines XMLPort")
            {
                ApplicationArea = All;
                Caption = 'Import Lines via XMLPort';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Import POM PO Line", false, true);
                end;
            }
            action("Import Headers")
            {
                ApplicationArea = All;
                Caption = 'Import Headers';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    POMCU: Codeunit POM2;
                begin
                    POMCU.ImportPOMPOHeader();
                end;
            }

            action("Import Lines")
            {
                ApplicationArea = All;
                Caption = 'Import Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    POMCU: Codeunit POM2;
                begin
                    POMCU.ImportPOMPOLine();
                end;
            }

            action("Create")
            {
                ApplicationArea = All;
                Caption = 'Create Documents';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;
                InFooterBar = true;

                trigger OnAction()
                var
                    POMCU: Codeunit POM2;
                begin
                    if Confirm('Are you sure you wish to create orders?') then begin
                        CurrPage.SetSelectionFilter(POMRec);
                        if POMRec.FindSet() then
                            repeat
                                POMCU.CreateOrder(POMRec.PurchaseOrderID);
                            until POMRec.next = 0;
                        if POMCU.NoOfOrdersCreated() + POMCU.NoOfLinesCreated() <> 0 then
                            Message(StrSubstNo('%1 orders created, %2 Lines Created/Updated.', POMCU.NoOfOrdersCreated(), POMCU.NoOfLinesCreated()));
                    end;
                end;
            }
        }
    }
    var
        POMRec: Record POM2HeaderTbl;
}
