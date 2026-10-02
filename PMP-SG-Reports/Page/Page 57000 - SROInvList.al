page 57000 SROInvList
{

    Caption = 'SROInvList';
    PageType = List;
    SourceTableTemporary = true;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Print Rebill Sales Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57027, true, false, SIHRec);
                end;
            }
        }
    }
    procedure SetRecNo(SRORec: Record "Sales Header")
    var
        myInt: Integer;
    begin
        GSRORec := SRORec;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        LoadData(GSRORec);
    end;


    local procedure LoadData(SRORec: Record "Sales Header")
    var
        myInt: Integer;
        ResEntry: Record "Reservation Entry";
        CurrInvNo: Code[20];
        VLERec: Record "Value Entry";
        SIHRec: Record "Sales Invoice Header";
    begin
        ResEntry.reset;
        ResEntry.SetRange("Source Type", 37);
        ResEntry.SetRange("Source Subtype", 5);
        ResEntry.SetRange("Source ID", SRORec."No.");
        ResEntry.SetFilter("Appl.-from Item Entry", '<>0');
        if ResEntry.FindSet() then
            repeat
                VLERec.reset;
                VLERec.SetRange("Entry Type", VLERec."Entry Type"::"Direct Cost");
                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                VLERec.SetRange("Item Ledger Entry No.", ResEntry."Appl.-from Item Entry");
                if VLERec.FindFirst() then begin
                    SIHRec.reset;
                    SIHRec.SetRange("No.", VLERec."Document No.");
                    if SIHRec.FindFirst() then begin
                        Rec.reset;
                        Rec.SetRange("No.", SIHRec."No.");
                        if not (Rec.FindFirst()) then begin
                            Rec.reset;
                            Rec.Init();
                            Rec."No." := SIHRec."No.";
                            Rec."Sell-to Customer No." := SIHRec."Sell-to Customer No.";
                            rec."Sell-to Customer Name" := SIHRec."Sell-to Customer Name";
                            Rec."Posting Date" := SIHRec."Posting Date";
                            Rec."Sell-to Address" := SIHRec."Sell-to Address";
                            Rec."Sell-to Address 2" := SIHRec."Sell-to Address 2";
                            Rec.Insert(FALSE);
                        end;

                    end;
                end;
            until ResEntry.next = 0;

    end;

    var
        GSRORec: Record "Sales Header";

}
