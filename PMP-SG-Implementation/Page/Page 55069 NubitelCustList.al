page 55069 NubitelCustList
{

    ApplicationArea = All;
    Caption = 'NubitelCustList';
    PageType = List;
    SourceTable = Customer;
    SourceTableTemporary = true;
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
                field("Fax"; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field(Telephone; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field("Contact Person"; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field("Street Name"; Addr)
                {
                    ApplicationArea = all;
                }
                field("Zip Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Status"; Rec."Customer Status")
                {
                    ApplicationArea = all;
                }
                field("Corporate  Sales Rep (PMP)"; Rec."Corporate  Sales Rep (HYP)")
                {
                    ApplicationArea = all;
                }


            }

        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        CustRec: Record customer;
    begin
        CustRec.reset;
        CustRec.SetRange("No.", Rec."No.");
        if CustRec.FindFirst() then begin
            Addr := CustRec.Address + ' ' + CustRec."Address 2" + ' ' + CustRec."Post Code";
        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetPageData();
    end;

    local procedure SetPageData()
    var
        myInt: Integer;
        CustRec: Record customer;
    begin
        CustRec.reset;
        CustRec.setfilter("Customer Status", '<>%1', CustRec."Customer Status"::Closed);
        if CustRec.FindSet() then
            repeat
                Rec."No." := CustRec."No.";
                Rec.Name := CustRec.Name;
                Rec."Branch/Subsidiary" := CustRec."Branch/Subsidiary";
                Rec."Fax No." := CustRec."Fax No.";
                Rec."Phone No." := CustRec."Phone No.";
                Rec."E-Mail" := CustRec."E-Mail";
                Rec.Contact := CustRec.Contact;
                Rec."Post Code" := CustRec."Post Code";
                rec."Customer Status" := CustRec."Customer Status";
                rec."Corporate  Sales Rep (HYP)" := CustRec."Corporate  Sales Rep (HYP)";
                Rec.insert(FALSE);
            until CustRec.next = 0;
    end;

    var
        Addr: Text[1000];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
