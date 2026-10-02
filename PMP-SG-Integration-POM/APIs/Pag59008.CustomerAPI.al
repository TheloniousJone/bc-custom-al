page 59008 "Customer API"
{

    ApplicationArea = All;
    Caption = 'Customer API';
    PageType = List;
    SourceTable = Customer;

    SourceTableView = sorting("No.");
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {
                field("Customer Account"; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; CurrCode)
                {
                    ApplicationArea = all;
                }
                field(Telephone; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field(Fax; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field("Web User Email"; rec."Web User Email")
                {
                    ApplicationArea = all;
                }
                field("Contact Person"; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field("Street Name"; Street)
                {
                    ApplicationArea = all;
                }

                field("Zip Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field("Country/Region"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Status"; Rec."Customer Status")
                {
                    ApplicationArea = all;
                }
                field("Web User ID"; Rec."Web User ID")
                {
                    ApplicationArea = all;
                }
                field("Web User Name"; Rec."Web User Name")
                {
                    ApplicationArea = all;
                }
                field("Online Discount Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = all;
                }
                field("GST group"; GSTCode)
                {
                    ApplicationArea = all;
                }
                field("Terms of payment"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;

                }
                field("Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = all;
                }
                field("Operating Hours"; Rec."Working Hours")
                {
                    ApplicationArea = all;
                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = all;
                }
                field("Corporate sales rep (PMP)"; Rec."Corporate  Sales Rep (WS)")
                {
                    ApplicationArea = all;
                }
                field("Corporate sales rep (HYP)"; Rec."Corporate  Sales Rep (HYP)")
                {
                    ApplicationArea = all;
                }

                field("Specific Price"; 0)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }
            }

        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;

    begin
        if Rec."Currency Code" = '' then
            CurrCode := 'SGD'
        else
            CurrCode := Rec."Currency Code";

        Street := Rec.Address + ' ' + Rec."Address 2";
        GSTCode := 'GST7%';

    end;

    trigger OnOpenPage()
    begin

        rec.SetFilter("Customer Price Group", '=%1', 'C2');
        rec.SetFilter("Web User ID", '<>%1', '');
        rec.SetRange("POM Customer", true); //RL 07 Sep 2022
    end;



    var
        CurrCode: Code[20];
        Street: Text[500];
        GSTCode: Text[20];
}
