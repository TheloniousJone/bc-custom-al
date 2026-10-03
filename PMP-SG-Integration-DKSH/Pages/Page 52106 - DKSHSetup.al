page 52106 "DKSH Integration Setup"
{
    Caption = 'DKSH Integation Setup';
    PageType = Card;
    SourceTable = "DKSH Integration Setup";
    PromotedActionCategories = 'Actions';
    UsageCategory = Administration; // Searchable Option
    Editable = true;
    AdditionalSearchTerms = 'DKSH Integration Setup,DKSH,PO,Setup,Config,Configuration';
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            group(General)
            {
                Caption = 'General';

                field("BC Vendor Code"; Rec."BC Vendor Code")
                {
                    ApplicationArea = All;
                }

                field("DKSH Buyer Code"; Rec."DKSH Buyer Code")
                {
                    ApplicationArea = All;
                }

                field("DKSH Buyer Given Supplier Code"; Rec."DKSH Buyer Given Supplier Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }

            group(POXMLDefaults)
            {
                Caption = 'Export PO XML Defaults';

                field("PO Document Status"; Rec."PO Document Status")
                {
                    ApplicationArea = All;
                }

                field("PO Type of Order"; Rec."PO Type of Order")
                {
                    ApplicationArea = All;
                }

                field("PO Specs Version"; Rec."PO Specs Version")
                {
                    ApplicationArea = All;
                }

                field("PO Movement Data Type"; Rec."PO Movement Data Type")
                {
                    ApplicationArea = All;
                }

                field("PO Entity Type"; Rec."PO Entity Type")
                {
                    ApplicationArea = All;
                }

                field("PO Role of Buyer"; Rec."PO Role of Buyer")
                {
                    ApplicationArea = All;
                }

                field("PO Seller Alt. Party ID"; Rec."PO Seller Alt. Party ID")
                {
                    ApplicationArea = All;
                }

                field("PO Role of Seller"; Rec."PO Role of Seller")
                {
                    ApplicationArea = All;
                }

                field("PO Delivery Party ID Type"; Rec."PO Delivery Party ID Type")
                {
                    ApplicationArea = All;
                }

                field("PO Deliver to Location ID"; Rec."PO Deliver to Location ID")
                {
                    ApplicationArea = All;
                }

                field("PO Delivery Alt. Party ID"; Rec."PO Delivery Alt. Party ID")
                {
                    ApplicationArea = All;
                }

                field("PO Role of Delivery"; Rec."PO Role of Delivery")
                {
                    ApplicationArea = All;
                }

                field("PO Allowance Level Type"; Rec."PO Allowance Level Type")
                {
                    ApplicationArea = All;
                }

                field("PO Allow Or Charge"; Rec."PO Allow Or Charge")
                {
                    ApplicationArea = All;
                }

                field("PO Allowance Settle Type"; Rec."PO Allowance Settle Type")
                {
                    ApplicationArea = All;
                }

                field("PO Buyer Item Identifier"; Rec."PO Buyer Item Identifier")
                {
                    ApplicationArea = All;
                }

                field("PO Seller Item Identifier"; Rec."PO Seller Item Identifier")
                {
                    ApplicationArea = All;
                }

                field("PO Location Type Attribute"; Rec."PO Location Type Attribute")
                {
                    ApplicationArea = All;
                }

                field("PO Location ID Attribute"; Rec."PO Location ID Attribute")
                {
                    ApplicationArea = All;
                }

                field("PO Role of PO Line Delivery"; Rec."PO Role of PO Line Delivery")
                {
                    ApplicationArea = All;
                }

                // YF 17 Nov 2022
                field("PO EDI Email Address"; Rec."PO EDI Email Address")
                {
                    ApplicationArea = All;
                }
                // YF 17 Nov 2022
            }

        }
    }

}

