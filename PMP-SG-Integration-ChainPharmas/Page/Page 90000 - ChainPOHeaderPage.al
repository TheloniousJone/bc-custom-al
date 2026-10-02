page 90000 "Chain PO Header"
{

    ApplicationArea = All;
    Caption = 'Chain Staging Header';
    PageType = List;
    SourceTable = "Chain PO Header";
    UsageCategory = Lists;
    ModifyAllowed = true;

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
                field("Store Fox Quantity "; Rec."Store FOC Quantity")
                {
                    ToolTip = 'Specifies the value of the Store FOC Quantity  field';
                    ApplicationArea = All;
                }
                field(ChainPOHeaderTimestamp; Rec.ChainPOHeaderTimestamp)
                {
                    ToolTip = 'Specifies the value of the ChainPOHeaderTimestamp field';
                    ApplicationArea = All;
                }
                field("Ready to Process SO"; Rec."Ready to Process SO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ready to Process SO field.';
                }
                field("Push to Open SO"; Rec."Push to Open SO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Push to Open SO field.';
                }

                field("SO Created"; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created field';
                    ApplicationArea = All;
                }
                field("SO Error"; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error field';
                    ApplicationArea = All;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                }
                field("Last Error Message"; Rec."Last Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Error Message field.', Comment = '%';
                }
            }
        }
    }


    actions
    {
        area(navigation)
        {
            group(Reports)
            {
                Caption = 'Report';
                Image = Report;
                action("Create Sales Order")
                {
                    ApplicationArea = all;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    Visible = false;

                    trigger OnAction()
                    var
                        POheaderrec: Record "Chain PO Header";
                    begin
                        POheaderrec := Rec;
                        CurrPage.SetSelectionFilter(POheaderrec);
                        // Report.RunModal(70103, true, false, POheaderrec);
                        Report.RunModal(90000, true, false, POheaderrec);
                    end;
                }
            }

        }

        area(Creation)
        {
            action("Generate Sales Order V2")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    ChainPharmaCU: Codeunit ChainPharmaCU;
                    ChainPOHeader: Record "Chain PO Header";
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
        }
    }


}
