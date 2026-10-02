page 59025 "POM Customer API"
{
    APIGroup = 'pom_integration';
    APIPublisher = 'illum9';
    APIVersion = 'v2.0';
    Editable = false;
    EntityName = 'customer';
    EntitySetName = 'customers';
    PageType = API;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(number; Rec."No.")
                {
                }
                field(name; Rec.Name)
                {
                }
                field(billto_custno; Rec."Bill-to Customer No.")
                {
                }
                field(phone_no; Rec."Phone No.")
                {
                }
                field(fax_no; Rec."Fax No.")
                {
                }
                field(web_email; Rec."Web User Email")
                {
                }
                field(address; Rec.Address)
                {
                }
                field(post_code; Rec."Post Code")
                {
                }
                field(country_code; Rec."Country/Region Code")
                {
                }
                field(status; Rec."Customer Status")
                {
                }
                field(web_id; Rec."Web User ID")
                {
                }
                field(web_name; Rec."Web User Name")
                {
                }
                field(price_group; Rec."Customer Price Group")
                {
                }
                field(working_hours; Rec."Working Hours")
                {
                }
                field(moh_license_no; Rec."MOH License No.")
                {
                }
                field(customer_group; Rec."Customer Group")
                {
                }
                field(vat_registration_no; Rec."VAT Registration No.")
                {
                }
                field(modified_at; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }
}
