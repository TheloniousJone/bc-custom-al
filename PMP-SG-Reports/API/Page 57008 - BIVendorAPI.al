page 57008 BIVendorAPI
{
    SourceTable = Vendor;
    APIGroup = 'BIVendorAPI';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BIVendorAPI';
    DelayedInsert = true;
    EntityName = 'BIVendorAPI';
    EntitySetName = 'BIVendorAPI';
    PageType = API;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Company; Rec.CurrentCompany)
                {
                    ApplicationArea = all;
                }
                field(Vendor_No; Rec."No.")
                {
                    ApplicationArea = ALL;
                }
                field(Vendor_Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Address; Rec.Address + ' ' + Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field(Phone; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field(Telefax; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field(PayMethod; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field(Currency; CurrCode)
                {
                    ApplicationArea = all;
                }
                field("Country"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field(Email; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field(Mobile; Rec."Mobile Phone No.")
                {
                    ApplicationArea = all;
                }
                field(ZipCode; Rec."Post Code")
                {
                    ApplicationArea = all;
                }

                field(MODIFIEDDATE; FORMAT(Rec."Last Date Modified"))
                {
                    ApplicationArea = all;
                }
                field(MODIFEDBY; RPMPEnhance.GetUsername(Rec.SystemModifiedBy))
                {
                    ApplicationArea = all;
                }
                field(CREATEDDATE; FORMAT(Rec.SystemCreatedBy))
                {
                    ApplicationArea = all;
                }
                field(CREATEDBY; RPMPEnhance.GetUsername(Rec.SystemCreatedBy))
                {
                    ApplicationArea = all;
                }


            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLSetup: Record "General Ledger Setup";
    begin
        CurrCode := '';
        if Rec."Currency Code" = '' then begin
            GLSetup.reset;
            GLSetup.get;
            CurrCode := GLSetup."LCY Code";
        end;
        if Rec."VAT Bus. Posting Group" = 'LOCAL' then
            TAXGroup := 'GST7%'
        else
            TAXGroup := Rec."VAT Bus. Posting Group";



    end;

    var
        CurrCode: Code[20];
        TAXGroup: code[20];
        RPMPEnhance: Codeunit "PMP-Enhancements";
}
