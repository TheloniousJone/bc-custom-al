page 59004 POM2Order
{

    Caption = 'POM2 Staging Order';
    PageType = Card;
    SourceTable = POM2HeaderTbl;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PurchaseOrderID; Rec.PurchaseOrderID)
                {
                    ToolTip = 'Specifies the value of the PurchaseOrderID field';
                    ApplicationArea = All;
                }
                field(PhysicalPOID; Rec.PhysicalPOID)
                {
                    ToolTip = 'Specifies the value of the PhysicalPOID field';
                    ApplicationArea = All;
                }
                field(TransactionDate; Rec.TransactionDate)
                {
                    ToolTip = 'Specifies the value of the TransactionDate field';
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
                field("Terms Of Payment"; Rec."Terms Of Payment")
                {
                    ToolTip = 'Specifies the value of the Terms Of Payment field';
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the value of the Telephone field';
                    ApplicationArea = All;
                }
                field(Fax; Rec.Fax)
                {
                    ToolTip = 'Specifies the value of the Fax field';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field';
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field';
                    ApplicationArea = All;
                }
                field(ContactPerson; Rec.ContactPerson)
                {
                    ToolTip = 'Specifies the value of the ContactPerson field';
                    ApplicationArea = All;
                }
                field(Created; Rec.Created)
                {
                    ToolTip = 'Specifies the value of the Created field';
                    ApplicationArea = All;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ToolTip = 'Specifies the value of the Country/Region field';
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
                field(StreetName; Rec.StreetName)
                {
                    ToolTip = 'Specifies the value of the StreetName field';
                    ApplicationArea = All;
                }
                field("Zip Code"; Rec."Zip Code")
                {
                    ToolTip = 'Specifies the value of the Zip Code field';
                    ApplicationArea = All;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ToolTip = 'Specifies the value of the Process Remarks field';
                    ApplicationArea = All;
                }
            }
            group(Information)
            {
                part(Details; POM2SubForm)
                {
                    ApplicationArea = all;
                    Editable = false;
                    SubPageLink = PurchaseOrderID = field(PurchaseOrderID);
                }
            }
        }
    }

}
