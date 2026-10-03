pageextension 57006 SalesReturnOrderCardPageExt extends "Sales Return Order"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            group(Reports)
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
                        SLRec: Record "Sales Line";
                        PageVal: Page 57000;
                        ResEntry: Record "Reservation Entry";
                        VLERec: Record "Value Entry";
                        RebillInv: report 57027;
                    begin
                        if Morethan1SalesInv(Rec) then begin
                            Clear(PageVal);
                            PageVal.SetRecNo(Rec);
                            PageVal.Run();
                        end else begin
                            ResEntry.reset;
                            ResEntry.SetRange("Source ID", Rec."No.");
                            ResEntry.SetRange("Source Type", 37);
                            ResEntry.SetRange("Source Subtype", 5);
                            if ResEntry.FindFirst() then begin
                                VLERec.reset;
                                VLERec.SetRange("Item Ledger Entry No.", ResEntry."Appl.-from Item Entry");
                                VLERec.SetRange("Entry Type", VLERec."Entry Type"::"Direct Cost");
                                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                                if VLERec.findfirst then begin
                                    SIHRec.Reset();
                                    SIHRec.SetRange("No.", VLERec."Document No.");
                                    if SIHRec.FindFirst() then begin
                                        clear(RebillInv);
                                        RebillInv.SetTableView(SIHRec);
                                        RebillInv.SetRecNo(Rec."No.");
                                        RebillInv.Run();
                                        //Report.Run(57027, true, false, SIHRec);
                                    end;
                                end;
                            end;

                        end;

                    end;
                }
            }
        }
    }
    local procedure GetOffSetTotal(SLRec: Record "Sales Invoice Line") Disc: Decimal;
    var
        myInt: Integer;
        VLErec: Record "Value Entry";
        ResEntry: Record "Reservation Entry";
        SROLine: Record "Sales Line";
    begin
        VLErec.reset;
        VLErec.SetRange("Document Line No.", SLRec."Line No.");
        VLErec.SetRange("Document No.", SLRec."Document No.");
        VLErec.SetRange("Entry Type", VLErec."Entry Type"::"Direct Cost");
        if VLErec.findfirst then begin
            ResEntry.reset;
            ResEntry.SetRange("Appl.-from Item Entry", VLErec."Item Ledger Entry No.");
            ResEntry.SetRange("Source Type", 37);
            ResEntry.SetRange("Source Subtype", 5);
            if ResEntry.FindSet() then
                repeat
                    SROLine.reset;
                    SROLine.SetRange("Line No.", ResEntry."Source Ref. No.");
                    SROLine.SetRange("Document No.", ResEntry."Source ID");
                    if SROLine.FindFirst() then
                        Disc += SROLine."Amount Including VAT";
                until ResEntry.next = 0;
        end;
    end;

    local procedure Morethan1SalesInv(SRORec: Record "Sales Header"): Boolean
    var
        myInt: Integer;
        ResEntry: Record "Reservation Entry";
        CurrInvNo: Code[20];
        VLERec: Record "Value Entry";
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
                    if CurrInvNo = '' then
                        CurrInvNo := VLERec."Document No."
                    else begin
                        if CurrInvNo <> VLERec."Document No." then
                            exit(true);
                    end;
                end;

            until ResEntry.next = 0;
        exit(false);
    end;
}
