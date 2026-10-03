page 59002 "POM2 Detail List"
{

    ApplicationArea = All;
    Caption = 'POM2 Staging Detail List';
    PageType = List;
    SourceTable = POM2DetailsTbl;
    UsageCategory = Lists;

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
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field';
                    ApplicationArea = All;
                }
                field(QuantityOrdered; Rec.QuantityOrdered)
                {
                    ToolTip = 'Specifies the value of the QuantityOrdered field';
                    ApplicationArea = All;
                }
                field(BonusQuantity; Rec.BonusQuantity)
                {
                    ToolTip = 'Specifies the value of the BonusQuantity field';
                    ApplicationArea = All;
                }
                field(UnitPrice; Rec.UnitPrice)
                {
                    ToolTip = 'Specifies the value of the UnitPrice field';
                    ApplicationArea = All;
                }
                field(UOMCode; Rec.UOMCode)
                {
                    ToolTip = 'Specifies the value of the UOMCode field';
                    ApplicationArea = All;
                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ToolTip = 'Specifies the value of the ExpiryDate field';
                    ApplicationArea = All;
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ToolTip = 'Specifies the value of the Doc No. field';
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
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
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
                    PomRec: Record POM2HeaderTbl;
                    PomLine: Record POM2DetailsTbl;
                begin
                    if Confirm('Are you sure you wish to create orders?') then begin
                        CurrPage.SetSelectionFilter(PomLine);
                        if PomLine.Count <> 1 then
                            Error('Please select one row only to create for the whole PO ID.');
                        PomRec.reset;
                        PomRec.SetRange(PurchaseOrderID, Rec.PurchaseOrderID);
                        if POMRec.Findfirst() then begin
                            POMCU.CreateOrder(POMRec.PurchaseOrderID);
                        end;
                        if POMCU.NoOfOrdersCreated() + POMCU.NoOfLinesCreated() <> 0 then
                            Message(StrSubstNo('%1 orders created, %2 Lines Created/Updated.', POMCU.NoOfOrdersCreated(), POMCU.NoOfLinesCreated()));
                    end;

                end;
            }
        }

    }

}
