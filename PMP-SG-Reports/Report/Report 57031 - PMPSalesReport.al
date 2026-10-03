report 57031 "PMP Sales Report"
{
    ApplicationArea = All;
    Caption = 'Sales Report';

    RDLCLayout = './ReportLayouts/ReportLayout 57031 - PMP Sales Report.rdl';

    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ValueEntry; "Value Entry")
        {
            DataItemTableView = where("Entry Type" = filter('Direct Cost'), "Item Ledger Entry Type" = const(Sale), "Document Type" = Filter('Sales Invoice|Sales Credit Memo')); //RL  07 March 2022 - remove filter for adjusment
            // DataItemTableView = where("Entry Type" = filter('Direct Cost'), "Adjustment" = const(FALSE), "Item Ledger Entry Type" = const(Sale), "Document Type" = Filter('Sales Invoice|Sales Credit Memo')); 
            RequestFilterFields = "Document No.", "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code";

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
            column(Cost_Amount__Actual_; "Cost Amount (Actual)")
            {

            }
            column(Sales_Amount__Actual_; "Sales Amount (Actual)")
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

                if "Document Type" = "Document Type"::"Sales Invoice" then begin
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
                        /*
                        //RL 08 April 2022 - Start
                        if (SILRec."Qty To Deliver" = 0) and (SILRec."FOC Qty To Deliver" = 0) then begin
                            Qty := SILRec."Quantity (Base)";
                            FOCQty := 0;
                        end else begin
                            //RL 06 April 2022 - End
                            Qty := SILRec."Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                            FOCQty := SILRec."FOC Qty To Deliver" * SILRec."Qty. per Unit of Measure";
                            if Qty = 0 then
                                Qty := SILRec."Order Qty" * SILRec."Qty. per Unit of Measure";
                            if FOCQty = 0 then
                                FOCQty := SILRec."FOC Qty" * SILRec."Qty. per Unit of Measure";
                        end;
                        */
                        // YF 15 Aug 2022


                        CustRec.reset;
                        CustRec.SetRange("No.", SILRec."Sell-to Customer No.");
                        if CustRec.FindFirst() then begin
                            CustCommgrp := CustRec."Customer Commission Group";
                            CustNo := CustRec."No.";
                            CUstName := CustRec.Name + ' ' + CustRec."Branch/Subsidiary";
                            CustGrp := custrec."Customer Group";
                            HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                            HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                            WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
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
                    end;
                end else
                    if "Document Type" = "Document Type"::"Sales Credit Memo" then begin
                        SCLRec.reset;
                        SCLRec.SetLoadFields("I9G Remarks", "FOC Qty", "Order Qty", "Qty. per Unit of Measure");   //DX        07 Jun 2023
                        SCLRec.SetRange("Document No.", "Document No.");
                        SCLRec.SetRange("Line No.", "Document Line No.");
                        if SCLRec.FindFirst() then begin
                            //DX        07 Jun 2023
                            LineRemarks := SCLRec."I9G Remarks";
                            Qty := SCLRec."Qty To Deliver" * -1;
                            FOCQty := (SCLRec."FOC (Qty) To Deliver" * SCLRec."Qty. per Unit of Measure") * -1;
                            if Qty = 0 then
                                Qty := (SCLRec."Order Qty" * SCLRec."Qty. per Unit of Measure") * -1;
                            //RL 29 Nov 2021 - Start
                            // FOCQty := 0;
                            if FOCQty = 0 then
                                FOCQty := (SCLRec."FOC Qty" * SCLRec."Qty. per Unit of Measure") * -1;
                            //RL 29 Nov 2021 - End
                            CustRec.reset;
                            CustRec.SetRange("No.", SCLRec."Sell-to Customer No.");
                            if CustRec.FindFirst() then begin
                                CustCommgrp := CustRec."Customer Commission Group";
                                CustNo := CustRec."No.";
                                CUstName := CustRec.Name + ' ' + CustRec."Branch/Subsidiary";
                                CustGrp := custrec."Customer Group";
                                HypSalesRep := CustRec."Corporate  Sales Rep (HYP)";
                                HBSalesRep := CustRec."Corporate  Sales Rep (HB)";
                                WSSalesRep := CustRec."Corporate  Sales Rep (WS)";
                            end;
                        end;
                    end;
                //RL 18 Oct 2022
                if Adjustment = true then begin
                    Qty := 0;
                    FOCQty := 0;
                end;
                //RL 18 Oct 2022

                //DX        12 Nov 2021
                /*
                if ValueEntry."Item Ledger Entry Quantity" = 0 then begin
                    Qty := 0;
                    FOCQty := 0;
                end;
                */
                TempDocLine.reset;
                TempDocLine.SetRange("Document Type", ValueEntry."Document Type");
                TempDocLine.SetRange("Document No.", ValueEntry."Document No.");
                TempDocLine.SetRange("Document Line No.", ValueEntry."Document Line No.");
                //TempDocLine.SetAscending("Entry No.", true);
                if not (TempDocLine.FindFirst()) then begin
                    TempDocLine2.reset;
                    TempDocLine2."Entry No." := ValueEntry."Entry No.";
                    TempDocLine2."Document Type" := ValueEntry."Document Type";
                    TempDocLine2."Document No." := ValueEntry."Document No.";
                    TempDocLine2."Document Line No." := ValueEntry."Document Line No.";
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
        FilterReq := ValueEntry.GetFilters;
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
        Principal: Text[100];
        TempDocLine: Record "Value Entry" temporary;
        TempDocLine2: Record "Value Entry" temporary;

        SONo: Code[20];
        SIHRec: Record "Sales Invoice Header";
        LineRemarks: Text[100];
        ProcessBy: Text[100];        //DX        14 Jun 2023
}
