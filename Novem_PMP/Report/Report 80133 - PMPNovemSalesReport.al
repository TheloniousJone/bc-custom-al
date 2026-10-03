report 80133 "PMP Novem Sales Report"
{
    ApplicationArea = All;
    Caption = 'PMP Novem Sales Report';

    RDLCLayout = './ReportLayout/Rpt80133-PMP Novem Sales Report.rdl';

    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type" = const(Sale), "Document Type" = Filter('Sales Shipment'), "Source Type" = filter('Customer'), "Source No." = const('N071'));
            RequestFilterFields = "Posting Date";

            column(PostingDate; Format("Posting Date"))
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(ItemName; ItemName)
            {

            }
            column(ItemComGrp; ItemComGrp)
            {

            }
            column(CustNo; CustNo)
            {

            }
            column(CUstName; CUstName)
            {

            }
            column(HypSalesRep; HypSalesRep)
            {

            }
            column(WSSalesRep; WSSalesRep)
            {

            }
            column(HBSalesRep; HBSalesRep)
            {

            }
            column(ProdSalesRep; ProdSalesRep)
            {

            }
            column(CustCommGrp; CustCommGrp)
            {

            }
            column(CustGrp; CustGrp)
            {

            }
            column(Qty; Qty)
            {

            }
            column(FOCQty; FOCQty)
            {

            }
            column(Cost_Amount__Actual_; CostAmt)
            {

            }
            column(Sales_Amount__Actual_; SalesAmt)
            {

            }
            column(Principal; Principal)
            {

            }
            column(FilterReq; FilterReq)
            {

            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
            column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code") { }
            column(Shortcut_Dimension_5_Code; "Shortcut Dimension 5 Code") { }
            column(Shortcut_Dimension_6_Code; "Shortcut Dimension 6 Code") { }
            column(Shortcut_Dimension_7_Code; "Shortcut Dimension 7 Code") { }
            column(Shortcut_Dimension_8_Code; "Shortcut Dimension 8 Code") { }
            column(SONo; SONo) { }
            column(LineRemarks; LineRemarks) { }    //DX        07 Jun 2023
            column(ProcessBy; ProcessBy) { }      //DX        14 Jun 2023


            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                NovemVLE: Record "Value Entry";
            begin
                ItemComGrp := '';
                ItemName := '';
                CustGrp := '';
                CUstName := '';
                CustNo := '';
                ProdSalesRep := '';
                CustCommGrp := '';
                HBSalesRep := '';
                WSSalesRep := '';
                Principal := '';
                ItemRec.reset;
                ItemRec.SetRange("No.", "Item No.");
                if ItemRec.FindFirst() then begin
                    ItemName := ItemRec.Description;
                    ItemComGrp := ItemRec."Item Commission Group";
                    Principal := ItemRec.Principal;
                end;
                /*
                CustRec.reset;
                CustRec.SetRange("No.", "Source No.");
                if CustRec.FindFirst() then begin
                    CustCommgrp := CustRec."Customer Commission Group";
                    CustNo := CustRec."No.";
                    CUstName := CustRec.Name;
                    CustGrp := custrec."Customer Group";
                    HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                    HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                    WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
                end;
                */
                ProdSalesRep := GetProductSalesRep("Item No.", ItemComGrp, CustNo, CustCommGrp);
                Qty := 0;
                FOCQty := 0;

                SILRec.reset;
                SILRec.SetLoadFields("I9G Remarks", Quantity, "Quantity (Base)", "Qty. per Unit of Measure", "Order Qty", "FOC Qty", "FOC Qty Delivered", "FOC Qty To Deliver");       //DX        07 Jun 2023
                SILRec.SetRange("Document No.", "Document No.");
                SILRec.SetRange("Line No.", "Document Line No.");
                if SILRec.FindFirst() then begin
                    //DX        07 Jun 2023
                    LineRemarks := SILRec."I9G Remarks";
                    // YF 15 Aug 2022 // Patch
                    if (SILRec."Qty To Deliver" = 0) and (SILRec."FOC Qty To Deliver" = 0) then begin
                        if SILRec."Quantity (Base)" > SILRec."Order Qty" then begin
                            Qty := SILRec."Order Qty" * SILRec."Qty. per Unit of Measure";
                            ;
                            FOCQty := SILRec."Quantity (Base)" - (SILRec."Order Qty" * SILRec."Qty. per Unit of Measure");
                        end
                        else begin
                            Qty := SILRec."Quantity (Base)";
                            FOCQty := 0;
                        end;
                    end else begin
                        //RL 06 April 2022 - End
                        Qty := SILRec."Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                        FOCQty := SILRec."FOC Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                        if Qty = 0 then
                            Qty := SILRec."Order Qty" * SILRec."Qty. per Unit of Measure";
                        if FOCQty = 0 then
                            FOCQty := SILRec."FOC Qty" * SILRec."Qty. per Unit of Measure";
                    end;

                    //RL 20 Oct 2022
                    SONo := '';
                    SIHRec.reset;
                    SIHRec.SetLoadFields("No.", "SO Placed By");
                    SIHRec.SetRange("No.", "Document No.");
                    if SIHRec.FindFirst() then begin
                        SONo := SIHRec."Order No.";
                    end;

                    //RL 20 Oct 2022
                    SalesShipmentLineRec.reset;
                    SalesShipmentLineRec.SetCurrentKey("Order No.");
                    SalesShipmentLineRec.SetLoadFields("Order No.");
                    SalesShipmentLineRec.ChangeCompany('Novem-NHC');
                    SalesShipmentLineRec.SetRange("Order No.", SONo);
                    if SalesShipmentLineRec.FindFirst() then begin
                        CustRec.reset;
                        CustRec.ChangeCompany('Novem-NHC');
                        CustRec.SetRange("No.", SalesShipmentLineRec."Sell-to Customer No.");
                        if CustRec.FindFirst() then begin
                            CustCommgrp := CustRec."Customer Commission Group";
                            CustNo := CustRec."No.";
                            CUstName := CustRec.Name + ' ' + CustRec."Branch/Subsidiary";
                            CustGrp := custrec."Customer Group";
                            HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                            HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                            WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
                        end;

                        NovemVLE.reset;
                        NovemVLE.SetLoadFields("Document Type", "Document No.", "Document Line No.", "Cost Amount (Actual)", "Sales Amount (Actual)");
                        NovemVLE.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                        NovemVLE.SetRange("Document Type", NovemVLE."Document Type"::"Sales Shipment");
                        NovemVLE.SetRange("Document No.", SalesShipmentLineRec."Document No.");
                        NovemVLE.SetRange("Document Line No.", SalesShipmentLineRec."Line No.");
                        if NovemVLE.FindFirst() then begin
                            clear(CostAmt);
                            clear(SalesAmt);
                            CostAmt := NovemVLE."Cost Amount (Actual)";
                            SalesAmt := NovemVLE."Sales Amount (Actual)";
                        end;
                    end;

                    // if "Document Type" = "Document Type"::"Sales Invoice" then begin
                    //     SILRec.reset;
                    //     SILRec.SetLoadFields("I9G Remarks", Quantity, "Quantity (Base)", "Qty. per Unit of Measure", "Order Qty", "FOC Qty", "FOC Qty Delivered", "FOC Qty To Deliver");       //DX        07 Jun 2023
                    //     SILRec.SetRange("Document No.", "Document No.");
                    //     SILRec.SetRange("Line No.", "Document Line No.");
                    //     if SILRec.FindFirst() then begin
                    //         //DX        07 Jun 2023
                    //         LineRemarks := SILRec."I9G Remarks";
                    //         // YF 15 Aug 2022 // Patch
                    //         if (SILRec."Qty To Deliver" = 0) and (SILRec."FOC Qty To Deliver" = 0) then begin
                    //             if SILRec."Quantity (Base)" > SILRec."Order Qty" then begin
                    //                 Qty := SILRec."Order Qty" * SILRec."Qty. per Unit of Measure";
                    //                 ;
                    //                 FOCQty := SILRec."Quantity (Base)" - (SILRec."Order Qty" * SILRec."Qty. per Unit of Measure");
                    //             end
                    //             else begin
                    //                 Qty := SILRec."Quantity (Base)";
                    //                 FOCQty := 0;
                    //             end;
                    //         end else begin
                    //             //RL 06 April 2022 - End
                    //             Qty := SILRec."Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                    //             FOCQty := SILRec."FOC Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                    //             if Qty = 0 then
                    //                 Qty := SILRec."Order Qty" * SILRec."Qty. per Unit of Measure";
                    //             if FOCQty = 0 then
                    //                 FOCQty := SILRec."FOC Qty" * SILRec."Qty. per Unit of Measure";
                    //         end;

                    //         //RL 20 Oct 2022
                    //         SONo := '';
                    //         SIHRec.reset;
                    //         SIHRec.SetLoadFields("No.", "SO Placed By");
                    //         SIHRec.SetRange("No.", "Document No.");
                    //         if SIHRec.FindFirst() then begin
                    //             SONo := SIHRec."Order No.";
                    //         end;

                    //         //RL 20 Oct 2022
                    //         SIHRec.reset;
                    //         SIHRec.SetCurrentKey("Order No.");
                    //         SIHRec.SetLoadFields("Order No.");
                    //         SIHRec.ChangeCompany('Novem-NHC');
                    //         SIHRec.SetRange("Order No.", SONo);
                    //         if SIHRec.FindFirst() then begin
                    //             CustRec.reset;
                    //             CustRec.ChangeCompany('Novem-NHC');
                    //             CustRec.SetRange("No.", SIHRec."Sell-to Customer No.");
                    //             if CustRec.FindFirst() then begin
                    //                 CustCommgrp := CustRec."Customer Commission Group";
                    //                 CustNo := CustRec."No.";
                    //                 CUstName := CustRec.Name + ' ' + CustRec."Branch/Subsidiary";
                    //                 CustGrp := custrec."Customer Group";
                    //                 HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                    //                 HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                    //                 WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
                    //             end;

                    //             NovemVLE.reset;
                    //             NovemVLE.SetLoadFields("Document Type", "Document No.", "Document Line No.", "Cost Amount (Actual)", "Sales Amount (Actual)");
                    //             NovemVLE.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                    //             NovemVLE.SetRange("Document Type", NovemVLE."Document Type"::"Sales Invoice");
                    //             NovemVLE.SetRange("Document No.", SIHRec."No.");
                    //             NovemVLE.SetRange("Document Line No.", ValueEntry."Document Line No.");
                    //             if NovemVLE.FindFirst() then begin
                    //                 clear(CostAmt);
                    //                 clear(SalesAmt);
                    //                 CostAmt := NovemVLE."Cost Amount (Actual)";
                    //                 SalesAmt := NovemVLE."Sales Amount (Actual)";
                    //             end;
                    //         end;


                    //     end;
                    // end else
                    //     if "Document Type" = "Document Type"::"Sales Credit Memo" then begin
                    //         SCLRec.reset;
                    //         SCLRec.SetLoadFields("I9G Remarks", "FOC Qty", "Order Qty", "Qty. per Unit of Measure");   //DX        07 Jun 2023
                    //         SCLRec.SetRange("Document No.", "Document No.");
                    //         SCLRec.SetRange("Line No.", "Document Line No.");
                    //         if SCLRec.FindFirst() then begin
                    //             //DX        07 Jun 2023
                    //             LineRemarks := SCLRec."I9G Remarks";
                    //             Qty := SCLRec."Qty To Deliver" * -1;
                    //             FOCQty := (SCLRec."FOC (Qty) To Deliver" * SCLRec."Qty. per Unit of Measure") * -1;
                    //             if Qty = 0 then
                    //                 Qty := (SCLRec."Order Qty" * SCLRec."Qty. per Unit of Measure") * -1;
                    //             //RL 29 Nov 2021 - Start
                    //             // FOCQty := 0;
                    //             if FOCQty = 0 then
                    //                 FOCQty := (SCLRec."FOC Qty" * SCLRec."Qty. per Unit of Measure") * -1;
                    //             //RL 29 Nov 2021 - End

                    //             SONo := '';
                    //             SCHRec.reset;
                    //             SCHRec.SetLoadFields("No.", "SO Placed By");
                    //             SCHRec.SetRange("No.", "Document No.");
                    //             if SCHRec.FindFirst() then begin
                    //                 SONo := SCHRec."Return Order No.";
                    //             end;

                    //             SCHRec.reset;
                    //             SCHRec.SetCurrentKey("Return Order No.");
                    //             SCHRec.SetLoadFields("Return Order No.");
                    //             SCHRec.ChangeCompany('Novem-NHC');
                    //             SCHRec.SetRange("Return Order No.", SONo);
                    //             if SCHRec.FindFirst() then begin
                    //                 CustRec.reset;
                    //                 CustRec.ChangeCompany('Novem-NHC');
                    //                 CustRec.SetRange("No.", SCHRec."Sell-to Customer No.");
                    //                 if CustRec.FindFirst() then begin
                    //                     CustCommgrp := CustRec."Customer Commission Group";
                    //                     CustNo := CustRec."No.";
                    //                     CUstName := CustRec.Name + ' ' + CustRec."Branch/Subsidiary";
                    //                     CustGrp := custrec."Customer Group";
                    //                     HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                    //                     HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                    //                     WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
                    //                 end;
                    //                 NovemVLE.reset;
                    //                 NovemVLE.SetLoadFields("Document Type", "Document No.", "Document Line No.", "Cost Amount (Actual)", "Sales Amount (Actual)");
                    //                 NovemVLE.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                    //                 NovemVLE.SetRange("Document Type", NovemVLE."Document Type"::"Sales Credit Memo");
                    //                 NovemVLE.SetRange("Document No.", SCHRec."No.");
                    //                 NovemVLE.SetRange("Document Line No.", ValueEntry."Document Line No.");
                    //                 if NovemVLE.FindFirst() then begin
                    //                     clear(CostAmt);
                    //                     clear(SalesAmt);
                    //                     CostAmt := NovemVLE."Cost Amount (Actual)";
                    //                     SalesAmt := NovemVLE."Sales Amount (Actual)";
                    //                 end;
                    //             end;

                    //         end;
                    //     end;
                    // //RL 18 Oct 2022
                    // if Adjustment = true then begin
                    //     Qty := 0;
                    //     FOCQty := 0;
                    // end;
                    //RL 18 Oct 2022

                    //DX        12 Nov 2021
                    /*
                    if ValueEntry."Item Ledger Entry Quantity" = 0 then begin
                        Qty := 0;
                        FOCQty := 0;
                    end;
                    */
                    TempDocLine.reset;
                    TempDocLine.SetRange("Document Type", "Item Ledger Entry"."Document Type");
                    TempDocLine.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                    TempDocLine.SetRange("Document Line No.", "Item Ledger Entry"."Document Line No.");
                    //TempDocLine.SetAscending("Entry No.", true);
                    if not (TempDocLine.FindFirst()) then begin
                        TempDocLine2.reset;
                        TempDocLine2."Entry No." := "Item Ledger Entry"."Entry No.";
                        TempDocLine2."Document Type" := "Item Ledger Entry"."Document Type";
                        TempDocLine2."Document No." := "Item Ledger Entry"."Document No.";
                        TempDocLine2."Document Line No." := "Item Ledger Entry"."Document Line No.";
                        TempDocLine2.insert(FALSE);
                        TempDocLine.Copy(TempDocLine2);
                        TempDocLine.Insert(FALSE);
                    end else begin
                        Qty := 0;
                        FOCQty := 0;
                        //                    SalesDisc := 0;

                    end;
                    //DX        12 Nov 2021
                end;
            END;
        }
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

    local procedure GetProductSalesRep(ItemNo: Code[20]; ItemComGrp: Code[50]; CustNo: Code[20]; CustCommGrp: Code[50]) RepCode: Code[50]
    var
        myInt: Integer;
        ProductRepTag: Record "Product Rep Tagging";
    begin
        ProductRepTag.reset;
        // ProductRepTag.SetRange("Item Code", ItemNo);
        if ProductRepTag.FindSet() then
            repeat
                if (ProductRepTag."Item Relation" = ProductRepTag."Item Relation"::Specific) AND
                    (ProductRepTag."Item Code" = ItemNo) AND
                    (ProductRepTag."Customer Relation" = ProductRepTag."Customer Relation"::Specific) AND
                    (ProductRepTag."Customer Code" = CustNo) then begin
                    exit(ProductRepTag."Sales Rep. Code");
                end else
                    if (ProductRepTag."Item Relation" = ProductRepTag."Item Relation"::Specific) AND
                        (ProductRepTag."Item Code" = ItemNo) AND
                        (ProductRepTag."Customer Relation" = ProductRepTag."Customer Relation"::Group) AND
                        (ProductRepTag."Customer Code" = CustCommGrp) then begin
                        exit(ProductRepTag."Sales Rep. Code");
                    end else
                        if (ProductRepTag."Item Relation" = ProductRepTag."Item Relation"::Group) AND
                            (ProductRepTag."Item Code" = ItemComGrp) AND
                            (ProductRepTag."Customer Relation" = ProductRepTag."Customer Relation"::Specific) AND
                            (ProductRepTag."Customer Code" = CustNo) then begin
                            exit(ProductRepTag."Sales Rep. Code");
                        end else
                            if (ProductRepTag."Item Relation" = ProductRepTag."Item Relation"::Group) AND
                                (ProductRepTag."Item Code" = ItemComGrp) AND
                                (ProductRepTag."Customer Relation" = ProductRepTag."Customer Relation"::Group) AND
                                (ProductRepTag."Customer Code" = CustCommGrp) then begin
                                exit(ProductRepTag."Sales Rep. Code");
                            end;
            until ProductRepTag.next = 0;
    end;


    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        FilterReq := "Item Ledger Entry".GetFilters;
    end;

    var
        FilterReq: text[200];
        ItemRec: Record item;
        CustNo: Code[20];
        CustRec: Record customer;
        ItemComGrp: Code[50];
        CustCommGrp: Code[50];

        CUstName: Text[200];
        ItemName: Text[100];
        CustGrp: Code[50];
        HypSalesRep: Code[50];
        WSSalesRep: Code[50];
        HBSalesRep: Code[50];
        ProdSalesRep: Code[50];
        Qty: Decimal;
        FOCQty: Decimal;
        SILRec: Record "Sales Invoice Line";
        SCLRec: Record "Sales Cr.Memo Line";
        SalesShipmentLineRec: Record "Sales Shipment Line";
        Principal: Text[100];
        TempDocLine: Record "Item Ledger Entry" temporary;
        TempDocLine2: Record "Item Ledger Entry" temporary;

        SONo: Code[20];
        SIHRec: Record "Sales Invoice Header";
        SCHRec: Record "Sales Cr.Memo Header";
        LineRemarks: Text[100];
        ProcessBy: Text[100];        //DX        14 Jun 2023
        CostAmt: Decimal;
        SalesAmt: Decimal;
}
