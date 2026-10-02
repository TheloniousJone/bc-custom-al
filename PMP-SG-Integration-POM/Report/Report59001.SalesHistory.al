report 59001 "Sales History"
{
    DefaultLayout = RDLC;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("Document Type" = CONST("Sales Shipment"));

            trigger OnPreDataItem()
            begin

                "Item Ledger Entry".SetFilter("Source Type", '%1', "Source Type"::Customer);

            end;

            trigger OnAfterGetRecord();
            begin

                if "Item Ledger Entry"."Source No." <> '' then begin

                    CustRec.Reset;
                    CustRec.SetRange("No.", "Item Ledger Entry"."Source No.");

                    if CustRec.FindFirst() then begin
                        CustName := CustRec.Name;
                        CustPriceGroup := CustRec."Customer Price Group";
                    end;
                end;

                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Document No." := "Item Ledger Entry"."Document No.";
                TempSHLine."Customer No." := "Item Ledger Entry"."Source No.";
                TempSHLine."Unit of Measure" := "Item Ledger Entry"."Unit of Measure Code";
                TempSHLine."Customer Name" := CustName;
                TempSHLine."Item No." := "Item Ledger Entry"."Item No.";
                TempSHLine.Description := "Item Ledger Entry".Description;
                TempSHLine."Cust Price Group" := CustPriceGroup;
                TempSHLine.Insert;

            end;



        }
        dataitem("Historical Item Sales"; "Historical Item Sales")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("Entry Type" = CONST("Sales Shipment"));


            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin

                if "Historical Item Sales"."Source No." <> '' then begin

                    CustRec.Reset;
                    CustRec.SetRange("No.", "Historical Item Sales"."Source No.");

                    if CustRec.FindFirst() then begin
                        CustName := CustRec.Name;
                        CustPriceGroup := CustRec."Customer Price Group";
                    end;

                end;

                if "Historical Item Sales"."Item No." <> '' then begin

                    ItemRec.Reset();
                    itemrec.SetRange("No.", "Historical Item Sales"."Item No.");

                    if ItemRec.FindFirst() then begin
                        ItemName := ItemRec.Description;
                    end;
                end;

                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Document No." := "Historical Item Sales"."Document No.";
                TempSHLine."Customer No." := "Historical Item Sales"."Source No.";
                TempSHLine."Unit of Measure" := "Historical Item Sales"."Unit of Measure Code";
                TempSHLine."Customer Name" := CustName;
                TempSHLine."Item No." := "Historical Item Sales"."Item No.";
                TempSHLine.Description := ItemName;
                TempSHLine."Cust Price Group" := CustPriceGroup;
                TempSHLine.Insert;
            end;

        }
        dataitem(DataItem1000000002; 2000000026)
        {
            column(DocumentNo; TempSHLine."Document No.")
            {
            }
            column(Sell_to_Customer_No_; TempSHLine."Customer No.")
            {
            }
            column(Unit_of_Measure; TempSHLine."Unit of Measure")
            {
            }
            column(CustName; TempSHLine."Customer Name")
            {
            }
            column(No_; TempSHLine."Item No.")
            {
            }
            column(Description; TempSHLine.Description)
            {
            }
            column(CustPriceGroup; TempSHLine."Cust Price Group")
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
        TempSHLine: Record "Temp Sales History";
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
}

