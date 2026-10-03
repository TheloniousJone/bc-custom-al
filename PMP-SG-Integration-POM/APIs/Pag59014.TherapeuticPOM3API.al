page 59014 "Therapeutic POM 3 API"
{

    ApplicationArea = All;
    Caption = 'Therapeutic POM 3 API';
    PageType = List;
    SourceTable = "Therapeutic-Item Setup";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field("Therapeutic Category"; rec."Therapeutic Category")
                {
                    ApplicationArea = All;
                }

                field("Therapeutic Pharmacology"; rec."Therapeutic Pharmacology")
                {
                    ApplicationArea = All;
                }

                field("Item No."; rec."Item No.")
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
        TherapeuticRec: Record "Therapeutic-Item Setup";
    begin
        TherapeuticRec.reset;
        if TherapeuticRec.FindSet() then
            repeat
                Rec."Therapeutic Category" := TherapeuticRec."Therapeutic Category";
                Rec."Therapeutic Pharmacology" := TherapeuticRec."Therapeutic Pharmacology";
                Rec."Item No." := TherapeuticRec."Item No.";
                Rec.SystemCreatedAt := TherapeuticRec.SystemCreatedAt;
                Rec.SystemModifiedAt := TherapeuticRec.SystemModifiedAt;
                Rec.insert(FALSE);
            until TherapeuticRec.next = 0;
    end;

    var
        Addr: Text[1000];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
