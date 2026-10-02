page 55066 RPACustCard
{

    Caption = 'RPACustCard';
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ToolTip = 'Specifies the value of the Credit Limit (LCY) field';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field';
                    ApplicationArea = All;
                }
            }
            group(Additional)
            {
                field("Bill Address"; Rec."Bill Address") // YF 08 Sep 2023 // remove trailing spaces
                {
                    ToolTip = 'Specifies the value of the Bill Address  field';
                    ApplicationArea = All;
                }
                field("Bill Address 2"; Rec."Bill Address 2")
                {
                    ToolTip = 'Specifies the value of the Bill Address 2 field';
                    ApplicationArea = All;
                }
                field("Bill City"; Rec."Bill City")
                {
                    ToolTip = 'Specifies the value of the Bill City field';
                    ApplicationArea = All;
                }
                field("Bill Contact"; Rec."Bill Contact")
                {
                    ToolTip = 'Specifies the value of the Bill Contact field';
                    ApplicationArea = All;
                }
                field("Bill Country Code"; Rec."Bill Country Code")
                {
                    ToolTip = 'Specifies the value of the Bill Country Code field';
                    ApplicationArea = All;
                }
                field("Bill County"; Rec."Bill County")
                {
                    ToolTip = 'Specifies the value of the Bill County field';
                    ApplicationArea = All;
                }
                field("Bill Name"; Rec."Bill Name")
                {
                    ToolTip = 'Specifies the value of the Bill Name field';
                    ApplicationArea = All;
                }
                field("Bill Name 2"; Rec."Bill Name 2")
                {
                    ToolTip = 'Specifies the value of the Bill Name 2 field';
                    ApplicationArea = All;
                }
                field("Bill Post Code"; Rec."Bill Post Code")
                {
                    ToolTip = 'Specifies the value of the Bill Post Code field';
                    ApplicationArea = All;
                }
                field("Mandatory Ext Doc. No."; Rec."Mandatory Ext Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Mandatory Ext Doc. No. field';
                    ApplicationArea = All;
                }
                field("E-Invoicing"; Rec."E-Invoicing")
                {
                    ToolTip = 'Specifies the value of the E-Invoicing field';
                    ApplicationArea = All;
                }
                field("Customer Instructions"; Rec."Customer Instructions")
                {
                    ToolTip = 'Specifies the value of the Customer Instructions field';
                    ApplicationArea = All;
                }
                field("Delivery Instructions"; Rec."Delivery Instructions")
                {
                    ToolTip = 'Specifies the value of the Delivery Instructions field';
                    ApplicationArea = All;
                }
                field("POM Customer"; Rec."POM Customer")
                {
                    ToolTip = 'Specifies the value of the POM Customer field';
                    ApplicationArea = All;
                }
                field("Wellaway Customer"; Rec."Wellaway Customer")
                {
                    ToolTip = 'Specifies the value of the Wellaway Customer field';
                    ApplicationArea = All;
                }
                field("Logistics Service"; Rec."Logistics Service")
                {
                    ToolTip = 'Specifies the value of the Logistics Service field';
                    ApplicationArea = All;
                }
                field("LS Percentage"; Rec."LS Percentage")
                {
                    ToolTip = 'Specifies the value of the Logistics Service % calculation. field';
                    ApplicationArea = All;
                }
                field("Customer Status"; Rec."Customer Status")
                {
                    ToolTip = 'Specifies the value of the Customer Status field';
                    ApplicationArea = All;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ToolTip = 'Specifies the value of the Status Date field';
                    ApplicationArea = All;
                }
                field("Status Remarks"; Rec."Status Remarks")
                {
                    ToolTip = 'Specifies the value of the Status Remarks field';
                    ApplicationArea = All;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ToolTip = 'Specifies the value of the Delivery Charge field';
                    ApplicationArea = All;
                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ToolTip = 'Specifies the value of the Delivery Zone field';
                    ApplicationArea = All;
                }
                field("Commercial Permission Group"; Rec."Commercial Permission Group")
                {
                    ToolTip = 'Specifies the value of the Commercial Permission Group field';
                    ApplicationArea = All;
                }
                field("Forensic Permmission Group"; Rec."Forensic Permmission Group")
                {
                    ToolTip = 'Specifies the value of the Forensic Permmission Group field';
                    ApplicationArea = All;
                }
            }
            group(Information)
            {
                field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
                {
                    ToolTip = 'Specifies the value of the Branch/Subsidiary field';
                    ApplicationArea = All;
                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ToolTip = 'Specifies the value of the Customer Group field';
                    ApplicationArea = All;
                }
                field("One-time Customer"; Rec."One-time Customer")
                {
                    ToolTip = 'Specifies the value of the One-time Customer field';
                    ApplicationArea = All;
                }
                field("Store Information"; Rec."Store Information")
                {
                    ToolTip = 'Specifies the value of the Store Information field';
                    ApplicationArea = All;
                }
                field("Working Hours"; Rec."Working Hours")
                {
                    ToolTip = 'Specifies the value of the Working Hours field';
                    ApplicationArea = All;
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ToolTip = 'Specifies the value of the Sales Area field';
                    ApplicationArea = All;
                }
                field("Biz Registration Type"; Rec."Biz Registration Type")
                {
                    ToolTip = 'Specifies the value of the Biz Registration Type field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (4)"; Rec."Corporate  Sales Rep (4)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (4) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (5)"; Rec."Corporate  Sales Rep (5)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (5) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (HB)"; Rec."Corporate  Sales Rep (HB)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (HB) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (HYP)"; Rec."Corporate  Sales Rep (HYP)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (HYP) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (WS)"; Rec."Corporate  Sales Rep (WS)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (WS) field';
                    ApplicationArea = All;
                }
            }
            group("Address Information")
            {
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email field';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field';
                    ApplicationArea = All;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ToolTip = 'Specifies the value of the Home Page field';
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ToolTip = 'Specifies the value of the Contact field';
                    ApplicationArea = All;
                }
                field("Contact ID"; Rec."Contact ID")
                {
                    ToolTip = 'Specifies the value of the Contact ID field';
                    ApplicationArea = All;
                }
                field("Contact Type"; Rec."Contact Type")
                {
                    ToolTip = 'Specifies the value of the Contact Type field';
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field';
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field';
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ToolTip = 'Specifies the value of the Customer Posting Group field';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field';
                    ApplicationArea = All;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ToolTip = 'Specifies the value of the Customer Price Group field';
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ToolTip = 'Specifies the value of the Customer Disc. Group field';
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment Method Code field';
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies the value of the Payment Terms Code field';
                    ApplicationArea = All;
                }
            }
            group(Shipping)
            {
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Code field';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field';
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ToolTip = 'Specifies the value of the Shipment Method Code field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
