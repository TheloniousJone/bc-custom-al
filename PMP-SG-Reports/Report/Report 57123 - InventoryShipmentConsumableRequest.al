report 57123 InventoryShipment
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Rpt50123-InventoryShipment.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Consumable Request Report';
    // UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;
    dataset
    {
        dataitem("InvtDocumentHeader"; "Invt. Document Header")
        {
            DataItemTableView = SORTING("Document Type") WHERE("Document Type" = CONST(SHIPMENT));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Consumable Request Report';
            column(companypicture; CompanyInfo.Picture) { }
            column(NoSeriesDesrip; NoSeriesDesrip) { }
            column(No_; "No.") { }
            column(LocationName; LocationName) { }
            column(Posting_Date; "Posting Date") { }
            column(Posting_Date2; format("Posting Date", 0, 5)) { }
            column(Document_Date; "Document Date") { }
            column(DimensionCode; DimensionCode) { }
            column(DimensionValuecode; DimensionValuecode) { }
            column(Location_Code; "Location Code") { }
            column(Posting_Description; "Posting Description") { }
            column(External_Document_No_; "External Document No.") { }
            column(Bin_Code; "Bin Code") { }
            dataitem("InvDocumentLine"; "Invt. Document Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = InvtDocumentHeader;
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                // column(Description_2; "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_No_; "Line No.") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(RowNo; RowNo) { }
                dataitem("Reservation Entry"; "Reservation Entry")
                {

                    column(Lot_No_; "Lot No.") { }
                    column(Expiration_Date; "Expiration Date") { }
                    column(Quantity__Base_; "Quantity (Base)") { }
                    column(gdt_ExpDate; gdt_ExpDate) { }

                    trigger OnPreDataItem()
                    begin

                        SetRange("Item No.", InvDocumentLine."Item No.");
                        SetRange("Location Code", InvDocumentLine."Location Code");
                        SetRange("Source Type", Database::"Invt. Document Line");
                        SetRange("Source Subtype", InvDocumentLine."Document Type");
                        SetRange("Source ID", InvDocumentLine."Document No.");
                        // SetRange("Source Batch Name", InvDocumentLine."Journal Batch Name");
                        SetRange("Source Ref. No.", InvDocumentLine."Line No.");
                    end;

                    //KM20220505 - Start
                    trigger OnAfterGetRecord()
                    var
                        lrec_ILE: Record "Item Ledger Entry";
                    begin
                        Clear(gdt_ExpDate);
                        lrec_ILE.Reset();
                        lrec_ILE.SetRange("Lot No.", "Lot No.");
                        lrec_ILE.SetRange("Item No.", "Item No.");
                        if lrec_ILE.FindFirst() then begin
                            gdt_ExpDate := lrec_ILE."Expiration Date";
                        end else begin
                            gdt_ExpDate := "Expiration Date";
                        end;
                    end;
                    //KM20220505 - End
                }
                trigger OnAfterGetRecord()
                var
                begin
                    if InvDocumentLine.Quantity > 0 then begin

                    end else begin
                        CurrReport.Skip();
                    end;

                    RowNo := RowNo + 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                LocationRec: Record Location;
                DimensionRec: Record "Dimension Set Entry";
                UserRec: Record User;
                NoSeriesRec: Record "No. Series";
            begin
                NoSeriesRec.Reset();
                Clear(NoSeriesDesrip);
                NoSeriesRec.SetRange(Code, "No. Series");
                if NoSeriesRec.FindFirst() then begin
                    NoSeriesDesrip := NoSeriesRec.Description;
                end;
                UserRec.Reset();
                Clear(CreatedBy);
                UserRec.setrange("User Security ID", SystemCreatedBy);
                if UserRec.FindFirst() then begin
                    CreatedBy := UserRec."Full Name";
                end;

                LocationRec.Reset();
                Clear(LocationName);
                LocationRec.SetRange(Code, "Location Code");
                if LocationRec.FindFirst() then begin
                    LocationName := LocationRec.Name;
                end;

                DimensionRec.Reset();
                Clear(DimensionCode);
                Clear(DimensionValuecode);
                DimensionRec.SetRange("Dimension Set ID", "Dimension Set ID");
                if DimensionRec.FindFirst() then begin
                    DimensionCode := DimensionRec."Dimension Code";
                    DimensionValuecode := DimensionRec."Dimension Value Code";
                end;

                Clear(RowNo);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    var
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        NoSeriesDesrip: Text[250];
        LocationName: Text[250];
        DimensionCode: Code[250];
        DimensionValuecode: code[250];
        CreatedBy: Text[250];
        gdt_ExpDate: Date;
        RowNo: Integer;
}