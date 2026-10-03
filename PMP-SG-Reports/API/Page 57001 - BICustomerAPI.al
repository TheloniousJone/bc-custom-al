page 57001 BICustomerAPI
{

    ApplicationArea = All;
    Caption = 'BICustomerAPI';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ACCOUNTNUM; Rec."No.")
                {
                    ApplicationArea = ALL;
                }
                field(NAME; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(ADDRESS; Rec.Address + ' ' + Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field(PHONE; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field(TELEFAX; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field(INVOICEACCOUNT; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field(CUSTGROUP; Rec."Customer Group")
                {
                    ApplicationArea = all;
                }
                field(PAYMTERMID; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field(CURRENCY; CurrCode)
                {
                    ApplicationArea = all;
                }
                field(SALESGROUP; rec."Corporate  Sales Rep (HYP)")
                {
                    ApplicationArea = all;
                }
                //DX        05 April 2023
                field(CORPOHSALESAREA; Rec."Corporate  Sales Rep (5)")
                {
                    ApplicationArea = all;
                }
                //DX        05 April 2023
                field(CREDITMAX; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Dim 1"; '')
                {
                    ApplicationArea = all;
                }
                field("Dim 2"; '')
                {
                    ApplicationArea = all;
                }
                field("Dim 3"; '')
                {
                    ApplicationArea = all;
                }
                field(PRICEGROUP; Rec."Customer Price Group")
                {
                    ApplicationArea = all;
                }
                field(ENDDISC; Rec."Customer Disc. Group")
                {
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field(DLVTERM; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field(DLVMODE; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field(EMAIL; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field(CELLULARPHONE; Rec."Mobile Phone No.")
                {
                    ApplicationArea = all;
                }
                field(PHONELOCAL; '')
                {
                    ApplicationArea = all;
                }
                field(TAXGROUP; TAXGroup)
                {
                    ApplicationArea = all;
                }
                field(PAYMMODE; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field(COMMISIONGROUP; Rec."Customer Commission Group")
                {
                    ApplicationArea = all;
                }
                field(BRANCH; Rec."Branch/Subsidiary")
                {
                    ApplicationArea = all;
                }
                field("Contact Person Name"; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field(DLVZONE; rec."Delivery Zone")
                {
                    ApplicationArea = all;
                }
                field(WORKINGHOURS; Rec."Working Hours")
                {
                    ApplicationArea = all;
                }
                field(INFOACCOUNT; Rec."Acct Information")
                {
                    ApplicationArea = all;
                }
                field(INFOSTORE; rec."Store Information")
                {
                    ApplicationArea = all;
                }
                field(CUSTSTATUS; Rec."Customer Status")
                {
                    ApplicationArea = all;
                }
                field(CUSTSTATUSREMARK; Rec."Status Remarks")
                {
                    ApplicationArea = all;
                }
                field(CUSTSTATUSDATE; FORMAT(Rec."Status Date", 0, '<Year4>-<Month,2>-<Day,2>'))
                {
                    ApplicationArea = all;
                }
                field(CUSTANALYSISGRP1; '')
                {
                    ApplicationArea = all;
                }
                field(CUSTANALYSISGRP2; '')
                {
                    ApplicationArea = all;
                }
                field(CUSTANALYSISGRP3; '')
                {
                    ApplicationArea = all;
                }
                field(PAYMENTREMINDER; '')
                {
                    ApplicationArea = all;
                }
                field(ZIPCODECUSTOM; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field("SALES REP PMP"; Rec."Corporate  Sales Rep (WS)")
                {
                    ApplicationArea = all;
                }
                field("SALES REP HB"; Rec."Corporate  Sales Rep (HB)")
                {
                    ApplicationArea = all;
                }
                field(AXESALESAREA; Rec."Sales Area")
                {
                    ApplicationArea = all;
                }
                field(MODIFIEDDATE; FORMAT(Rec."Last Date Modified", 0, '<Year4>-<Month,2>-<Day,2>'))
                {
                    ApplicationArea = all;
                }
                field(MODIFEDBY; RPMPEnhance.GetUsername(Rec.SystemModifiedBy))
                {
                    ApplicationArea = all;
                }
                field(CREATEDDATE; FORMAT(Rec.SystemCreatedAt, 0, '<Year4>-<Month,2>-<Day,2>'))
                {
                    ApplicationArea = all;
                }
                field(CREATEDBY; RPMPEnhance.GetUsername(Rec.SystemCreatedBy))
                {
                    ApplicationArea = all;
                }
                field(Company; Rec.CurrentCompany)
                {
                    ApplicationArea = all;
                }

                //RL    22 Dec 2021 - Start
                field("SALES REP DIY"; Rec."Corporate  Sales Rep (4)")
                {
                    ApplicationArea = All;
                }
                field("Customer Sales Classification"; Rec."Customer Sales Classification")
                {
                    ApplicationArea = All;
                }
                //RL    22 Dec 2021 - End
                //RL 10 Feb 2023
                field(SPECIALTIES; CustSpec)
                {
                    ApplicationArea = All;
                }
                field(SECTOR; Rec.I9G_Sector)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sector field.';
                }
                field(CHANNEL; Rec.I9G_Channel)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Channel field.';
                }
                //RL 10 Feb 2023
                //DX        14 Dec 2024
                field(customer_guid; format(Rec.SystemId))
                {

                }
                //DX        14 Dec 2024
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

        //RL 10 Feb 2023
        CustSPec := '';
        CustSpecialtyRec.Reset();
        CustSpecialtyRec.SetLoadFields("Cust No.", "Specialty Code");
        CustSpecialtyRec.SetRange("Cust No.", Rec."No.");
        if CustSpecialtyRec.FindFirst() then
            CustSPec := CustSpecialtyRec."Specialty Code";
        //RL 10 Feb 2023


    end;

    var
        CurrCode: Code[20];
        TAXGroup: code[20];
        RPMPEnhance: Codeunit "PMP-Enhancements";
        CustSpecialtyRec: Record "Customer Specialties";
        CustSPec: Code[20];
}
