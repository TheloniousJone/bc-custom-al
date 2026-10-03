report 57102 "Assembly Order AL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57102 - Assembly Order AL.rdl';
    Caption = 'Assembly Order';

    dataset
    {
        dataitem("Assembly Header"; "Assembly Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Item No.", "Due Date";
            column(No_AssemblyHeader; "No.")
            {
            }
            column(ItemNo_AssemblyHeader; "Item No.")
            {
                IncludeCaption = true;
            }
            column(Description_AssemblyHeader; Description)
            {
                IncludeCaption = true;
            }
            column(Quantity_AssemblyHeader; Quantity)
            {
                IncludeCaption = true;
            }
            column(QuantityToAssemble_AssemblyHeader; "Quantity to Assemble")
            {
                IncludeCaption = true;
            }
            column(UnitOfMeasureCode_AssemblyHeader; "Unit of Measure Code")
            {
            }
            column(DueDate_AssemblyHeader; Format("Due Date"))
            {
            }
            column(StartingDate_AssemblyHeader; Format("Starting Date"))
            {
            }
            column(EndingDate_AssemblyHeader; Format("Ending Date"))
            {
            }
            column(LocationCode_AssemblyHeader; "Location Code")
            {
                IncludeCaption = true;
            }
            column(BinCode_AssemblyHeader; "Bin Code")
            {
                IncludeCaption = true;
            }
            column(SalesDocNo; SalesDocNo)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(CompPic; CompanyInfo.Picture)
            {
            }
            column(HLotNo; HLotNo)
            {
            }
            column(Expdate; Expdate)
            { }
            column(remarks; remarks)
            {
            }
            column(PackInstr; "Assembly Header"."Packing Instructions")
            {

            }
            column(Vendor_No; "Vendor No") { }
            column(PO_No_; "PO No.") { }
            dataitem("Assembly Line"; "Assembly Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                column(Type_AssemblyLine; Type)
                {
                    IncludeCaption = true;
                }
                column(No_AssemblyLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(Description_AssemblyLine; Description)
                {
                    IncludeCaption = true;
                }
                column(VariantCode_AssemblyLine; "Variant Code")
                {
                }
                column(DueDate_AssemblyLine; Format("Due Date"))
                {
                }
                column(QuantityPer_AssemblyLine; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(Quantity_AssemblyLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(UnitOfMeasureCode_AssemblyLine; "Unit of Measure Code")
                {
                }
                column(LocationCode_AssemblyLine; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_AssemblyLine; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                {
                    IncludeCaption = true;
                }

                column(LLotNo; LLotNo)
                {
                }
                //RL    04 Jan 2021
                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    column(LineLot; "Lot No.") { }
                    column(LotQty; "Quantity (Base)") { }
                    trigger OnPreDataItem()
                    begin
                        SetRange("Source ID", "Assembly Line"."Document No.");
                        SetRange("Item Tracking", "Item Tracking"::"Lot No.");
                        SetRange("Item No.", "Assembly Line"."No.");
                        SetRange("Source Ref. No.", "Assembly Line"."Line No.");
                    end;

                    // trigger OnAfterGetRecord()
                    // var
                    //     i: Integer;
                    // begin
                    //     i := 0;
                    //     if FindSet() then begin
                    //         repeat
                    //             i += 1;
                    //             if i > 1 then
                    //                 "Assembly Line".Quantity := 0;

                    //         until Next() = 0
                    //     end;
                    // end;
                }
                //RL    04 Jan 2021
                trigger OnAfterGetRecord()
                begin
                    LLotNo := '';
                    ItemTrackingSpec.Reset();
                    ItemTrackingSpec.SetRange("Source ID", "Assembly Line"."Document No.");
                    ItemTrackingSpec.SetRange("Item Tracking", ItemTrackingSpec."Item Tracking"::"Lot No.");
                    ItemTrackingSpec.SetRange("Item No.", "Assembly Line"."No.");
                    ItemTrackingSpec.SetRange("Source Ref. No.", "Assembly Line"."Line No.");

                    if ItemTrackingSpec.findfirst then begin

                        LLotNo := ItemTrackingSpec."Lot No.";
                        // Message(LLotNo);

                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Assembly Line".SetRange(Type, "Assembly Line".Type::Item);
                end;
            }

            trigger OnAfterGetRecord()
            var
                ATOLink: Record "Assemble-to-Order Link";
            begin
                Clear(SalesDocNo);
                if ATOLink.Get("Document Type", "No.") then
                    SalesDocNo := ATOLink."Document No.";

                HLotNo := '';
                ItemTrackingSpec.Reset();
                ItemTrackingSpec.SetRange("Source ID", "Assembly Header"."No.");
                ItemTrackingSpec.SetRange("Item Tracking", ItemTrackingSpec."Item Tracking"::"Lot No.");
                ItemTrackingSpec.SetRange("Item No.", "Assembly Header"."Item No.");

                if ItemTrackingSpec.findfirst then begin

                    HLotNo := ItemTrackingSpec."Lot No.";
                    Expdate := ItemTrackingSpec."Expiration Date";

                    // Message(HLotNo);

                end;
                ItemRec.reset;
                ItemRec.SetRange("No.", "Assembly Header"."Item No.");
                if ItemRec.FindFirst() then begin
                    PackInstr := ItemRec."Packing Instructions";
                end else
                    PackInstr := '';
            end;


        }

    }


    requestpage
    {

        layout
        {
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CompanyInfo.GET;
            CompanyInfo.CalcFields(Picture);
        end;


    }



    labels
    {
        AssemblyOrderHeading = 'Assembly Order';
        AssemblyItemHeading = 'Assembly Item';
        BillOfMaterialHeading = 'Bill of Material';
        PageCaption = 'Page';
        OfCaption = 'of';
        OrderNoCaption = 'Order No.';
        QuantityAssembledCaption = 'Quantity Assembled';
        QuantityPickedCaption = 'Quantity Picked';
        QuantityConsumedCaption = 'Quantity Consumed';
        AssembleToOrderNoCaption = 'Asm. to Order No.';
        UnitOfMeasureCaption = 'Unit of Measure';
        VariantCaption = 'Variant';
        DueDateCaption = 'Due Date';
        StartingDateCaption = 'Starting Date';
        EndingDateCaption = 'Ending Date';

    }

    var
        SalesDocNo: Code[20];
        CompanyInfo: Record "Company Information";
        ItemTrackingSpec: Record "Reservation Entry";
        LLotNo: text[50];
        HLotNo: text[50];
        ItemRec: Record item;
        PackInstr: Text[500];
        Expdate: Date;
}

