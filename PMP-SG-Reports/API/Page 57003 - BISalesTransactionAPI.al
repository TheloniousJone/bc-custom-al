/*
#001RL - 16 Sep 2022 Added Batch

*/

page 57003 BISalesTransactionAPI
{

    ApplicationArea = All;
    Caption = 'BISalesTransactionAPI';
    PageType = List;
    SourceTable = "Value Entry";
    //SourceTableTemporary = true;
    SourceTableView = sorting("Item Ledger Entry No.", "Entry Type") order(ascending) where("Entry Type" = const("Direct Cost"), "Document Type" = filter("Sales Invoice" | "Sales Credit Memo"));
    UsageCategory = History;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sales Order#"; SONo)
                {
                    ApplicationArea = all;
                }
                field("Invoice #"; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Unique ID"; '')
                {
                    ApplicationArea = all;
                }
                field(SOURCETYPE; 'BC')
                {
                    ApplicationArea = all;
                }
                field(DATEID; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Company; Rec.CurrentCompany)
                {
                    ApplicationArea = all;
                }
                field("Item number"; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Ship to Account"; ShipToAccount)
                {
                    ApplicationArea = all;
                }
                field("Customer Bill To Account"; BillToAccount)
                {
                    ApplicationArea = all;
                }
                field(CURRENCYID; CurrCode)
                {
                    ApplicationArea = all;
                }
                field(SALES_Qty; SalesQty)
                {
                    ApplicationArea = all;
                }
                field(SALES_BONUSQTY; FOCQty)
                {
                    ApplicationArea = all;
                }
                field(ToDelAmt; ToDelAmt)
                {
                    ApplicationArea = all;
                }
                field(SALES_GROSSAMOUNT; Rec."Sales Amount (Actual)" - Rec."Discount Amount")//RL 25 Nov - change sign
                {
                    ApplicationArea = all;
                }
                //RL    25 Nov 2021 - change field
                field(SALES_DISCOUNT; Rec."Discount Amount")
                {
                    ApplicationArea = all;
                }
                //field(SALES_DISCOUNT; SalesDisc)
                // {
                //     ApplicationArea = all;
                // }
                //RL    25 Nov 2021 - change field
                field(SALES_AMOUNT; Rec."Sales Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field(COGS; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field(OnlineSales; OnlineSales)
                {
                    ApplicationArea = All;
                }
                field(Batch; Batch)
                {
                    ApplicationArea = All;

                }//#001RL
                field(DistrubuterID; DistrubuterID)
                {
                    ApplicationArea = All;
                }
                field("PO_Ref"; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                //DX        14 Dec 2024
                field(bill_to_guid; BilltoGUID)
                {

                }
                //RL 10 Feb 2023
                //DX        14 Dec 2024
                field(ship_to_guid; ShipToGuid)
                {

                }
                //DX        14 Dec 2024
                //DX        14 Dec 2024

                // Add system last modified at field // Begin
                field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                }
                // Add system last modified at field // End
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //LoadData();
    end;

    local procedure LoadData()
    var
        myInt: Integer;
        VLERec: Record "Value Entry";
    begin
        VLERec.reset;
        VLERec.SetFilter("Document Type", '%1|%2', VLERec."Document Type"::"Sales Invoice", VLERec."Document Type"::"Sales Credit Memo");
        VLERec.SetRange("Entry Type", VLERec."Entry Type"::"Direct Cost");
        //VLERec.SetFilter("Posting Date", '%1..%2', CalcDate('<-6M>', Today), Today);
        if VLERec.FindSet() then
            repeat
                Rec.reset;
                Rec.init;
                rec.Copy(VLERec);
                rec.Insert(FALSE);
            until VLERec.next = 0;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SIHRec: Record "Sales Invoice Header";
        SCHRec: Record "Sales Cr.Memo Header";
        SILRec: Record "Sales Invoice Line";
        SCLRec: Record "Sales Cr.Memo Line";
        SSHRec: Record "Sales Shipment Header";
        SSLRec: Record "Sales Shipment Line";
        ILERec: Record "Item Ledger Entry";
        BatchILERec: Record "Item Ledger Entry";//#001RL
        CustRec: Record customer;
        ShipToRec: Record "Ship-to Address";
    begin

        //DX        14 Dec 2024 Additional fields
        clear(ShipToGuid);
        clear(BilltoGUID);
        CustRec.reset;
        CustRec.SetLoadFields("No.", SystemId);
        CustRec.SetCurrentKey("No.");
        CustRec.SetRange("No.", Rec."Source No.");
        if CustRec.FindFirst() then
            BilltoGUID := format(CustRec.SystemId);
        //DX        14 Dec 2024
        SONo := '';
        CurrCode := '';
        //DX        12 Nov 2021 Store unique combination and check if exist before, if new, then get qty, else set to 0.
        SalesQty := 0;
        FOCQty := 0;
        SalesDisc := 0;
        OnlineSales := false;
        if Rec.Adjustment = false then begin        //DX        14 Dec 2024     Additional condition after discussion with James and Chandran Team to remove duplicates
            if Rec."Document Type" = Rec."Document Type"::"Sales Invoice" then begin
                SIHRec.reset;
                SIHRec.SetLoadFields("No.", "Transaction Type", "Currency Code", "Order No.", "Sell-to Customer No.", "Bill-to Customer No.", "External Document No.", "Your Reference");    //DX        16 May 2023
                SIHRec.SetCurrentKey("No.");//DX        16 May 2023
                SIHRec.SetRange("No.", Rec."Document No.");
                if SIHRec.FindFirst() then begin
                    if SIHRec."Currency Code" = '' then begin
                        GLSetup.reset;
                        GLSetup.get;
                        CurrCode := GLSetup."LCY Code";
                    end else
                        CurrCode := SIHRec."Currency Code";
                    SONo := SIHRec."Order No.";
                    //ShipToAccount := SIHRec."Bill-to Customer No." + '_' + SIHRec."Sell-to Customer No.";
                    BillToAccount := SIHRec."Bill-to Customer No.";
                    ShipToAccount := SIHRec."Sell-to Customer No.";
                    //RL 9 Dec 2021
                    if (CopyStr(SIHRec."External Document No.", 1, 2) = 'P-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'P3-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'W1-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'P5-') or
                    (CopyStr(SIHRec."Your Reference", 1, 2) = 'P-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'P3-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'W1-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'P5-') then
                        OnlineSales := true;
                    //RL 9 Dec 2021

                    DistrubuterID := SIHRec."Transaction Type";
                end;
                SILRec.reset;
                SILRec.SetLoadFields("Document No.", "Line No.", "Qty To Deliver", "FOC Qty To Deliver", "Qty. per Unit of Measure", "Line Discount Amount", "Quantity (Base)");   //DX        16 May 2023
                SILRec.SetCurrentKey("Document No.", "Line No.");    //DX        16 May 2023
                SILRec.SetRange("Document No.", Rec."Document No.");
                SILRec.SetRange("Line No.", rec."Document Line No.");
                if SILRec.FindFirst() then begin
                    SalesQty := SILRec."Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                    FOCQty := SILRec."FOC Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                    ToDelAmt := SILRec."To Del. Amt";
                    //RL 13 Dec 2021

                    if SalesQty = 0 then begin
                        ILERec.reset;
                        ILERec.SetLoadFields("Entry No.", "Document Type", "Document No.", "Document Line No.");   //DX        16 May 2023
                        ILERec.Get(rec."Item Ledger Entry No.");
                        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then
                            if SSLRec.Get(ILERec."Document No.", ILERec."Document Line No.") then begin
                                SalesQty := SSLRec."Qty To Deliver" * SSLRec."Qty. per Unit of Measure";

                            end;

                    end;
                    if FOCQty = 0 then begin
                        ILERec.reset;
                        ILERec.SetLoadFields("Entry No.", "Document Type", "Document No.", "Document Line No.");   //DX        16 May 2023
                        ILERec.Get(rec."Item Ledger Entry No.");
                        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then
                            if SSLRec.Get(ILERec."Document No.", ILERec."Document Line No.") then begin
                                FOCQty := SSLRec."FOC (Qty) To Deliver" * SSLRec."Qty. per Unit of Measure";
                            end;
                    end;

                    if (SalesQty = 0) and (FOCQty = 0) then //RL 26 Apr 2022
                        SalesQty := SILRec."Quantity (Base)";

                    //     FOCQty := SILRec."FOC Qty" * SILRec."Qty. per Unit of Measure";
                    //RL 13 Dec 2021
                    SalesDisc := SILRec."Line Discount Amount";
                end;
            end else
                if Rec."Document Type" = Rec."Document Type"::"Sales Credit Memo" then begin
                    SCHRec.reset;
                    SCHRec.SetLoadFields("No.", "Bill-to Customer No.", "Return Order No.", "Sell-to Customer No.", "Transaction Type");   //DX        16 May 2023
                    SCHRec.SetRange("No.", Rec."Document No.");
                    if SCHRec.FindFirst() then begin
                        if SIHRec."Currency Code" = '' then begin
                            GLSetup.reset;
                            GLSetup.get;
                            CurrCode := GLSetup."LCY Code";
                        end else
                            CurrCode := SIHRec."Currency Code";

                        SONo := SCHRec."Return Order No.";
                        BillToAccount := SCHRec."Bill-to Customer No.";
                        ShipToAccount := SCHRec."Sell-to Customer No.";
                        DistrubuterID := SCHRec."Transaction Type";
                    end;
                    SCLRec.reset;
                    SCLRec.SetLoadFields("Document No.", "Line No.", "Qty To Deliver", "Order Qty", "FOC (Qty) To Deliver", "Line Discount Amount", "FOC Qty", "Qty. per Unit of Measure", "Quantity (Base)");    //DX        16 May 2023
                    SCLRec.SetCurrentKey("Document No.", "Line No.");        //DX        16 May 2023
                    SCLRec.SetRange("Document No.", Rec."Document No.");
                    SCLRec.SetRange("Line No.", Rec."Document Line No.");
                    if SCLRec.FindFirst() then begin
                        SalesQty := SCLRec."Qty To Deliver" * SCLRec."Qty. per Unit of Measure";
                        FOCQty := SCLRec."FOC (Qty) To Deliver" * SCLRec."Qty. per Unit of Measure";
                        SalesDisc := SCLRec."Line Discount Amount" * SCLRec."Qty. per Unit of Measure";
                        if SalesQty = 0 then
                            SalesQty := SCLRec."Order Qty" * SCLRec."Qty. per Unit of Measure";
                        if FOCQty = 0 then
                            FOCQty := SCLRec."FOC Qty" * SCLRec."Qty. per Unit of Measure";
                        if (SalesQty = 0) and (FOCQty = 0) then
                            SalesQty := SCLRec."Quantity (Base)";
                        // YF 22 Nov 2021 // Bug Fix
                        SalesQty := SalesQty * -1;
                        FOCQty := FOCQty * -1;
                        // YF 22 Nov 2021 // Bug Fix
                    end;
                end;
        end else begin      //DX 27 Mar 2026    To add in logic based on dennis / Jessica support for ship to and bill to
            if Rec."Document Type" = Rec."Document Type"::"Sales Invoice" then begin
                SIHRec.reset;
                SIHRec.SetLoadFields("No.", "Transaction Type", "Currency Code", "Order No.", "Sell-to Customer No.", "Bill-to Customer No.", "External Document No.", "Your Reference");    //DX        16 May 2023
                SIHRec.SetCurrentKey("No.");//DX        16 May 2023
                SIHRec.SetRange("No.", Rec."Document No.");
                if SIHRec.FindFirst() then begin
                    if SIHRec."Currency Code" = '' then begin
                        GLSetup.reset;
                        GLSetup.SetLoadFields("LCY Code");
                        GLSetup.get;
                        CurrCode := GLSetup."LCY Code";
                    end else
                        CurrCode := SIHRec."Currency Code";
                    SONo := SIHRec."Order No.";
                    //ShipToAccount := SIHRec."Bill-to Customer No." + '_' + SIHRec."Sell-to Customer No.";
                    BillToAccount := SIHRec."Bill-to Customer No.";
                    ShipToAccount := SIHRec."Sell-to Customer No.";
                    //RL 9 Dec 2021
                    if (CopyStr(SIHRec."External Document No.", 1, 2) = 'P-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'P3-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'W1-') or (CopyStr(SIHRec."External Document No.", 1, 3) = 'P5-') or
                    (CopyStr(SIHRec."Your Reference", 1, 2) = 'P-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'P3-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'W1-') or (CopyStr(SIHRec."Your Reference", 1, 3) = 'P5-') then
                        OnlineSales := true;
                    //RL 9 Dec 2021

                    DistrubuterID := SIHRec."Transaction Type";
                end;
            end else if Rec."Document Type" = Rec."Document Type"::"Sales Credit Memo" then begin
                SCHRec.reset;
                SCHRec.SetLoadFields("No.", "Bill-to Customer No.", "Return Order No.", "Sell-to Customer No.", "Transaction Type");   //DX        16 May 2023
                SCHRec.SetRange("No.", Rec."Document No.");
                if SCHRec.FindFirst() then begin
                    if SIHRec."Currency Code" = '' then begin
                        GLSetup.reset;
                        GLSetup.SetLoadFields("LCY Code");
                        GLSetup.get;

                        CurrCode := GLSetup."LCY Code";
                    end else
                        CurrCode := SIHRec."Currency Code";

                    SONo := SCHRec."Return Order No.";
                    BillToAccount := SCHRec."Bill-to Customer No.";
                    ShipToAccount := SCHRec."Sell-to Customer No.";
                    DistrubuterID := SCHRec."Transaction Type";
                end;

            end;
        end;

        //DX        21 Dec 2024
        CustRec.reset;
        CustRec.SetLoadFields("No.", SystemId);
        CustRec.SetCurrentKey("No.");
        CustRec.SetRange("No.", ShipToAccount);
        if CustRec.FindFirst() then
            ShipToGuid := format(CustRec.SystemId);
        //DX        21 Dec 2024
        /*
                if Rec."Item Ledger Entry Quantity" = 0 then begin
                    SalesQty := 0;
                    FOCQty := 0;
                    SalesDisc := 0;
                end;
        */
        //#001RL - Start
        BatchILERec.Reset();
        BatchILERec.SetLoadFields("Entry No.", "Lot No.");       //DX        17 May 2023
        if BatchILERec.Get(Rec."Item Ledger Entry No.") then
            Batch := BatchILERec."Lot No.";
        //#001RL - End

        TempDocLine.reset;
        TempDocLine.SetLoadFields("Document Type", "Document No.", "Document Line No.");
        TempDocLine.SetRange("Document Type", Rec."Document Type");
        TempDocLine.SetRange("Document No.", Rec."Document No.");
        TempDocLine.SetRange("Document Line No.", Rec."Document Line No.");
        if not (TempDocLine.FindFirst()) then begin
            TempDocLine2.reset;
            TempDocLine2."Entry No." := Rec."Entry No.";
            TempDocLine2."Document Type" := Rec."Document Type";
            TempDocLine2."Document No." := Rec."Document No.";
            TempDocLine2."Document Line No." := Rec."Document Line No.";
            TempDocLine2.insert(FALSE);
            TempDocLine.Copy(TempDocLine2);
            TempDocLine.Insert(FALSE);
        end else begin
            SalesQty := 0;
            FOCQty := 0;
            SalesDisc := 0;
        end;

    end;

    var
        SONo: Code[20];
        ShipToAccount: Code[50];
        BillToAccount: Code[50];
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[20];
        SalesQty: Decimal;
        FOCQty: Decimal;
        SalesDisc: Decimal;
        ToDelAmt: Decimal;
        TempDocLine: Record "Value Entry" temporary;
        TempDocLine2: Record "Value Entry" temporary;
        OnlineSales: Boolean;
        Batch: Code[20];
        DistrubuterID: Code[10];
        //DX        14 Dec 2024
        BilltoGUID: text[100];
        ShipToGuid: text[100];
}
