page 59013 "Therapeutic POM 2 API"
{

    ApplicationArea = All;
    Caption = 'Therapeutic POM 2 API';
    PageType = List;
    SourceTable = "POM2 Therapeutic";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field("Item Code"; rec."Item Code")
                {
                    ApplicationArea = All;
                }

                field("Therapeutic ID"; rec."Therapeutic ID")
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
        TherapeuticRec: Record "POM2 Therapeutic";
    begin
        TherapeuticRec.reset;
        if TherapeuticRec.FindSet() then
            repeat
                Rec."Therapeutic ID" := TherapeuticRec."Therapeutic ID";
                Rec."Item Code" := TherapeuticRec."Item Code";
                Rec.SystemModifiedAt := TherapeuticRec.SystemModifiedAt;
                Rec.SystemCreatedAt := TherapeuticRec.SystemCreatedAt;
                Rec.insert(FALSE);
            until TherapeuticRec.next = 0;
    end;

    var
        Addr: Text[1000];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
