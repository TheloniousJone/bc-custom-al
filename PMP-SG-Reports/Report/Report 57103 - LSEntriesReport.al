report 57103 "LS Entries Report"
{
    ApplicationArea = All;
    Caption = 'Report 57103 - LS Entries Report';
    RDLCLayout = './ReportLayouts/ReportLayout 57103 - LS Entries Report.rdl';
    UsageCategory = Lists;
    dataset
    {
        dataitem(LSLedgerEntry; "LS Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending);
            column(AmountInclGST; "Amount Incl GST")
            {
            }
            column(CalculationMethod; "Calculation Method")
            {
            }
            column(Closed; Closed)
            {
            }
            column(ClosedBy; "Closed By")
            {
            }
            column(CommissionAmount; "Commission Amount")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(ExtDocNo; "Ext. Doc No.")
            {
            }
            column(FOCQuantity; "FOC Quantity")
            {
            }
            column(ItemDescription; "Item Description")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(LineAmount; "Line Amount")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(UnitOfMeasureCode; "Unit Of Measure Code")
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(LS_Account; "LS Account")
            {
            }


            trigger OnPreDataItem()
            begin

                if (DateFrom <> 0D) and (DateTo <> 0D) then begin
                    if DateFrom > DateTo then
                        Error(Text50000);
                end;

                IF NOT (DateFrom = 0D) OR NOT (DateTo = 0D) then begin
                    SETFILTER(LSLedgerEntry."Posting Date", '%1..%2', DateFrom, DateTo);
                end;

                //else

                if CustomerNo <> '' then begin
                    LSLedgerEntry.SetFilter(LSLedgerEntry."Customer No.", '%1', CustomerNo);
                end;

                // ELSE
                IF ItemNo <> '' THEN BEGIN
                    LSLedgerEntry.SETFILTER(LSLedgerEntry."Item No.", '%1', ItemNo);
                end;

                IF LSaccount <> '' THEN BEGIN
                    LSLedgerEntry.SETFILTER(LSLedgerEntry."LS Account", '%1', LSaccount);
                end;

            end;


            trigger OnAfterGetRecord()
            begin
                SalesInvoiceRec.Reset();
                SalesInvoiceRec.SetRange("No.", LSLedgerEntry."Document No.");

                if SalesInvoiceRec.findfirst then begin
                    Remarks := SalesInvoiceRec."Delivery Charge";
                end;
            end;


        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filtering)
                {
                    field("Date From"; DateFrom)
                    {
                        ApplicationArea = All;

                    }

                    field("Date To"; DateTo)
                    {
                        ApplicationArea = All;
                    }

                    field("Item No"; ItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No';
                        TableRelation = Item;
                    }

                    field("Customer No"; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No';
                        TableRelation = Customer;
                    }
                    field(LSaccount; LSaccount)
                    {
                        ApplicationArea = All;
                        Caption = 'LS Account';
                        TableRelation = "LS Account";
                    }
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
        DateFrom: date;
        DateTo: date;
        CustomerNo: code[20];
        ItemNo: code[20];
        Text50000: Label 'Date From must be less than Date To';
        SalesInvoiceRec: Record "Sales Invoice Header";
        Remarks: text;
        LSaccount: Code[20];
}
