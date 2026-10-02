report 80135 "I9G_WaybillLabel3PL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/Rpt80135-WaybillLabel3PL.rdl';
    ApplicationArea = All;
    Caption = 'Waybill Label (3PL)';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(Ship_to_Address; CustAddr) { }
            column(Ship_to_Name; ShiptoName) { }
            column(I9G_CustVendName; I9G_CustVendName) { }
            column(Delivery_Instructions; "Delivery Instructions") { }
            column(No_; "No.") { }
            column(BarcodeText; BarcodeText) { }
            column(compInfologo; compInfo.Picture) { }
            column(DeliveryZone; GDelZone) { }
            column(IsCold; IsCold) { }
            column(IsCD; IsCD) { }
            column(OpenHours; OpenHrs) { }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(number) order(ascending);
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
                ALERec: Record "Assignment Ledger Entry";
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                barcodeString: text;
                CheckingHeaderRec: Record "Checking Header";
                NovemSIH: Record "Sales Header";
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

                    Clear(ShiptoName);
                    Clear(OpenHrs);
                    Clear(CustAddr);
                    CheckingHeaderRec.Reset();
                    CheckingHeaderRec.SetRange("No.", ALERec."Picking Doc No.");
                    if CheckingHeaderRec.FindFirst() then begin
                        ShiptoName := CheckingHeaderRec.I9G_NovemShipToCustomerName;
                        OpenHrs := CheckingHeaderRec.I9G_NovemCustomerOpsHr;
                        CustAddr := CheckingHeaderRec.I9G_NovemCustomerAddress + ' ' + CheckingHeaderRec.I9G_NovemCustomerAddress2;
                    end;
                end;

                Clear(NovemSINo);
                NovemSIH.reset;
                NovemSIH.ChangeCompany('Novem-NHC');
                NovemSIH.SetLoadFields(I9G_SONo, "No.");
                NovemSIH.SetRange(I9G_SONo, SalesHeader.I9G_SONo);
                if NovemSIH.FindFirst() then begin
                    NovemSINo := NovemSIH."No.";
                end;
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/                
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                barcodeString := "No.";
                BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                BarcodeText := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/

                //CustAddr := SalesHeader.I9G_NovemShipToAddress + ' ' + SalesHeader.I9G_NovemShipToAddress2;
                if SalesHeader."TBA Order" = true then
                    CustAddr := 'TBA Order';

            end;
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

    var
        CheckRecLine: Record "Checking Line";
        CheckRec: Record "Checking Header";
        NoOfCopies: Integer;
        compInfo: Record "Company Information";
        BarcodeText: Text;
        CustRec: Record Customer;
        RecCount: Integer;
        GColdRoom: Boolean;
        IsCold: text;
        GPLCode: Code[20];
        GDelZone: Code[100];
        OpenHrs: Text[250];
        IsCD: Text;
        CustAddr: Text[200];
        NovemInvNo: code[20];
        NovemSINo: code[20];
        ShiptoName: text[100];
    //TempBlob: Record TempBlob;
}
