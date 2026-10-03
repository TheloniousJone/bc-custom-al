page 59006 CustHistAPI
{

    ApplicationArea = All;
    Caption = 'CustHist API';
    PageType = List;
    SourceTable = "Temp Sales History";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field("Customer No."; rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Customer Name"; rec."Customer Name")
                {
                    ApplicationArea = All;
                }

                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Unit of Measure"; rec."Unit of Measure")
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
        CustRec: Record customer;
    begin


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
        tshRec: Record "Temp Sales History";
    begin
        tshRec.reset;
        tshRec.SetRange("Cust Price Group", 'C2');
        if tshRec.FindSet() then
            repeat
                rec.ID := tshRec.ID;
                rec."Customer No." := tshRec."Customer No.";
                Rec."Customer Name" := tshRec."Customer Name";
                rec."Item No." := tshRec."Item No.";
                rec.Description := tshRec.Description;
                rec."Unit of Measure" := tshRec."Unit of Measure";
                Rec.SystemModifiedAt := tshRec.SystemModifiedAt;
                Rec.SystemCreatedAt := tshRec.SystemCreatedAt;
                rec.insert(FALSE);
            until tshRec.next = 0;
    end;

    var
        Addr: Text[1000];
        CustRec: Record Customer;
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
