page 50199 "Halal Certification Body List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Halal Certification Bodies";
    CardPageId = "Halal Certification Body";
    //AutoSplitKey = true;
    RefreshOnActivate = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(HalalBodyList)
            {
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
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                    Visible = false;
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
                field(Slaughtering; Rec.Slaughtering)
                {
                    ApplicationArea = All;
                    Caption = 'Slaughtering';
                    Visible = false;
                }
                field("Raw Material"; Rec."Raw Material")
                {
                    ApplicationArea = All;
                    Caption = 'Raw Material';
                    Visible = false;
                }
                field(Flavor; Rec.Flavor)
                {
                    ApplicationArea = All;
                    Caption = ' Flavor';
                    Visible = false;
                }
            }
        }
    }

    var
}