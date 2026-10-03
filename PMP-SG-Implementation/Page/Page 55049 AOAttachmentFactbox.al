page 55049 "AOAttachmentFactbox"
{

    Caption = 'Attachment Factbox';
    PageType = CardPart;
    SourceTable = "Assembly Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Attachments; Attachments)
                {
                    ToolTip = 'Specifies the value of the Attachment File field';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        Recs: Record "Document Attachment";
                    begin
                        Clear(Page_DcoumentAttachment);
                        Clear(Recs);
                        Recs.Reset();
                        Recs.SetRange("No.", Rec."No.");
                        IF Recs.FindFirst() then;
                        Page_DcoumentAttachment.SetRecord(Recs);
                        Page_DcoumentAttachment.SetTableView(Recs);
                        Page_DcoumentAttachment.RunModal();
                        Clear(Rec_DocumentAttachment);
                        Clear(Attachments);
                        Rec_DocumentAttachment.Reset();
                        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
                        IF Rec_DocumentAttachment.FindSet() then
                            Attachments := Rec_DocumentAttachment.Count;
                    end;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(Attachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
        // //KM20200907 - Start
        // lrec_UserGrpMember.Reset();
        // lrec_UserGrpMember.SetRange("User Security ID", UserSecurityId());
        // lrec_UserGrpMember.SetFilter("User Group Code", 'CTM-VIEWSERVICEATTH');
        // if not lrec_UserGrpMember.FindFirst() then begin
        //     if Rec."Salesperson Code" <> UserId then begin
        //         Rec_DocumentAttachment.SetRange(Cluster, true);
        //     end;
        // end;
        // //KM20200907 - End
        IF Rec_DocumentAttachment.FindSet() then
            Attachments := Rec_DocumentAttachment.Count;
    end;

    var
        Attachments: Integer;
        Rec_DocumentAttachment: Record "Document Attachment";
        Page_DcoumentAttachment: Page "AO Attachments List";
    // lrec_UserGrpMember: Record "User Group Member";//KM20200907 // YF 08 Aug 2024 // MS BC25 Patch


}
