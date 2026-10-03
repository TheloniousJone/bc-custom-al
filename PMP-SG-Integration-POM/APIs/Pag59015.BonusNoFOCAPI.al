page 59015 BonusNoFOCAPI
{

    ApplicationArea = All;
    Caption = 'Bonus NO FOC API';
    PageType = List;
    SourceTable = "Pharma Sales Price";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field("Product Name"; Desc)
                {
                    ApplicationArea = All;
                }

                field("Minimum Quantity"; rec."Minimum Quantity")
                {
                    ApplicationArea = all;
                }

                field("Unit Of Measure Code"; rec."Unit Of Measure Code")
                {
                    ApplicationArea = All;
                }

                field("FOC Qty"; rec."FOC Qty")
                {
                    ApplicationArea = All;

                }

                field(RecRefID; rec.RecRefID)
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
        ItemRec: Record Item;

    begin

        ItemRec.reset;
        ItemRec.SetRange("No.", Rec."Item No.");
        if ItemRec.FindFirst() then begin
            Desc := ItemRec.Description;
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
        pspRec: Record "Pharma Sales Price";
    begin
        pspRec.reset;
        pspRec.setfilter("FOC Qty", '=0');
        if pspRec.FindSet() then
            repeat
                Rec."Item No." := pspRec."Item No.";
                Rec."Sales Code" := pspRec."Sales Code";
                Rec."Minimum Quantity" := pspRec."Minimum Quantity";
                Rec."Unit Of Measure Code" := pspRec."Unit Of Measure Code";
                Rec."FOC Qty" := pspRec."FOC Qty";
                rec.RecRefID := pspRec.RecRefID;
                rec.SystemModifiedAt := pspRec.SystemModifiedAt;
                Rec.SystemCreatedAt := pspRec.SystemCreatedAt;
                Rec.insert(FALSE);
            until pspRec.next = 0;
    end;

    var
        Addr: Text[1000];
        Desc: Text[100];
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
