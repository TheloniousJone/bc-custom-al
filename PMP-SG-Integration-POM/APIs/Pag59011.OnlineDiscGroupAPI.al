page 59011 "Online Disc Group API"
{

    ApplicationArea = All;
    Caption = 'Online Disc Group API';
    PageType = List;
    SourceTable = "Customer Discount Group";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Total Percentage"; rec."Total Percentage")
                {
                    ApplicationArea = All;
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
        CDRec: Record "Customer Discount Group";
    begin
        CDRec.reset;
        if CDRec.FindSet() then
            repeat
                Rec.Code := CDRec.Code;
                rec.Description := CDRec.Description;
                rec."Total Percentage" := CDRec."Total Percentage";
                Rec.insert(FALSE);
            until CDRec.next = 0;
    end;


    var
        Addr: Text[1000];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
