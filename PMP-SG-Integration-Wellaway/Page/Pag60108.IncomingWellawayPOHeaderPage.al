page 60108 "Incoming Wellaway PO Headers"
{

    ApplicationArea = All;
    Caption = 'Incoming Wellaway Staging Orders';
    PageType = List;
    SourceTable = "Incoming Wellaway PO Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Order ID"; Rec."Purchase Order ID")
                {
                    ToolTip = 'Specifies the value of the Purchase Order ID field';
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field';
                    ApplicationArea = All;
                }
                field("Physical PO ID"; Rec."Physical PO ID")
                {
                    ToolTip = 'Specifies the value of the Physical PO ID field';
                    ApplicationArea = All;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field';
                    ApplicationArea = All;
                }
                field("Login ID"; Rec."Login ID")
                {
                    ToolTip = 'Specifies the value of the Login ID field';
                    ApplicationArea = All;
                }
                field("Order by "; Rec."Order by")
                {
                    ToolTip = 'Specifies the value of the Order by  field';
                    ApplicationArea = All;
                }
                field("Currency "; Rec."Currency")
                {
                    ToolTip = 'Specifies the value of the Currency  field';
                    ApplicationArea = All;
                }
                field("Terms of Payment "; Rec."Terms of Payment")
                {
                    ToolTip = 'Specifies the value of the Terms of Payment  field';
                    ApplicationArea = All;
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ToolTip = 'Specifies the value of the Contact Person field';
                    ApplicationArea = All;
                }
                field("Street Name"; Rec."Street Name")
                {
                    ToolTip = 'Specifies the value of the Street Name field';
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
                field(Fax; Rec.Fax)
                {
                    ToolTip = 'Specifies the value of the Fax field';
                    ApplicationArea = All;
                }
                field("Online Discount Amount"; Rec."Online Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Online Discount Amount field';
                    ApplicationArea = All;
                }
                field("Online Discount Percent"; Rec."Online Discount Percent")
                {
                    ToolTip = 'Specifies the value of the Online Discount Percent field';
                    ApplicationArea = All;
                }
                field("Remarks 1 "; Rec."Remarks 1")
                {
                    ToolTip = 'Specifies the value of the Remarks 1  field';
                    ApplicationArea = All;
                }
                field("Order Date "; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date  field';
                    ApplicationArea = All;
                }
                field("Patient Date of Birth"; Rec."Patient Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Patient Date of Birth field';
                    ApplicationArea = All;
                }
                field("Patient Gender"; Rec."Patient Gender")
                {
                    ToolTip = 'Specifies the value of the Patient Gender field';
                    ApplicationArea = All;
                }
                field("Patient NRIC/FIN/Passport No."; Rec."Patient NRIC/FIN/Passport No.")
                {
                    ToolTip = 'Specifies the value of the Patient NRIC/FIN/Passport No. field';
                    ApplicationArea = All;
                }
                field("Drug Allergies "; Rec."Drug Allergies")
                {
                    ToolTip = 'Specifies the value of the Drug Allergies  field';
                    ApplicationArea = All;
                }
                field("Clinic ID"; Rec."Clinic ID")
                {
                    ToolTip = 'Specifies the value of the Clinic ID field';
                    ApplicationArea = All;
                }
                field("Clinic Full Name"; Rec."Clinic Full Name")
                {
                    ToolTip = 'Specifies the value of the Clinic Full Name field';
                    ApplicationArea = All;
                }
                field("Clinic Branch"; Rec."Clinic Branch")
                {
                    ToolTip = 'Specifies the value of the Clinic Branch field';
                    ApplicationArea = All;
                }
                field("Clinic Address Line 1 "; Rec."Clinic Address Line 1")
                {
                    ToolTip = 'Specifies the value of the Clinic Address Line 1  field';
                    ApplicationArea = All;
                }
                field("Clinic Address Line 2"; Rec."Clinic Address Line 2")
                {
                    ToolTip = 'Specifies the value of the Clinic Address Line 2 field';
                    ApplicationArea = All;
                }
                field("Clinic Postal Code"; Rec."Clinic Postal Code")
                {
                    ToolTip = 'Specifies the value of the Clinic Postal Code field';
                    ApplicationArea = All;
                }
                field("Clinic Country "; Rec."Clinic Country")
                {
                    ToolTip = 'Specifies the value of the Clinic Country  field';
                    ApplicationArea = All;
                }
                field("Doctor Full Name"; Rec."Doctor Full Name")
                {
                    ToolTip = 'Specifies the value of the Doctor Full Name field';
                    ApplicationArea = All;
                }
                field("Doctor Mobile Country Code"; Rec."Doctor Mobile Country Code")
                {
                    ToolTip = 'Specifies the value of the Doctor Mobile Country Code field';
                    ApplicationArea = All;
                }
                field("Doctor Mobile No."; Rec."Doctor Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Doctor Mobile No. field';
                    ApplicationArea = All;
                }
                field("Remarks 2"; Rec."Remarks 2")
                {
                    ToolTip = 'Specifies the value of the Remarks 2 field';
                    ApplicationArea = All;
                }
                field(POHeaderTimestamp; Rec.POHeaderTimestamp)
                {
                    ToolTip = 'Specifies the value of the Timestamp field';
                    ApplicationArea = All;
                }
                field("SO Created"; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created field';
                    ApplicationArea = All;
                }
                field("SO Error "; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error  field';
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
            }

            // part(POLine; 70104)
            // {
            //     ApplicationArea = Basic, Suite;
            //     SubPageLink = "purchase order id" = FIELD("Purchase Order ID");
            //     UpdatePropagation = Both;
            // }

        }


    }

    actions
    {
        area(Processing)
        {
            action("Generate Sales Order")
            {
                ApplicationArea = All;
                // ShortcutKey = "Ctrl+Shift+P";
                Image = CreateDocument;
                RunObject = report "Wellaway SO Creation";

                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }

}
