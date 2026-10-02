pageextension 66001 CheckingSubMaxxholo extends "Checking Subform"
{
    layout
    {
    }

    actions
    {
        addafter(ActionName)
        {
            action(MaxxholoLabel)
            {
                Caption = 'Maxxholo Label';
                ApplicationArea = All;
                Image = OpenWorksheet;

                trigger OnAction()
                var
                    lpg_MaxxholoLabelDoc: Page "Maxxholo Label Doc.";
                    lenum_DocType: enum "Document Type";
                    lrec_MaxxholoHeader: Record MaxxholoHeader;
                    lrec_Item: Record Item;
                    lrec_MaxxholoHeaderNew: Record MaxxholoHeader;

                    ALERec: Record "Assignment Ledger Entry";
                    SHRec: Record "Sales Header";
                begin
                    // lrec_Item.Reset();
                    // lrec_Item.SetRange("No.", Rec."Item No.");
                    // lrec_Item.SetRange(I9G_Maxxholo, true);
                    // if lrec_Item.FindFirst() then begin
                    Clear(gcdu_MaxxholoIntegration);
                    if gcdu_MaxxholoIntegration.IsItemMaxxholo(Rec."Item No.") then begin
                        Clear(lpg_MaxxholoLabelDoc);

                        lrec_MaxxholoHeader.Reset();
                        lrec_MaxxholoHeader.SetRange(I9G_SourceTable, lenum_DocType::"55004");
                        lrec_MaxxholoHeader.SetRange(I9G_SourceDocNo, Rec."Doc No.");
                        lrec_MaxxholoHeader.SetRange(I9G_SourceDocLineNo, Rec."Line No.");
                        lrec_MaxxholoHeader.SetRange(I9G_ProductCode, Rec."Item No.");
                        if lrec_MaxxholoHeader.FindFirst() then begin
                            lpg_MaxxholoLabelDoc.SetTableView(lrec_MaxxholoHeader);
                            lpg_MaxxholoLabelDoc.Run();
                        end else begin
                            // lpg_MaxxholoLabelDoc.assignSourceValue(lenum_DocType::"55004", Rec."No.", Rec."Line No.", Rec."Item No.");
                            if Dialog.Confirm('No Maxxholo Label found. Do you want to create one?', true) then begin
                                lrec_MaxxholoHeaderNew.Reset();
                                lrec_MaxxholoHeaderNew.Init();
                                lrec_MaxxholoHeaderNew.I9G_DocNo := '';
                                lrec_MaxxholoHeaderNew.Insert(true);
                                lrec_MaxxholoHeaderNew.Validate(I9G_SourceTable, lenum_DocType::"55004");
                                lrec_MaxxholoHeaderNew.Validate(I9G_SourceDocNo, Rec."Doc No.");
                                lrec_MaxxholoHeaderNew.Validate(I9G_SourceDocLineNo, Rec."Line No.");
                                lrec_MaxxholoHeaderNew.Validate(I9G_ProductCode, Rec."Item No.");
                                ALERec.reset;
                                ALERec.SetLoadFields("Picking Doc No.", "Document No.");
                                ALERec.SetRange("Picking Doc No.", Rec."Doc No.");
                                if ALERec.FindFirst() then begin
                                    if ALERec."Invoice No." = '' then begin
                                        SHRec.reset;
                                        SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                                        SHRec.SetRange("No.", ALERec."Document No.");
                                        if SHRec.FindFirst() then begin
                                            lrec_MaxxholoHeaderNew.I9G_BillCode := SHRec."Bill-to Customer No.";
                                            lrec_MaxxholoHeaderNew.I9G_BillName := SHRec."Bill-to Name";
                                            lrec_MaxxholoHeaderNew.I9G_BillAddress := SHRec."Bill-to Address";
                                            lrec_MaxxholoHeaderNew.I9G_ShipCode := SHRec."Sell-to Customer No.";
                                            lrec_MaxxholoHeaderNew.I9G_ShipName := SHRec."Ship-to Name";
                                            lrec_MaxxholoHeaderNew.I9G_ShipAddress := SHRec."Ship-to Address";
                                        end;
                                    end;
                                end;
                                lrec_MaxxholoHeaderNew.Modify();
                                Commit();
                                lrec_MaxxholoHeader.Reset();
                                lrec_MaxxholoHeader.SetRange(I9G_SourceTable, lenum_DocType::"55004");
                                lrec_MaxxholoHeader.SetRange(I9G_SourceDocNo, Rec."Doc No.");
                                lrec_MaxxholoHeader.SetRange(I9G_SourceDocLineNo, Rec."Line No.");
                                lrec_MaxxholoHeader.SetRange(I9G_ProductCode, Rec."Item No.");
                                lpg_MaxxholoLabelDoc.SetTableView(lrec_MaxxholoHeader);
                                lpg_MaxxholoLabelDoc.Run();
                            end;
                        end;

                    end;

                end;
            }

            action("Proof Tag Reference")
            {
                ApplicationArea = All;
                Caption = 'Proof Tag Reference';
                Image = Insert;

                trigger OnAction()
                var
                    CheckingProofTagLine: Record "Checking Proof Tag Line";
                begin
                    CheckingProofTagLine.Reset();
                    CheckingProofTagLine.SetRange("Doc No.", Rec."Doc No.");
                    CheckingProofTagLine.SetRange("Doc Line No.", Rec."Line No.");

                    Page.RunModal(Page::"Checking Proof Tag Lines", CheckingProofTagLine);
                end;
            }
        }
    }

    var
        gcdu_MaxxholoIntegration: Codeunit "Maxxholo Integration";

    trigger OnDeleteRecord(): Boolean
    begin
        Clear(gcdu_MaxxholoIntegration);
        if gcdu_MaxxholoIntegration.IsItemMaxxholo(Rec."Item No.") then begin

        end;
    end;
}