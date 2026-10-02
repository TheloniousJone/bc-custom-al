report 57021 AutoReleaseSO
{
    ApplicationArea = All;
    Caption = 'AutoReleaseSO';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                SHRec: Record "Sales Header";
                CustRec: record Customer temporary;
                lCustRec: record Customer temporary;
                CustRec2: Record customer temporary;
                TotalAmt: Decimal;
            begin
                SHRec.reset;
                SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                SHRec.SetRange(Status, SHRec.Status::Released);
                SHRec.SetRange("Chain Pharmacy", false);
                SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
                SHRec.SetRange("Location Code", 'PMP-WH');
                SHRec.SetRange("Logistics Service", false);
                SHRec.SetRange("Out of Stock", false);
                SHRec.SetRange("Insufficient Stocks in Pick", false);
                SHRec.SetFilter(SystemCreatedBy, '%1', enhanceCU.GetBCAdminGUID());
                if SHRec.FindSet() then
                    repeat
                        CustRec.reset;
                        CustRec.SetRange("No.", SHRec."Sell-to Customer No.");
                        if not (CustRec.FindFirst()) then begin
                            lCustRec.reset;
                            lcustrec."No." := SHRec."Sell-to Customer No.";
                            lCustRec.Insert(FALSE);
                            CustRec.reset;
                            CustRec.Copy(lCustRec);
                            CustRec.insert;
                        end;
                    until SHRec.next = 0;
                if lCustRec.count <> 0 then begin        //Get list of all customers first
                    if lCustRec.FindSet() then
                        repeat
                            TotalAmt := 0;
                            SHRec.reset;
                            SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                            SHRec.SetRange("Sell-to Customer No.", lCustRec."No.");
                            SHRec.SetRange(Status, SHRec.Status::Released);
                            SHRec.SetRange("Chain Pharmacy", false);
                            SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
                            SHRec.SetRange("Location Code", 'PMP-WH');
                            SHRec.SetRange("Logistics Service", false);
                            SHRec.SetRange("Out of Stock", false);
                            SHRec.SetRange("Insufficient Stocks in Pick", false);
                            SHRec.SetFilter(SystemCreatedBy, '%1', enhanceCU.GetBCAdminGUID());
                            if SHRec.FindSet() then
                                repeat
                                    SHRec.CalcFields(Amount);
                                    TotalAmt += SHRec.Amount;
                                until SHRec.next = 0;
                            if TotalAmt >= 100 then begin    //Only if customer exceeds > 100 then add into approved list.
                                CustRec2.reset;
                                CustRec2."No." := lCustRec."No.";
                                CustRec2.Insert(false);
                            end;
                        until lCustRec.next = 0;
                end;
                if CustRec2.count <> 0 then begin       //Loop through approved list and release the orders
                    if CustRec2.FindSet() then
                        repeat
                            SHRec.reset;
                            SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                            SHRec.SetRange("Sell-to Customer No.", CustRec2."No.");
                            SHRec.SetRange(Status, SHRec.Status::Released);
                            SHRec.SetRange("Chain Pharmacy", false);
                            SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
                            SHRec.SetRange("Location Code", 'PMP-WH');
                            SHRec.SetRange("Logistics Service", false);
                            SHRec.SetRange("Out of Stock", false);
                            SHRec.SetRange("Insufficient Stocks in Pick", false);
                            SHRec.SetFilter(SystemCreatedBy, '%1', enhanceCU.GetBCAdminGUID());
                            SHRec.SetFilter("Last Shipping No.", '<>%1', '');
                            if SHRec.FindSet() then
                                repeat
                                    Create(SHRec);
                                    myInt += 1;
                                until SHRec.next = 0;
                        until CustRec2.next = 0;
                end;
            end;
        }
        /*
                dataitem(SalesHeaderReport; "Sales Header")
                {
                    DataItemTableView = sorting("No.") Where(Status = const("Released"), "Chain Pharmacy" = const(false), "Order Status" = const("Open"), "Location Code" = const('PMP-WH'));
                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;

                        ALERec: Record "Assignment Ledger Entry";


                    begin
                        ALERec.reset;
                        ALERec.SetRange("Document No.", SalesHeaderReport."No.");
                        if NOT (ALERec.FindFirst()) then begin
                            Create(SalesHeaderReport);

                        end;
                    end;
                }
                */
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        enhanceCU: Codeunit "PMP-Enhancements";

    [TryFunction]
    local procedure Create(SalesHeader: Record "Sales Header")
    var
        myInt: Integer;
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        GetSourceDocOutbound.CreateFromSalesOrder(SalesHeader);
        //IF NOT FIND('=><') THEN
        //    INIT;
    end;
}
