page 69000 "VersaFleet Integration Setup"
{
    Caption = 'VersaFleet Integation Setup';
    PageType = Card;
    SourceTable = "VersaFleet Integration Setup";
    PromotedActionCategories = 'Actions';
    UsageCategory = Administration; // Searchable Option
    Editable = true;
    AdditionalSearchTerms = 'VersaFleet Integration Setup,VersaFleet,Delivery,Job,Setup,Config,Configuration';
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            group(General)
            {
                Caption = 'General';

                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                }

                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = All;
                }

                field("API Parent URL"; Rec."API Parent URL")
                {
                    ApplicationArea = All;
                }

                field("Default Job Service Time"; Rec."Default Job Service Time")
                {
                    ApplicationArea = All;
                }

                field("Default Task Service Time"; Rec."Default Task Service Time")
                {
                    ApplicationArea = All;
                }

                field("Item Check Method"; Rec."Item Check Method")
                {
                    ApplicationArea = All;
                }

                field("Item Unload Check Method"; Rec."Item Unload Check Method")
                {
                    ApplicationArea = All;
                }

                // YF 21 Jul 2022
                field("Def. Item for MDC"; Rec."Def. Item for MDC")
                {
                    ApplicationArea = All;
                }
                // YF 21 Jul 2022

                // YF 14 Sep 2022
                field("Debug Mode"; Rec."Debug Mode")
                {
                    ApplicationArea = All;
                }
                // YF 14 Sep 2022
            }

            // YF 27 Jun 2022
            group(CustomFields)
            {
                Caption = 'Custom Fields';

                field("Delivery Charge Field Group ID"; Rec."Delivery Charge Field Group ID")
                {
                    ApplicationArea = All;
                }

                field("Delivery Charge Field Descr ID"; Rec."Delivery Charge Field Descr ID")
                {
                    ApplicationArea = All;
                }

                // YF 21 Feb 2023
                field("Operating Hours Field Descr ID"; Rec."Operating Hours Field Descr ID")
                {
                    ApplicationArea = All;
                }
                // YF 21 Feb 2023
            }
            // YF 27 Jun 2022

            group("PMP Warehouse")
            {
                Caption = 'PMP Warehouse';

                field("PMP VersaFleet Customer ID"; Rec."PMP VersaFleet Customer ID")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Name"; Rec."PMP-WH Name")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Name 2"; Rec."PMP-WH Name 2")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Address"; Rec."PMP-WH Address")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Address 2"; Rec."PMP-WH Address 2")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH City"; Rec."PMP-WH City")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Country"; Rec."PMP-WH Country")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Post Code/Zip"; Rec."PMP-WH Post Code/Zip")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH E-Mail"; Rec."PMP-WH E-Mail")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Contact Person"; Rec."PMP-WH Contact Person")
                {
                    ApplicationArea = All;
                }

                field("PMP-WH Contact Number"; Rec."PMP-WH Contact Number")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

}

