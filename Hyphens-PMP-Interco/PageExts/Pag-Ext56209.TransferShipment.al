pageextension 56209 TransferShipment extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Direct Transfer")
        {
            field("Interco Order No"; Rec."Interco Order No")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {/*
        addlast(processing)
        {
            action(Interco)
            {
                
                    ApplicationArea = all;
                    Caption = 'Generate PO in PMP';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = TransferOrder;
                    Visible = IsOHPL;
                    trigger OnAction()
                    var
                        myInt: Integer;
                    begin
                        if CompanyName <> 'OHPL' then begin
                            Error('Please execute this process in Ocean Health Pte Ltd Company only.');
                        end else begin
                            if Confirm('Please ensure that all information is final in this PO, continue?') then begin
                                IntercoCU.CreatePOinPMP(Rec);
                            end;
                        end;
                    end;
                    
            }
        }
*/
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if CompanyName = 'OHPL' then
            IsOHPL := true
        else
            IsOHPL := false;
    end;

    var
        IsOHPL: Boolean;
        IntercoCU: Codeunit "Hyphens PMP Interco CU";
}
