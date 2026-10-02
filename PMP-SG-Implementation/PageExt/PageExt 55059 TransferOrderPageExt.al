pageextension 55059 TransferOrderPageExt extends "Transfer Order"
{
    layout
    {
        // YF 16 Sep 2021 Issue #257
        addbefore(Status)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
            field("No. of Carton"; Rec."No. of Carton")
            {
                ApplicationArea = All;
            }
        }

        addafter("Transfer-to Code")
        {
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    TransferLines: Record "Transfer Line";
                begin
                    // set all lines to this transfer to bin code
                    if Confirm('This will update all lines! Proceed?', false) then begin
                        TransferLines.Reset;
                        TransferLines.SetRange("Document No.", Rec."No.");
                        if TransferLines.FindSet() then
                            repeat
                                // update transfer to bin code for line
                                TransferLines.Validate("Transfer-To Bin Code", Rec."Transfer-To Bin Code");
                                TransferLines.Modify(true);
                            until TransferLines.Next() = 0;

                        CurrPage.TransferLines.Page.Update();
                    end
                    else
                        Error('Update cancelled');
                end;
            }
        }
        // YF 16 Sep 2021 Issue #257
        addfirst(factboxes)
        {
            part(LotNoByBin; "Lot Numbers by Bin FactBox")
            {
                ApplicationArea = Suite, ItemTracking;
                Provider = TransferLines;
                SubPageLink = "Item No." = FIELD("Item No."),
                              "Variant Code" = FIELD("Variant Code"),
                              "Location Code" = FIELD("Transfer-from Code");
            }
        }
    }

    actions
    {
        movefirst(processing; "Create Whse. S&hipment")
        modify("Create Whse. S&hipment")
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
            PromotedOnly = true;
            trigger OnBeforeAction()
            var
                CustRec: Record customer;
                WHShipLineRec: Record "Warehouse Shipment Line";
                WHShipHeaderRec: Record "Warehouse Shipment Header";
                SSSetup: Record "Sales & Receivables Setup";

            begin
                if PLisValid(Rec) then
                    Error('Pick list is still outstanding, you are not allowed to create another pick list.');
                //WHCU.DeleteWHShipmentAndPicking(Rec);

                WHShipLineRec.reset;
                WHShipLineRec.SetRange("Source No.", Rec."No.");
                if WHShipLineRec.FindFirst() then begin
                    WHShipHeaderRec.reset;
                    WHShipHeaderRec.SetRange("No.", WHShipLineRec."No.");
                    if WHShipHeaderRec.FindFirst() then begin
                        WHShipHeaderRec.Validate(Status, WHShipHeaderRec.Status::Open);
                        WHShipHeaderRec.Modify(true);
                        WHShipHeaderRec.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
                    end;
                end;
            end;
        }
        addafter("Create Whse. S&hipment")
        {
            group("Actions")
            {
                //DX        01 Jun 2021
                action("Delete Warehouse Documents")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ALERec: Record "Assignment Ledger Entry";
                    begin
                        ALERec.reset;
                        ALERec.SetRange("Document No.", Rec."No.");
                        // if ALERec.FindFirst() then
                        //     if ALERec.Status <> ALERec.Status::Processing then
                        //         Error('Picking list has been processed already, unable to delete.');

                        If confirm('Are you sure you wish to delete the warehouse documents?') then begin
                            WHCU.DeleteWHShipmentAndPickingTO(Rec);
                        end;
                    end;
                }
                //DX        01 Jun 2021
            }
        }

    }
    procedure PLisValid(SHRec: Record "Transfer Header"): Boolean
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
    begin
        WHActLine.reset;
        WHActLine.SetRange("Source Document", WHActLine."Source Document"::"Outbound Transfer");
        WHActLine.SetRange("Source No.", SHRec."No.");
        if WHActLine.Count > 0 then
            exit(true)
        else
            exit(false);

    end;

    var
        WHCU: Codeunit "Warehouse CU";
}
