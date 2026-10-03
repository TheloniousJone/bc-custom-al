pageextension 60107 WellTransferOrderPageExt extends "Transfer Order"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Retrieved SO from Wellaway"; Rec."Retrieved SO from Wellaway")
            {
                ApplicationArea = all;
                Caption = 'Retrieved Order From Wellaway';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Direct Transfer")
        {
            Visible = false;
        }

    }
    //DX        15 July 2021        Additional button to get list of SO lines from Well BC
    actions
    {
        addafter("F&unctions")
        {

            action("Retrieve Wellaway SOs")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;
                PromotedIsBig = true;
                Image = GetEntries;
                ApplicationArea = all;
                trigger OnAction()
                var
                    myInt: Integer;
                    QtyDec: Decimal;
                    SOList: Page SOLineLookup;
                    SLRec: Record "Sales Line";
                    WellSLRec: Record "Sales Line";
                    ConItemRec: Record "Item" temporary;
                    TempItemRec: Record "Item" temporary;
                    QtySLRec: Record "Sales Line" temporary;
                begin

                    Clear(SOList);
                    SOList.LookupMode(true);
                    if SOList.RunModal() = Action::LookupOK then begin      //Use page to load temp data from wellaway entity first, after selecting then update by val
                        SOList.SetSelectionFilter(SLRec);
                        if SLRec.Count > 0 then begin
                            if Confirm('Are you sure you wish to create the transfer lines from the selected SO lines?') then begin
                                if SLRec.FindSet() then
                                    repeat
                                        QtySLRec.init;
                                        QtySLRec.Copy(SLRec);
                                        QtySLRec.insert(FALSE);
                                    until SLRec.next = 0;
                                if SLRec.FindSet() then     //Loop through all selected SL Lines from lookup
                                    repeat
                                        QtyDec := 0;
                                        ConItemRec.reset;
                                        ConItemRec.SetRange("No.", SLRec."No.");
                                        if not (ConItemRec.FindFirst()) then begin  //Get unique item combination with total qty first
                                            TempItemRec.reset;
                                            TempItemRec.init;
                                            TempItemRec."No." := SLRec."No.";
                                            QtySLRec.reset;
                                            QtySLRec.SetRange("No.", SLRec."No.");
                                            if QtySLRec.FindSet() then
                                                repeat
                                                    QtyDec += QtySLRec."Quantity (Base)";
                                                until QtySLRec.next = 0;
                                            TempItemRec."Unit Price" := WellCU.GetStockDiff(SLRec."No.", QtyDec);
                                            TempItemRec.insert(FALSE);
                                            ConItemRec.Copy(TempItemRec);
                                            ConItemRec.Insert(FALSE);
                                        end;
                                        WellSLRec.reset;
                                        WellSLRec.ChangeCompany(WellCU.GetWellawayCompany());
                                        WellSLRec.SetRange("Document No.", SLRec."Document No.");
                                        WellSLRec.SetRange("Line No.", SLRec."Line No.");
                                        if WellSLRec.FindFirst() then begin
                                            WellSLRec."Invoiced In PMP" := true;
                                            WellSLRec.Modify(false);
                                        end;
                                        CurrPage.Update();
                                    until SLRec.next = 0;           //Get the unique combination and total qty first.
                                if TempItemRec.FindSet() then
                                    repeat
                                        //WellCU.CreateTOLineBySOLine(SLRec."Document No.", SLRec."Line No.", Rec);
                                        WellCU.CreateTOLineByItemCode(TempItemRec."No.", TempItemRec."Unit Price", Rec);
                                    until TempItemRec.next = 0;
                                Rec."Retrieved SO from Wellaway" := true;
                                rec.Modify(FALSE);
                            end;
                        end;
                    end;
                end;
            }
            action("Reset Wellaways SO")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = GetEntries;
                ApplicationArea = all;
                trigger OnAction()
                var
                    myInt: Integer;
                    SLRec: Record "Sales Line";
                begin
                    Message('This is for development testing only to reset all wellaway bc settings.');
                    SLRec.reset;
                    SLRec.ChangeCompany(WellCU.GetWellawayCompany());
                    SLRec.SetRange(Type, SLRec.Type::Item);
                    SLRec.SetFilter("No.", '<>%1', '');
                    SLRec.SetFilter(Quantity, '<>0');
                    if SLRec.FindSet() then
                        repeat
                            SLRec."Invoiced In PMP" := false;
                            SLRec.Modify(FALSE);
                        until SLRec.next = 0;
                end;
            }
        }
        addfirst(Creation)
        {
            group(process)
            {
                action("Create Warehouse Shipment")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    Image = GetEntries;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                        myInt: Integer;
                        SLRec: Record "Sales Line";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //DX        15 July 2021    If TO is 1 to 1 and not retrieved yet
        if (Rec."No." <> '') then begin
            //DX        08 Sept 2021
            if (Rec."Retrieved SO from Wellaway" = false) AND (WellCU.IsPMPCompany()) AND (Rec."Transfer-to Code" = 'WELLAWAY') then begin
                //DX        08 Sept 2021
                WellCU.CreateTOLineFromIJ(Rec);
            end;
        end;

    end;


    //DX        15 July 2021


    var
        WellCU: Codeunit "Wellaway CU";
}
