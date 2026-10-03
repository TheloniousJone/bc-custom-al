page 50198 "Halal Certification Body"
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Halal Certification Bodies";

    layout
    {
        area(Content)
        {
            group(Halal)
            {
                Caption = 'Halal Certification Body';
                field("Halal Certification Body"; Rec."Halal Certification Body")
                {
                    ApplicationArea = All;
                    Caption = 'Halal Certification Body';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Fax No.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = All;
                    Caption = 'Contact Person';
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    ApplicationArea = All;
                    Caption = 'Country of Origin';
                }
                field("Halal Body Logo"; Rec."Halal Body Logo")
                {
                    ApplicationArea = All;
                    Caption = 'Halal Body Logo';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }

                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                    Visible = false;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = All;
                    Caption = 'Expired';
                    Visible = false;
                }
                group(Category)
                {
                    Visible = false;

                    field(Slaughtering; Rec.Slaughtering)
                    {
                        ApplicationArea = All;
                        Caption = 'Slaughtering';
                    }
                    field("Raw Material"; Rec."Raw Material")
                    {
                        ApplicationArea = All;
                        Caption = 'Raw Material';
                    }
                    field(Flavor; Rec.Flavor)
                    {
                        ApplicationArea = All;
                        Caption = ' Flavor';
                    }
                }
            }
        }
    }

    var

}