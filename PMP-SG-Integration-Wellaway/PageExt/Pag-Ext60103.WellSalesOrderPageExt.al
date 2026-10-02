pageextension 60103 WellSalesOrderPageExt extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            group("Wellaway Info.")
            {
                Visible = VisibleBool;
                group("Patient Info")
                {
                    field("Patient No."; Rec."Patient No.")
                    {
                        ApplicationArea = all;
                        TableRelation = Patient."No.";
                        Visible = VisibleBool;
                    }
                    field("Patient Name"; Rec."Patient Name")
                    {
                        ApplicationArea = all;
                        Visible = VisibleBool;
                    }
                    field(NRIC; Rec.NRIC)
                    {
                        ApplicationArea = all;
                        Visible = VisibleBool;
                    }
                    field(DOB; Rec.DOB)
                    {
                        ApplicationArea = all;
                        Visible = VisibleBool;
                    }
                    field("Drug Allergy"; Rec."Drug Allergy")
                    {
                        ApplicationArea = all;
                        Visible = VisibleBool;
                        Style = Strong;
                        StyleExpr = true;
                        Editable = false;
                    }
                    field("Well. Basket No."; Rec."Well. Basket No.")
                    {
                        ApplicationArea = all;
                        Caption = 'Wellaway Basket No.';
                        Visible = VisibleBool;
                    }

                }

                field("Order Sent to PMP"; Rec."Order Sent to PMP")
                {
                    ApplicationArea = all;
                    Caption = 'Transfer Order sent to PMP';
                    Editable = true;
                    Visible = VisibleBool;
                }
                field("Order Invoiced in PMP"; Rec."Order Invoiced in PMP")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Visible = VisibleBool;
                }
                field("Wellaway Picker"; Rec."Wellaway Picker")
                {
                    ApplicationArea = all;
                }
                field("Wellaway Checker"; Rec."Wellaway Checker")
                {
                    ApplicationArea = all;
                }
                field("Shipping No."; Rec."Shipping No.")
                {
                    ApplicationArea = all;
                }
                field("Shipping No. Series"; Rec."Shipping No. Series")
                {
                    ApplicationArea = all;
                }
            }

        }
    }
    actions
    {
        addafter("Actions")
        {
            group(Wellaway)
            {
                /*          //DX        25 July 2021
                Visible = VisibleBool;
                action("Create Stock Transfer in PMP")
                {
                    ApplicationArea = All;
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                    begin
                        if WellCU.IsWellawayCompany() then begin
                            if confirm('Are you sure you wish to send this order to PMP?') then
                                if NOT (WellCU.AllStockisSufficient(Rec)) then      //Check if whole sales order has enough stock
                                    WellCU.CreateOrder(Rec)
                                else begin
                                    Rec.Validate("Order Sent to PMP", true);
                                    rec.Modify(true);
                                end;

                        end else begin
                            Message('Please only execute this function in the Wellaway Company.');
                        end;
                    end;
                }
                */
                action("Print Wellaway Labels")
                {
                    ApplicationArea = All;
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                        SHRec: Record "Sales Header";

                    begin
                        if WellCU.IsWellawayCompany() then begin
                            CurrPage.SetSelectionFilter(SHRec);
                            Report.Run(60108, true, false, SHRec);
                            //Report.Run();
                            //Rec."Wellaway Checker" := UserId;
                            //Rec."Wellaway Picker" := UserId;
                            //rec.Modify(true);

                        end else begin
                            Message('Please only execute this function in the Wellaway Company.');
                        end;
                    end;
                }
                // action("Print All Labels")
                // {
                //     ApplicationArea = All;
                //     Image = Process;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     trigger OnAction()
                //     var
                //         myInt: Integer;
                //         WellCU: Codeunit "Wellaway CU";
                //         SHRec: Record "Sales Header";
                //         RR: RecordRef;
                //         TempBlob: Codeunit "Temp Blob";
                //         OutS: OutStream;
                //         InS: InStream;
                //         FileName, ZipFileName : Text;
                //         DataCompression: Codeunit "Data Compression";
                //         ReportIds: array[3] of Integer;
                //         ReportNames: array[3] of Text[50];
                //         i: Integer;
                //         Report1: Report 60108;
                //         report2: report 60112;
                //         report3: report 60113;

                //     begin
                //         if WellCU.IsWellawayCompany() then begin
                //             CurrPage.SetSelectionFilter(SHRec);
                //             // report.Run(60108, false, false, SHRec);
                //             // report.Run(60112, false, false, SHRec);
                //             // report.SaveAs()
                //             // ReportIds[1] := 60108;
                //             // ReportIds[2] := 60112;
                //             // ReportIds[3] := 60113;

                //             // ReportNames[1] := 'Report1.pdf';
                //             // ReportNames[2] := 'Report2.pdf';
                //             // ReportNames[3] := 'Report3.pdf';

                //             // RR.GetTable(SHRec);
                //             // DataCompression.CreateZipArchive();

                //             // for i := 1 to ArrayLen(ReportIds) do begin
                //             //     TempBlob.CreateOutStream(OutS);
                //             //     Report.SaveAs(ReportIds[i], '', ReportFormat::Pdf, OutS, RR);
                //             //     TempBlob.CreateInStream(InS);
                //             //     DataCompression.AddEntry(InS, ReportNames[i]);
                //             // end;

                //             // TempBlob.CreateOutStream(OutS);
                //             // DataCompression.SaveZipArchive(OutS);
                //             // TempBlob.CreateInStream(InS);
                //             // ZipFileName := 'Report.zip';
                //             // DownloadFromStream(InS, '', '', '', ZipFileName);
                //         end else begin
                //             Message('Please only execute this function in the Wellaway Company.');
                //         end;
                //     end;
                // }

                action("Print Order Display Balance.")
                {
                    ApplicationArea = All;
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                        SHRec: Record "Sales Header";

                    begin
                        if WellCU.IsWellawayCompany() then begin
                            CurrPage.SetSelectionFilter(SHRec);
                            Report.Run(60107, true, false, SHRec);
                            //Report.Run();
                            //Rec."Wellaway Checker" := UserId;
                            //Rec."Wellaway Picker" := UserId;
                            //rec.Modify(true);

                        end else begin
                            Message('Please only execute this function in the Wellaway Company.');
                        end;
                    end;
                }
                action("Print Order Display Balance. with QR")
                {
                    ApplicationArea = All;
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                        SHRec: Record "Sales Header";

                    begin
                        if WellCU.IsWellawayCompany() then begin
                            CurrPage.SetSelectionFilter(SHRec);
                            Report.Run(60112, true, false, SHRec);
                            //Report.Run();
                            //Rec."Wellaway Checker" := UserId;
                            //Rec."Wellaway Picker" := UserId;
                            //rec.Modify(true);

                        end else begin
                            Message('Please only execute this function in the Wellaway Company.');
                        end;
                    end;
                }
                action("Print Courier QR")
                {
                    ApplicationArea = All;
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        WellCU: Codeunit "Wellaway CU";
                        SHRec: Record "Sales Header";

                    begin
                        if WellCU.IsWellawayCompany() then begin
                            CurrPage.SetSelectionFilter(SHRec);
                            Report.Run(60113, true, false, SHRec);
                            //Report.Run();
                            //Rec."Wellaway Checker" := UserId;
                            //Rec."Wellaway Picker" := UserId;
                            //rec.Modify(true);

                        end else begin
                            Message('Please only execute this function in the Wellaway Company.');
                        end;
                    end;
                }
            }

        }

    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if WellCU.IsWellawayCompany() then
            VisibleBool := true else
            VisibleBool := false;
    end;

    var
        VisibleBool: Boolean;
        WellCU: Codeunit "Wellaway CU";
        StockBal: Decimal;

}
