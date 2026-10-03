page 59012 "SOA API"
{

    ApplicationArea = All;
    Caption = 'SOA API';
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
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

                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = All;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Currency Code"; CurrCode)
                {
                    ApplicationArea = All;
                }

                field("Debit Amount"; rec."Debit Amount")
                {
                    ApplicationArea = All;
                }

                field("Credit Amount"; rec."Credit Amount")
                {
                    ApplicationArea = All;
                }

                field("Remaining Amount"; rec."Remaining Amount")
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

        if Rec."Currency Code" = '' then
            CurrCode := 'SGD'
        else
            CurrCode := Rec."Currency Code";
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
        cleRec: Record "Cust. Ledger Entry";
    begin
        cleRec.reset;
        // cleRec.setfilter("Document Type", '=%1', cleRec."Document Type"::Invoice, cleRec."Document Type"::"Credit Memo", cleRec."Document Type"::Payment);
        cleRec.setfilter(Open, '=%1', true);
        cleRec.setfilter("Document No.", '<>LS*');
        cleRec.SetFilter("Document Type", '<>%1', cleRec."Document Type"::Payment);
        if cleRec.FindSet() then
            repeat
                rec."Entry No." := cleRec."Entry No.";
                Rec."Customer No." := cleRec."Customer No.";
                Rec."Posting Date" := cleRec."Posting Date";
                Rec."Document No." := cleRec."Document No.";
                Rec.Description := cleRec.Description;
                Rec."Currency Code" := cleRec."Currency Code";
                Rec."Debit Amount" := cleRec."Debit Amount";
                Rec."Credit Amount" := cleRec."Credit Amount";
                Rec."Remaining Amount" := cleRec."Remaining Amount";
                Rec.SystemCreatedAt := cleRec.SystemCreatedAt;
                Rec.SystemModifiedAt := cleRec.SystemModifiedAt;
                Rec.insert(FALSE);
            until cleRec.next = 0;
    end;


    var
        Addr: Text[1000];
        CurrCode: Code[20];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
