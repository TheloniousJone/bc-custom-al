pageextension 70101 PostedDirectransferListExt extends "Posted Direct Transfers"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_Consignment; Rec.I9G_Consignment)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Consignment field.';
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action(PostedDirectTransfer)
            {
                Caption = 'Consignment Note / Inventory Transfer';
                Image = TransferOrder;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    DirectTransHeaderRec: Record "Direct Trans. Header";
                begin
                    DirectTransHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(DirectTransHeaderRec);
                    Report.RunModal(70020, true, false, DirectTransHeaderRec);
                end;
            }
        }
        addafter("&Print_Promoted")
        {
            actionref(PostedDirectTransfer_Promoted; PostedDirectTransfer) { }
            actionref(UpdateDocument_Promoted; "Update Document") { }
        }
        addlast(processing)
        {
            action("Update Document")
            {
                ApplicationArea = All;
                Caption = 'Update Document';
                Image = Edit;
                Visible = CustomizedVisible;

                trigger OnAction()
                var
                    PstdDirectTransferUpdate: Page I9G_PstdDirectTransferUpdate;
                begin
                    PstdDirectTransferUpdate.LookupMode := true;
                    PstdDirectTransferUpdate.SetRec(Rec);
                    PstdDirectTransferUpdate.RunModal();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}