report 80136 "I9G_PostedInvWaybillLabel3PL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/Rpt80136-PostedInvWaybillLabel3PL.rdl';
    ApplicationArea = All;
    Caption = 'Posted Waybill Label (3PL)';

    dataset
    {
        dataitem(SalesHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";
            RequestFilterHeadingML = ENU = 'Posted Waybill',
                                     ENA = 'Posted Waybill';
            column(Ship_to_Address; CustAddr) { }
            column(Ship_to_Name; ShiptoName) { }
            column(I9G_CustVendName; I9G_CustVendName) { }
            column(Delivery_Instructions; SalesHeader."Delivery Instructions") { }
            column(No_; NovemSINo) { }
            column(BarcodeText; BarcodeText) { }
            column(compInfologo; compInfo.Picture) { }
            column(DeliveryZone; GDelZone) { }
            column(IsCD; IsCD) { }
            column(IsCold; IsCold) { }
            column(OpenHours; OpenHrs) { }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(NoOfCopies; NoOfCopies) { }
                column(RecCount; RecCount) { }
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    SetRange(Number, 1, NoOfCopies);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    IF Number > NoOfCopies THEN
                        CurrReport.QUIT;
                    RecCount := Number;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                CheckRecLine: Record "Checking Line";
                ALERec: Record "Assignment Ledger Entry";
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                barcodeString: text;
                CheckingHeaderRec: Record "Checking Header";
                NovemSIH: Record "Sales Invoice Header";
            begin
                CheckRec.reset;
                CheckRec.SetRange("No.", GPLCode);
                if CheckRec.FindFirst() then begin
                    if GColdRoom = true then begin
                        NoOfCopies := CheckRec."Cold Shipping Packages";
                        IsCold := 'YES';
                    end else
                        if GColdRoom = false then begin
                            NoOfCopies := CheckRec."Non-Cold Shipping Packages";
                            IsCold := 'NO';
                        end;
                    //DX        27 Aug 2021                              
                end;
                ALERec.reset;
                ALERec.setrange("Picking Doc No.", GPLCode);
                if ALERec.FindFirst() then begin
                    if ALERec."Controlled Drug" = true then
                        IsCD := 'YES'
                    else
                        IsCD := 'NO';
                    Clear(OpenHrs);
                    Clear(CustAddr);
                    Clear(ShiptoName);
                    CheckingHeaderRec.Reset();
                    CheckingHeaderRec.SetRange("No.", ALERec."Picking Doc No.");
                    if CheckingHeaderRec.FindFirst() then begin
                        ShiptoName := CheckingHeaderRec.I9G_NovemShipToCustomerName;
                        OpenHrs := CheckingHeaderRec.I9G_NovemCustomerOpsHr;
                        CustAddr := CheckingHeaderRec.I9G_NovemCustomerAddress + ' ' + CheckingHeaderRec.I9G_NovemCustomerAddress2;
                    end;
                end;
                clear(NovemSINo);
                NovemSIH.reset;
                NovemSIH.ChangeCompany('Novem-NHC');
                NovemSIH.SetLoadFields(I9G_InvoiceNo, "No.");
                NovemSIH.SetRange(I9G_InvoiceNo, SalesHeader."No.");
                if NovemSIH.FindFirst() then begin
                    NovemSINo := NovemSIH."No.";
                end;
                if NovemSINo = '' then
                    NovemSINo := SalesHeader."No.";
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/                
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;

                //RL    28 Feb 2022 - Start - Change barcode from Order no. to No.
                //barcodeString := "No.";
                barcodeString := NovemSINo;
                // barcodeString := "Order No.";
                //RL    28 Feb 2022 - End

                BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                BarcodeText := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/


                // CustAddr := SalesHeader.I9G_NovemShipToAddress + ' ' + SalesHeader.I9G_NovemShipToAddress2;

                if SalesHeader."TBA Order" = true then
                    CustAddr := 'TBA Order';

                // YF 21 Mar 2025 // Task 1471
                if GDelZone = '' then
                    GdelZone := SalesHeader."Delivery Zone";
                // YF 21 Mar 2025 // Task 1471


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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        compInfo.reset;
        compInfo.get;
        compInfo.CalcFields(Picture);
    end;

    procedure SetColdStatus(IsCOld: Boolean)
    var
        myInt: Integer;
    begin
        GColdRoom := IsCOld;
    end;

    procedure SetPLNo(PLCode: Code[20])
    begin
        GPLCode := PLCode
    end;

    procedure setDelZone(lDelCode: Code[100])
    begin

        GDelZone := lDelCode;
    end;

    // local procedure GetNovemShiptoName(SIHRec: Record "Sales Invoice Header"): text[100]
    // var
    //     myInt: Integer;
    //     NovemSIH: Record "Sales Invoice Header";
    // begin
    //     NovemSIH.reset;
    //     NovemSIH.ChangeCompany(SIHRec.I9G_FromCompanyName);
    //     NovemSIH.SetCurrentKey("Order No.", I9G_InvoiceNo);
    //     NovemSIH.SetLoadFields("Order No.", I9G_InvoiceNo);
    //     NovemSIH.SetRange("Order No.", SIHRec."Order No.");
    //     NovemSIH.SetRange(I9G_InvoiceNo, SIHRec."No.");
    //     if NovemSIH.FindFirst() then begin
    //         if NovemSIH."Ship-to Name" <> '' then
    //             exit(NovemSIH."Ship-to Name")
    //         else
    //             exit(SIHRec.I9G_CustVendName);
    //     end;
    // end;

    var
        CustAddr: Text[200];
        GcoldRoom: Boolean;
        CheckRec: Record "Checking Header";
        NoOfCopies: Integer;
        compInfo: Record "Company Information";
        BarcodeText: Text;
        CustRec: Record Customer;
        RecCount: Integer;
        IsCold: text;
        GPLCode: Code[20];
        GdelZone: Code[100];
        OpenHrs: Text[250];
        IsCD: Text;
        NovemSINo: code[20];
        ShiptoName: text[100];
    //TempBlob: Record TempBlob;
}