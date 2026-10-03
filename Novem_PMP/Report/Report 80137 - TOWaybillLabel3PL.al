report 80137 "I9G_TOWaybillLabel3PL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/Rpt80137-TOWaybillLabel3PL.rdl';
    ApplicationArea = All;
    Caption = 'Waybill Label (3PL)';
    dataset
    {
        dataitem(SalesHeader; "Transfer Header")
        {
            column(Ship_to_Address; SalesHeader."Transfer-to Address" + ' ' + SalesHeader."Transfer-to Address 2") { }
            column(Ship_to_Name; "Transfer-to Name") { }
            column(Delivery_Instructions; SalesHeader.Comment) { }
            column(No_; "No.") { }
            column(BarcodeText; BarcodeText) { }
            column(compInfologo; compInfo.Picture) { }
            column(DeliveryZone; GDelZone) { }
            column(IsCold; IsCold) { }
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
            begin
                CheckRec.reset;
                CheckRec.SetRange("No.", GPLCode);
                if CheckRec.FindFirst() then begin
                    //DX        27 Aug 2021
                    /*
                    //DX        18 July 2021
                    CheckRecLine.reset;
                    CheckRecLine.SetRange("Doc No.", CheckRec."No.");
                    if GColdRoom = true then
                        CheckRecLine.SetRange("Cold Room Item", true)
                    else
                        CheckRecLine.SetRange("Cold Room Item", false);
                    if CheckRecLine.FindSet() then
                        repeat
                            NoOfCopies += CheckRecLine."Shipping Packacges";
                        until CheckRecLine.next = 0;
                    //DX        18 July 2021                  */
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
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/                
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                barcodeString := "No.";
                BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                BarcodeText := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/
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
    //TempBlob: Record TempBlob;
}