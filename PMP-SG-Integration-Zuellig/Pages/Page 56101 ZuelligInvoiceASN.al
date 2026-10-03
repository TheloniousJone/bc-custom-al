page 56101 "Zuellig Invoice ASN Entries"
{

    SourceTable = "Zuellig Invoice ASN Import Log";
    Caption = 'Zuellig Invoice ASN Entries';
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;
    PageType = Worksheet;
    // AutoSplitKey = true;
    SaveValues = true;
    InsertAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }

                /*
                field("Is Simulation"; Rec."Is Simulation")
                {
                    ApplicationArea = All;
                }
                */

                field("PO Number"; Rec."PO Number")
                {
                    ApplicationArea = All;
                }

                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                }

                field("Invoice Number"; Rec."Invoice Number")
                {
                    ApplicationArea = All;
                }

                field("Customer Item Code"; Rec."Customer Item Code")
                {
                    ApplicationArea = All;
                }

                field("Bill Qty"; Rec."Bill Qty")
                {
                    ApplicationArea = All;
                }

                field("Selling Price"; Rec."Selling Price")
                {
                    ApplicationArea = All;
                }

                field("Batch Expiry Date"; Rec."Batch Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Batch Number"; Rec."Batch Number")
                {
                    ApplicationArea = All;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }

                field("Conversion Factor Decimal"; Rec."Conversion Factor Decimal")
                {
                    ApplicationArea = All;
                    Caption = 'Conversion Factor';
                }

                /*
                field(UserId; Rec.UserId)
                {
                    ApplicationArea = All;
                }
                */

                field("Entry Date Time"; Rec."Entry Date Time")
                {
                    ApplicationArea = All;
                }

                field("PO Updated"; Rec."PO Updated")
                {
                    ApplicationArea = All;
                }

                field("Purchase Order No. Updated"; Rec."Purchase Order No. Updated")
                {
                    ApplicationArea = All;
                }

                field("Purchase Line No. Updated"; Rec."Purchase Line No. Updated")
                {
                    ApplicationArea = All;
                }

                field("PO Error"; Rec."PO Error")
                {
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("QR Code Scanning for GRN")
                {
                    ApplicationArea = all;
                    Caption = 'QR Code Scanning for GRN';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Simulate;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ScannedQRCode: Text[1000];
                        IntegrationCU: Codeunit "Zuellig Integrations";
                        GetQRCodePage: Page "Get ZP Invoice QR Dialog";
                    begin
                        // ScannedQRCode := 'P113920-1|1084358091|20210616|23214560|1|1|248.15|V49J|20220430|BDS28Z|2|1|5.90|0097286|20250331|CAR27T|10|1|15.50|JY5391|20220630|CYK02I|2|1|71.20|DP6687|20230228|23216148|3|1|36.00|LW61014|20230531|INV02I|30|1|75.00|U011560|20221111|23061757|40|1|5.60|KRU9277|20231031';
                        ScannedQRCode := '';
                        if GetQRCodePage.RunModal() = Action::OK then begin
                            ScannedQRCode := GetQRCodePage.GetQRCode();
                            if IntegrationCU.ValidateInvoiceBarcode(ScannedQRCode, false) then
                                Message('QR Code scanned and entry inserted');
                        end;
                    end;
                }

                action("ZP Invoice ASN Import")
                {
                    ApplicationArea = all;
                    Caption = 'ZP Invoice ASN Import';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Import;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                    begin
                        IntegrationCU.ProcessInvoiceASN(false);
                    end;
                }

                action("Create PO Batch No.")
                {
                    ApplicationArea = all;
                    Caption = 'Create PO Batch No.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = CreateSKU;
                    InFooterBar = true;

                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                        ZPInvoiceASNRec: Record "Zuellig Invoice ASN Import Log";
                        RecordCounter: Integer;
                    begin
                        CurrPage.SetSelectionFilter(ZPInvoiceASNRec);

                        if ZPInvoiceASNRec.Count <> 0 then begin
                            if Confirm('Are you sure you wish to create PO batch nos. ?') then begin
                                if ZPInvoiceASNRec.FindSet() then
                                    repeat

                                        ClearLastError();

                                        if IntegrationCU.CheckPOLineInfo(ZPInvoiceASNRec."Entry No", ZPInvoiceASNRec."PO Number", ZPInvoiceASNRec."Customer Item Code") then begin
                                            IntegrationCU.CreatePOBatch(ZPInvoiceASNRec."Entry No"); // process PO Batch Nos.
                                            RecordCounter += 1;
                                        end
                                        else begin
                                            if (ZPInvoiceASNRec."PO Updated" = false) And (ZPInvoiceASNRec."Purchase Order No. Updated" = '') then begin
                                                ZPInvoiceASNRec."PO Error" := true;
                                                ZPInvoiceASNRec."Process Remarks" := GetLastErrorText();
                                                ZPInvoiceASNRec.Modify();
                                            end;

                                            Message(Format(GetLastErrorText()));
                                        end;

                                    until ZPInvoiceASNRec.Next = 0;

                                if RecordCounter <> 0 then
                                    Message('%1 Transactions processed', RecordCounter);
                            end;
                        end
                        else begin
                            Message('Please select the records that you will like to create.');
                        end;

                    end;
                }

                action("Development Cleanup")
                {
                    ApplicationArea = all;
                    Caption = 'Development Cleanup';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = ClearLog;
                    InFooterBar = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                    begin
                        // IntegrationCU.Cleanup();
                    end;
                }

            }

        }

        area(navigation)
        {
            group(Reports)
            {
                Caption = 'Report';
                Image = Report;
                action("Run Create PO Batch No. Jobqueue")
                {
                    ApplicationArea = all;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    Visible = false;

                    trigger OnAction()
                    var
                        ZPInvoiceASNRec: Record "Zuellig Invoice ASN Import Log";
                    begin
                        CurrPage.SetSelectionFilter(ZPInvoiceASNRec);
                        Report.RunModal(56100, true, false, ZPInvoiceASNRec);
                    end;
                }
            }

        }
    }

}
