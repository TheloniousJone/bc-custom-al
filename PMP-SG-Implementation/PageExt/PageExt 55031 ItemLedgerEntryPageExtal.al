pageextension 55031 "ItemLedgerEntryPageExt.al" extends "Item Ledger Entries"
{
    layout
    {
        //DX        17 Aug 2021
        addbefore(Quantity)
        {
            field(DocDate; DocDate)
            {
                Caption = 'Inv. Document Date';
                ApplicationArea = all;
                Editable = false;
            }
            field(Qty; Qty)
            {
                ApplicationArea = all;
                Caption = 'Order Qty';
            }
            field(FOCQty; FOCQty)
            {
                ApplicationArea = all;
                Caption = 'FOC Qty';
            }
            field(OrderNo; OrderNo)
            {
                ApplicationArea = all;
                Caption = 'Order NO.';
            }
            field(InvNo; InvNo)
            {
                ApplicationArea = all;
                Caption = 'Invoice No.';
            }
            field(ExtDocNo; ExtDocNo)
            {
                ApplicationArea = All;
                Caption = 'External Doc No.';
            }
            field(SourceName; SourceName)
            {
                ApplicationArea = all;
            }
            field(SourceNo; SourceNo)
            {
                ApplicationArea = all;
            }
            field(UnitPrice; UnitPrice)
            {
                ApplicationArea = all;

            }
            field(unitCost; unitCost)
            {
                ApplicationArea = all;
                Caption = 'Unit Cost';
            }
            //RL        11 Jan 2022
            field(ActualPrice; ActualPrice)
            {
                ApplicationArea = all;
                Caption = 'Actual Price';
            }

            field("I9G_Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
                Caption = 'Source No.';
            }

            field("I9G_Source Type"; Rec."Source Type")
            {
                ApplicationArea = all;
                Caption = 'Source Type';
            }

            field(DefaultVendor; DefaultVendor)
            {
                ApplicationArea = all;
                Caption = 'Default Vendor';
            }
        }
        //DX        17 Aug 2021
        addafter("Lot No.")
        {
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
        }
        //RL    12 Jan 2022
        addafter(Description)
        {
            //RL 23 Feb 2022
            field(Principal; Principal)
            {
                ApplicationArea = all;
            }
            //RL 23 Feb 2022
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
        //RL    12 Jan 2022

        //RL 22 Aug 2022
        addlast(Control1)
        {
            field(I9G_GLAccount; GLAccount)
            {
                ApplicationArea = All;
                Caption = 'G/L Account';
            }

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

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        VLERec: Record "Value Entry";
        CustRec: Record customer;
        VendRec: Record vendor;
        ItemRec: Record Item;
        GenPostingSetup: Record "General Posting Setup";
        PRRec: Record "Purch. Rcpt. Line";//DX      30 May 2023
        SHRec: Record "Sales Shipment Header";
        PHRec: Record "Purch. Rcpt. Header";
        SLRec: Record "Sales Shipment Line";      //DX      30 May 2023
        SinvHRec: Record "Sales Invoice Header";
        SinvLRec: Record "Sales Invoice Line";
        ScnHRec: Record "Sales Cr.Memo Header";
        ScnLRec: Record "Sales Cr.Memo Line";
        SrrHRec: Record "Return Receipt Header";
        SrrLRec: Record "Return Receipt Line";
        PinvHRec: Record "Purch. Inv. Header";
        PinvLRec: Record "Purch. Inv. Line";
        PcnHRec: Record "Purch. Cr. Memo Hdr.";
        PcnLRec: Record "Purch. Cr. Memo Line";
        PrsHRec: Record "Return Shipment Header";
        PrsLRec: Record "Return Shipment Line";
    begin
        //DX        17 Aug 2021
        //FOCQty := EnhanceCU.GetFOCQty(Rec);
        //Qty := EnhanceCU.GetOrderQty(Rec);
        //InvNo := EnhanceCU.GetInvNo(Rec);     //DX        30 may 2023
        InvNo := '';        //DX        30 May 2023 shift get inv no to bottom procedure to recduce 1 SQL
        GLAccount := '';
        clear(FOCQty);     //DX        30 may 2023
        clear(Qty);        //DX        30 may 2023
        clear(OrderNo);
        //OrderNo := EnhanceCU.GetOrderNo(Rec);
        clear(ActualPrice);
        //ActualPrice := EnhanceCU.GetActualPrice(Rec);//RL        11 Jan 2022
        //DX        17 Aug 2021
        //DX       30 May 2023     Shift get function
        case Rec."Entry Type" of
            Rec."Entry Type"::Sale:
                begin
                    case Rec."Document Type" of
                        Rec."Document Type"::"Sales Shipment":
                            begin
                                SLRec.reset;
                                SLRec.SetLoadFields("Document No.", "Line No.", "Selling Price", Quantity, "FOC Qty"); //DX    24 May 2023
                                SLRec.SetRange("Document No.", Rec."Document No.");
                                SLRec.SetRange("Line No.", Rec."Document Line No.");
                                if SLRec.FindFirst() then begin
                                    FOCQty := SLRec."FOC Qty";
                                    Qty := SLRec."Order Qty";
                                    ActualPrice := SLRec."Selling Price";
                                end;
                                SHRec.reset;
                                SHRec.SetLoadFields("No.", "Order No.", "External Document No."); //DX    24 May 2023
                                SHRec.SetRange("No.", Rec."Document No.");
                                if SHRec.FindFirst() then BEGIN
                                    OrderNo := SHRec."Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Sales Invoice":
                            begin
                                SinvLRec.reset;
                                SinvLRec.SetLoadFields("Document No.", "Line No.", "Selling Price", Quantity, "FOC Qty"); //DX    24 May 2023
                                SinvLRec.SetRange("Document No.", Rec."Document No.");
                                SinvLRec.SetRange("Line No.", Rec."Document Line No.");
                                if SinvLRec.FindFirst() then begin
                                    FOCQty := SinvLRec."FOC Qty";
                                    Qty := SinvLRec."Order Qty";
                                    ActualPrice := SinvLRec."Selling Price";
                                end;
                                SinvHRec.reset;
                                SinvHRec.SetLoadFields("No.", "Order No.", "External Document No."); //DX    24 May 2023
                                SinvHRec.SetRange("No.", Rec."Document No.");
                                if SinvHRec.FindFirst() then BEGIN
                                    OrderNo := SinvHRec."Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Sales Return Receipt":
                            begin
                                SrrLRec.reset;
                                SrrLRec.SetLoadFields("Document No.", "Line No.", "Selling Price", Quantity, "FOC Qty"); //DX    24 May 2023
                                SrrLRec.SetRange("Document No.", Rec."Document No.");
                                SrrLRec.SetRange("Line No.", Rec."Document Line No.");
                                if SrrLRec.FindFirst() then begin
                                    FOCQty := SrrLRec."FOC Qty";
                                    Qty := SrrLRec."Order Qty";
                                    ActualPrice := SrrLRec."Selling Price";
                                end;
                                SrrHRec.reset;
                                SrrHRec.SetLoadFields("No.", "Return Order No.", "External Document No."); //DX    24 May 2023
                                SrrHRec.SetRange("No.", Rec."Document No.");
                                if SrrHRec.FindFirst() then BEGIN
                                    OrderNo := SrrHRec."Return Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Sales Credit Memo":
                            begin
                                ScnLRec.reset;
                                ScnLRec.SetLoadFields("Document No.", "Line No.", "Selling Price", Quantity, "FOC Qty"); //DX    24 May 2023
                                ScnLRec.SetRange("Document No.", Rec."Document No.");
                                ScnLRec.SetRange("Line No.", Rec."Document Line No.");
                                if ScnLRec.FindFirst() then begin
                                    FOCQty := ScnLRec."FOC Qty";
                                    Qty := ScnLRec."Order Qty";
                                    ActualPrice := ScnLRec."Selling Price";
                                end;
                                ScnHRec.reset;
                                ScnHRec.SetLoadFields("No.", "Return Order No.", "External Document No."); //DX    24 May 2023
                                ScnHRec.SetRange("No.", Rec."Document No.");
                                if ScnHRec.FindFirst() then BEGIN
                                    OrderNo := ScnHRec."Return Order No.";
                                end;
                            end;
                    end;
                end;

            Rec."Entry Type"::Purchase:
                begin
                    case Rec."Document Type" of
                        Rec."Document Type"::"Purchase Receipt":
                            begin
                                PRRec.reset;
                                PRRec.SetLoadFields("Document No.", "Line No.", "Purchase Price", "FOC Qty", Quantity);        //DX    24 May 2023
                                PRRec.SetRange("Document No.", Rec."Document No.");
                                PRRec.SetRange("Line No.", Rec."Document Line No.");
                                if PRRec.FindFirst() then begin
                                    FOCQty := PRRec."FOC Qty";
                                    Qty := PRRec."Order Qty";
                                    ActualPrice := PRRec."Purchase Price";
                                end;
                                PHRec.reset;
                                PHRec.SetLoadFields("No.", "Order No."); //DX    24 May 2023
                                PHRec.SetRange("No.", Rec."Document No.");
                                if PHRec.FindFirst() then BEGIN
                                    OrderNo := PHRec."Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Purchase Invoice":
                            begin
                                PinvLRec.reset;
                                PinvLRec.SetLoadFields("Document No.", "Line No.", "Purchase Price", "FOC Qty", Quantity);        //DX    24 May 2023
                                PinvLRec.SetRange("Document No.", Rec."Document No.");
                                PinvLRec.SetRange("Line No.", Rec."Document Line No.");
                                if PinvLRec.FindFirst() then begin
                                    FOCQty := PinvLRec."FOC Qty";
                                    Qty := PinvLRec."Order Qty";
                                    ActualPrice := PinvLRec."Purchase Price";
                                end;
                                PinvHRec.reset;
                                PinvHRec.SetLoadFields("No.", "Order No."); //DX    24 May 2023
                                PinvHRec.SetRange("No.", Rec."Document No.");
                                if PinvHRec.FindFirst() then BEGIN
                                    OrderNo := PinvHRec."Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Purchase Return Shipment":
                            begin
                                PrsLRec.reset;
                                PrsLRec.SetLoadFields("Document No.", "Line No.", "Purchase Price", "FOC Qty", Quantity);        //DX    24 May 2023
                                PrsLRec.SetRange("Document No.", Rec."Document No.");
                                PrsLRec.SetRange("Line No.", Rec."Document Line No.");
                                if PrsLRec.FindFirst() then begin
                                    FOCQty := PrsLRec."FOC Qty";
                                    Qty := PrsLRec."Order Qty";
                                    ActualPrice := PrsLRec."Purchase Price";
                                end;
                                PrsHRec.reset;
                                PrsHRec.SetLoadFields("No.", "Return Order No."); //DX    24 May 2023
                                PrsHRec.SetRange("No.", Rec."Document No.");
                                if PrsHRec.FindFirst() then BEGIN
                                    OrderNo := PrsHRec."Return Order No.";
                                end;
                            end;
                        Rec."Document Type"::"Purchase Credit Memo":
                            begin
                                PcnLRec.reset;
                                PcnLRec.SetLoadFields("Document No.", "Line No.", "Purchase Price", "FOC Qty", Quantity);        //DX    24 May 2023
                                PcnLRec.SetRange("Document No.", Rec."Document No.");
                                PcnLRec.SetRange("Line No.", Rec."Document Line No.");
                                if PcnLRec.FindFirst() then begin
                                    FOCQty := PcnLRec."FOC Qty";
                                    Qty := PcnLRec."Order Qty";
                                    ActualPrice := PcnLRec."Purchase Price";
                                end;
                                PcnHRec.reset;
                                PcnHRec.SetLoadFields("No.", "Return Order No."); //DX    24 May 2023
                                PcnHRec.SetRange("No.", Rec."Document No.");
                                if PcnHRec.FindFirst() then BEGIN
                                    OrderNo := PcnHRec."Return Order No.";
                                end;
                            end;
                    end;
                end;
        end;


        //DX        30 May 2023     Shifted get Inv No. to bottom section 
        VLERec.reset;
        VLERec.SetLoadFields("Item Ledger Entry No.", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Document Type", "External Document No.", "Document No.");     //DX    03 May 2023

        // YF 09 Jun 2025 // Task 1887
        if Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");

        if Rec."Document Type" = Rec."Document Type"::"Purchase Receipt" then
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Purchase Invoice");

        if Rec."Document Type" = Rec."Document Type"::"Sales Return Receipt" then
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Credit Memo");

        /*
        if Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then begin       //DX        05 June 2023 corrected the logic for filtering
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
        end else
            if Rec."Document Type" = Rec."Document Type"::"Purchase Receipt" then begin
                VLERec.SetRange("Document Type", VLERec."Document Type"::"Purchase Invoice");
            end;
        */
        // YF 09 Jun 2025 // Task 1887

        VLERec.SetCurrentKey("Item Ledger Entry No.");  //DX        24 May 2023
        VLERec.SetRange("Item Ledger Entry No.", Rec."Entry No.");
        if VLERec.FindFirst() then begin
            InvNo := VLERec."Document No.";
            DocDate := FORMAT(VLERec."Document Date");
            ExtDocNo := VLERec."External Document No.";
            GenPostingSetup.SetLoadFields("Gen. Bus. Posting Group", "Gen. Bus. Posting Group", "Sales Account");       //DX        03 May 2023
            GenPostingSetup.SetRange("Gen. Bus. Posting Group", VLERec."Gen. Bus. Posting Group");
            GenPostingSetup.SetRange("Gen. Prod. Posting Group", VLERec."Gen. Prod. Posting Group");
            if GenPostingSetup.FindSet() then
                GLAccount := GenPostingSetup."Sales Account";
        end else
            DocDate := '';
        //DX        30 May 2023     Shifted get Inv No. to above section 
        //DX        08 Sept 2021
        SourceName := '';
        SourceNo := '';
        UnitPrice := 0;
        unitCost := 0;
        if (Rec.Quantity <> 0) and (Rec."Sales Amount (Actual)" <> 0) then begin
            // UnitPrice := Rec."Sales Amount (Actual)" / qty;
            UnitPrice := Rec."Sales Amount (Actual)" / Rec.Quantity * Rec."Qty. per Unit of Measure";
        end;
        if (Rec.Quantity <> 0) and (Rec."Cost Amount (Actual)" <> 0) then begin
            // unitCost := Rec."Cost Amount (Actual)" / qty;
            unitCost := Rec."Cost Amount (Actual)" / Rec.Quantity * Rec."Qty. per Unit of Measure";
        end;
        if Rec."Source Type" = Rec."Source Type"::Customer then begin
            CustRec.reset;
            CustRec.SetLoadFields("No.", Name);      //DX        03 May 2023
            CustRec.SetRange("No.", rec."Source No.");
            if CustRec.FindFirst() then
                SourceName := CustRec.Name;
        end else
            if Rec."Source Type" = Rec."Source Type"::Vendor then begin
                VendRec.reset;
                VendRec.SetLoadFields(Name, "No.");      //DX        03 May 2023
                VendRec.SetRange("No.", Rec."Source No.");
                if VendRec.FindFirst() then
                    SourceName := VendRec.name;
            end;
        //DX        08 Sept 2021
        //RL
        Clear(DefaultVendor);
        Clear(Principal);
        ItemRec.reset;
        ItemRec.SetLoadFields("No.", "Vendor No.", Principal);    //DX        03 May 2023
        ItemRec.SetRange("No.", Rec."Item No.");
        if ItemRec.FindFirst() then begin
            DefaultVendor := ItemRec."Vendor No.";
            Principal := ItemRec.Principal;
        end;
    end;

    var
        FOCQty: Decimal;
        Qty:
                Decimal;
        InvNo:
                code[20];
        OrderNo:
                code[20];
        EnhanceCU:
                Codeunit "PMP-Enhancements";
        DocDate:
                Text[100];
        SourceNo:
                Code[20];
        SourceName:
                Text[100];
        UnitPrice:
                Decimal;
        unitCost:
                Decimal;
        ExtDocNo:
                Code[35];

        DefaultVendor:
                Code[20];
        ActualPrice:
                Decimal;
        Principal:
                Text[50];
        GLAccount:
                Code[20]; //RL 22 Aug 2022
}
