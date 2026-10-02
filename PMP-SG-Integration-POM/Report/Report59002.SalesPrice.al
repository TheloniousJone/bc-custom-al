report 59002 "Sales Price"
{
    DefaultLayout = RDLC;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Pharma Sales Price"; "Pharma Sales Price")
        {
            DataItemTableView = SORTING("Item No.");

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord();
            begin

                ItemRec.reset;
                ItemRec.SetRange("No.", "Pharma Sales Price"."Item No.");
                if ItemRec.FindFirst() then begin
                    Desc := ItemRec.Description;
                end;

                if "Pharma Sales Price"."FOC Qty" > 0 then begin
                    HaveBonus := 'Y';
                end else begin
                    HaveBonus := 'N';
                end;

                //store temp
                UOMRec.Reset();
                UOMRec.SetRange("Item No.", "Pharma Sales Price"."Item No.");
                UOMRec.SetRange(Code, "Pharma Sales Price"."Unit Of Measure Code");
                if uomrec.findfirst then begin
                    QtyUOM := UOMRec."Qty. per Unit of Measure";
                end;
                //store temp

                if "Pharma Sales Price"."Currency Code" = '' then
                    CurrCode := 'SGD'
                else
                    CurrCode := "Pharma Sales Price"."Currency Code";

                if "Pharma Sales Price"."Ending Date" >= 21001231D then begin
                    StartDate := 0D;
                    EndDate := 0D;
                end else begin
                    StartDate := "Pharma Sales Price"."Starting Date";
                    EndDate := "Pharma Sales Price"."Ending Date";
                end;

                if ("Pharma Sales Price"."Starting Date" <= 20201231D) and ("Pharma Sales Price"."Ending Date" >= 21001231D) then begin
                    StartDate := "Pharma Sales Price"."Starting Date";
                    EndDate := "Pharma Sales Price"."Ending Date";
                end;

                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Item No." := "Pharma Sales Price"."Item No.";
                TempSHLine.Description := Desc;
                TempSHLine."Sales Code" := "Pharma Sales Price"."Sales Code";
                TempSHLine."Currency Code" := CurrCode;
                TempSHLine."Start Date" := StartDate;
                TempSHLine."Unit Price" := "Pharma Sales Price"."Unit Price";
                TempSHLine."Price Includes VAT" := "Pharma Sales Price"."Price Includes VAT";
                TempSHLine."Allow Invoice Disc." := "Pharma Sales Price"."Allow Invoice Disc.";
                TempSHLine."Line Discount %" := "Pharma Sales Price"."Line Discount %";
                TempSHLine."Sales Type" := "Pharma Sales Price"."Sales Type";
                TempSHLine."Minimum Quantity" := "Pharma Sales Price"."Minimum Quantity";
                TempSHLine."End Date" := EndDate;
                TempSHLine."Unit Of Measure Code" := "Pharma Sales Price"."Unit Of Measure Code";
                TempSHLine."VAT Bus. Posting Gr. (Price)" := "Pharma Sales Price"."VAT Bus. Posting Gr. (Price)";
                TempSHLine."Allow Line Disc." := "Pharma Sales Price"."Allow Line Disc.";
                TempSHLine."Variant Code" := "Pharma Sales Price"."Variant Code";
                TempSHLine."FOC Qty" := "Pharma Sales Price"."FOC Qty";
                TempSHLine.Status := "Pharma Sales Price".Status;
                TempSHLine.RecRefID := "Pharma Sales Price".RecRefID;
                TempSHLine.Remarks := "Pharma Sales Price".Remarks;
                TempSHLine."Qty Per Measure" := QtyUOM;
                TempSHLine."Have Bonus" := HaveBonus;
                TempSHLine.Insert;

            end;

        }

        dataitem(DataItem1000000002; 2000000026)
        {
            column(ItemNo; TempSHLine."Item No.")
            {
            }
            column(Desc_; TempSHLine.Description)
            {
            }
            column(SalesCode; TempSHLine."Sales Code")
            {
            }
            column(CurrencyCode; TempSHLine."Currency Code")
            {
            }
            column(StartDate; TempSHLine."Start Date")
            {
            }
            column(UnitPrice; TempSHLine."Unit Price")
            {
            }
            column(PriceVAT; TempSHLine."Price Includes VAT")
            {
            }
            column(AllowInvoiceDisc; TempSHLine."Allow Invoice Disc.")
            {
            }
            column(LineDisc; TempSHLine."Line Discount %")
            {
            }
            column(SalesType; TempSHLine."Sales Type")
            {
            }
            column(MinQty; TempSHLine."Minimum Quantity")
            {
            }
            column(EndDate; TempSHLine."End Date")
            {
            }
            column(UOM; TempSHLine."Unit Of Measure Code")
            {
            }
            column(VATBiz; TempSHLine."VAT Bus. Posting Gr. (Price)")
            {
            }
            column(AllowLineDisc; TempSHLine."Allow Line Disc.")
            {
            }
            column(VariantCode; TempSHLine."Variant Code")
            {
            }
            column(FocQty; TempSHLine."FOC Qty")
            {
            }
            column(Status; TempSHLine.Status)
            {
            }
            column(RecRefID; TempSHLine.RecRefID)
            {
            }
            column(Remarks; TempSHLine.Remarks)
            {
            }
            column(QtyPerMeasure; TempSHLine."Qty Per Measure")
            {
            }
            column(HaveBonus; TempSHLine."Have Bonus")
            {
            }


            trigger OnAfterGetRecord();
            begin

                IF Number = 1 THEN
                    TempSHLine.FIND('-') // find first record
                ELSE
                    TempSHLine.NEXT;

            end;

            trigger OnPreDataItem();
            begin

                TempSHLine.RESET;
                SETRANGE(Number, 1, TempSHLine.COUNT);//tempsh.count is count no of record, e.g. 10 records, so if use setrange, it will loop from number 1 record to the tempsh.COUNT record which is 10
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        // layout
        // {
        //     area(content)
        //     {
        //         group("Filtering")
        //         {
        //             field("Date"; SDate)
        //             {

        //             }

        //             field("Item to Observe"; ItemFilter)
        //             {

        //             }
        //             field("No"; "No")
        //             {
        //                 Caption = 'Item No';
        //                 TableRelation = Item;
        //             }
        //         }
        //     }
        // }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        SDate := Today;
        TempSHLine.DeleteAll();
        Commit();
    end;

    var
        TempSHLine: Record "Temp Sales Price";
        CustRec: Record Customer;
        CompanyInfo: record "Company Information";
        SalesHeaderRec: Record "Sales Invoice Header";
        SalesLineRec: Record "Sales Invoice Line";
        ItemRec: Record Item;
        SDate: date;
        EDate: date;
        ItemFilter: boolean;
        ShipToRec: record "Ship-to Address";
        AddressCode: Text[50];
        IDCounter: Integer;
        No: code[20];
        PostingDate: date;
        CustName: Text[100];
        ItemName: Text[100];
        CustPriceGroup: text[20];
        Desc: text[100];
        HaveBonus: code[10];
        UOMRec: Record "Item Unit of Measure";
        QtyUOM: Decimal;
        CurrCode: Code[20];
        StartDate: Date;
        EndDate: Date;
}

