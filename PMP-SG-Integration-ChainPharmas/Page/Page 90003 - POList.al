page 90003 "Chain Pharma. PO List"
{

    ApplicationArea = Basic, Suite;
    Caption = 'Chain Pharma. Purchase Order Staging List';
    PageType = List;
    CardPageId = "Chain Pharma PO Page";
    SourceTable = "Chain PO Header";
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Chain; Rec.Chain)
                {
                    ToolTip = 'Specifies the value of the Chain field';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                }
                field("Invoice Number "; Rec."Invoice Number")
                {
                    ToolTip = 'Specifies the value of the Invoice Number  field';
                    ApplicationArea = All;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field';
                    ApplicationArea = All;
                }
                field("PO Number"; Rec."PO Number")
                {
                    ToolTip = 'Specifies the value of the PO Number field';
                    ApplicationArea = All;
                }
                field("PO Date"; Rec."PO Date")
                {
                    ToolTip = 'Specifies the value of the PO Date field';
                    ApplicationArea = All;
                }
                field("DO Number "; Rec."DO Number")
                {
                    ToolTip = 'Specifies the value of the DO Number  field';
                    ApplicationArea = All;
                }
                field("DO Date"; Rec."DO Date")
                {
                    ToolTip = 'Specifies the value of the DO Date field';
                    ApplicationArea = All;
                }
                field("Delivery Start Date"; Rec."Delivery Start Date")
                {
                    ToolTip = 'Specifies the value of the Delivery Start Date field';
                    ApplicationArea = All;
                }
                field("Delivery End Date"; Rec."Delivery End Date")
                {
                    ToolTip = 'Specifies the value of the Delivery End Date field';
                    ApplicationArea = All;
                }
                field("Buyer Code"; Rec."Buyer Code")
                {
                    ToolTip = 'Specifies the value of the Buyer Code field';
                    ApplicationArea = All;
                }
                field("Buyer Name"; Rec."Buyer Name")
                {
                    ToolTip = 'Specifies the value of the Buyer Name field';
                    ApplicationArea = All;
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                    ToolTip = 'Specifies the value of the Supplier Code field';
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field';
                    ApplicationArea = All;
                }
                field("Line Item Count "; Rec."Line Item Count")
                {
                    ToolTip = 'Specifies the value of the Line Item Count  field';
                    ApplicationArea = All;
                }
                field("Invoice Amount Without Tax"; Rec."Invoice Amount Without Tax")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount Without Tax field';
                    ApplicationArea = All;
                }
                field("Invoice Amount With Tax "; Rec."Invoice Amount With Tax")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount With Tax  field';
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Tax Amount field';
                    ApplicationArea = All;
                }
                field("Tax Percent "; Rec."Tax Percent")
                {
                    ToolTip = 'Specifies the value of the Tax Percent  field';
                    ApplicationArea = All;
                }
                field("Store Code"; Rec."Store Code")
                {
                    ToolTip = 'Specifies the value of the Store Code field';
                    ApplicationArea = All;
                }
                field("Store Name"; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store Name field';
                    ApplicationArea = All;
                }
                field("Store Delivery Quantity"; Rec."Store Delivery Quantity")
                {
                    ToolTip = 'Specifies the value of the Store Delivery Quantity field';
                    ApplicationArea = All;
                }
                field("Store FOC Quantity "; Rec."Store FOC Quantity")
                {
                    ToolTip = 'Specifies the value of the Store FOC Quantity  field';
                    ApplicationArea = All;
                }
                field(ChainPOHeaderTimestamp; Rec.ChainPOHeaderTimestamp)
                {
                    ToolTip = 'Specifies the value of the ChainPOHeaderTimestamp field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ready to Process SO"; Rec."Ready to Process SO")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Ready to Process SO field.';
                }
                field("Push to Open SO"; Rec."Push to Open SO")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Push to Open SO field.';
                }

                field("SO Created"; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SO Error"; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
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
                field("Last Error Message"; Rec."Last Error Message")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Last Error Message field.', Comment = '%';
                }
            }
        }
    }
    actions
    {

        area(Processing)
        {
            action("Import Guardian PO Headers")
            {
                ApplicationArea = All;
                Caption = 'Import Guardian PO XML';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                begin
                    ChainPharmaCU.ImportChainGuardianPOXML();
                end;
            }

            action("Import Watson PO Headers")
            {
                ApplicationArea = All;
                Caption = 'Import Watson PO XML';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                begin
                    ChainPharmaCU.ImportChainWatsonPOXML();
                end;
            }

            action("Import NTUC PO Headers")
            {
                ApplicationArea = All;
                Caption = 'Import NTUC PO XML';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                begin
                    ChainPharmaCU.ImportChainNTUCPOXML();
                end;
            }

            action("Import PO XML")
            {
                ApplicationArea = All;
                Caption = 'Import PO XML';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                begin
                    ChainPharmaCU.ImportChainPOXML();
                end;
            }
        }

        area(navigation)
        {
            group(Reports)
            {
                Caption = 'Report';
                Image = Report;
                action("Create SO")
                {
                    ApplicationArea = all;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    Visible = false;

                    trigger OnAction()
                    var
                        ChainPOheaderrec: Record "Chain PO Header";
                    begin
                        ChainPOheaderrec := Rec;
                        CurrPage.SetSelectionFilter(ChainPOheaderrec);
                        Report.RunModal(90000, true, false, ChainPOheaderrec);
                    end;
                }
            }

        }

        area(Creation)
        {
            action("Generate Sales Order V2")
            {
                ApplicationArea = all;
                Caption = 'Create Documents [OLD]';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;
                InFooterBar = true;
                Visible = false;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                    ChainPOHeader: Record "Chain PO Header";
                    RecordCounter: Integer;
                begin
                    if Confirm('Are you sure you wish to create sales orders?') then begin
                        CurrPage.SetSelectionFilter(ChainPOHeader);
                        if ChainPOHeader.FindSet() then
                            repeat
                                ChainPharmaCU.CreateOrder(ChainPOHeader."Entry No.", ChainPOHeader.Chain, ChainPOHeader."PO Number");
                            until ChainPOHeader.Next = 0;
                        if ChainPharmaCU.NoOfOrdersCreated() + ChainPharmaCU.NoOfLinesCreated() <> 0 then
                            Message(StrSubstNo('%1 orders created, %2 Lines Created/Updated.', ChainPharmaCU.NoOfOrdersCreated(), ChainPharmaCU.NoOfLinesCreated()));
                    end;
                end;
            }

            action("Generate Sales Order V3")
            {
                ApplicationArea = all;
                Caption = 'Create Documents';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;
                InFooterBar = true;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                    ChainPOHeader: Record "Chain PO Header";
                    RecordCounter: Integer;
                begin
                    // Updated Implementation // YF 27 Sep 2021
                    CurrPage.SetSelectionFilter(ChainPOHeader);

                    if ChainPOHeader.Count <> 0 then begin
                        if Confirm('Are you sure you wish to create documents from Chain Purchase Order(s)?') then begin
                            if ChainPOHeader.FindSet() then
                                repeat

                                    ClearLastError();

                                    If ChainPharmaCU.ValidatePOInfo(ChainPOHeader.Chain, ChainPOHeader."PO Number") then begin
                                        ChainPharmaCU.CreateOrder(ChainPOHeader."Entry No.", ChainPOHeader.Chain, ChainPOHeader."PO Number");
                                        RecordCounter += 1;
                                    end
                                    else begin
                                        // Update Staging PO Header
                                        if (ChainPOHeader."SO Created" = false) And (ChainPOHeader."Sales Order No." = '') then begin
                                            ChainPOHeader."SO Error" := true;
                                            ChainPOHeader."Process Remarks" := GetLastErrorText();
                                            ChainPOHeader."Last Error Message" := GetLastErrorText();
                                            ChainPOHeader.Modify();
                                        end;

                                        Error(Format(GetLastErrorText()));
                                    end;

                                until ChainPOHeader.next = 0;

                            if RecordCounter <> 0 then
                                Message('%1 Transactions created', RecordCounter);
                        end;
                    end
                    else begin
                        Message('Please select the records that you will like to create.');
                    end;

                end;
            }
        }
    }

}
