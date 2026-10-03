report 57013 "Posted Inv Waybill Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57013 - Posted Inv Waybill Label.rdl';
    ApplicationArea = All;
    Caption = 'Posted Waybill Label';
    UsageCategory = Documents;
    dataset
    {
        dataitem(SalesHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";
            RequestFilterHeadingML = ENU = 'Posted Waybill',
                                     ENA = 'Posted Waybill';
            column(Ship_to_Address; CustAddr)
            {
            }
            column(Ship_to_Name; SalesHeader."Ship-to Name")
            {
            }

            column(Delivery_Instructions; SalesHeader."Delivery Instructions")
            {

            }
            //RL    28 Feb 2022 - Change barcode from Order no. to No.
            column(No_; SalesHeader."No.")
            {

            }
            // column(No_; SalesHeader."Order No.")
            // {

            // }
            //RL    28 Feb 2022 - End
            column(BarcodeText; BarcodeText)
            {

            }
            column(compInfologo; compInfo.Picture)
            {

            }
            column(DeliveryZone; GDelZone)
            {

            }
            column(IsCD; IsCD)
            {

            }
            column(IsCold; IsCold)
            {

            }

            column(OpenHours; openHrs)
            {

            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(NoOfCopies; NoOfCopies)
                {

                }
                column(RecCount; RecCount)
                {

                }
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
                end;
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/                
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;

                //RL    28 Feb 2022 - Start - Change barcode from Order no. to No.
                barcodeString := "No.";
                // barcodeString := "Order No.";
                //RL    28 Feb 2022 - End

                BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                BarcodeText := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/

                CustRec.reset;
                CustRec.SetLoadFields("No.", "Working Hours");   //DX        16 May 2023
                CustRec.SetRange("No.", "Sell-to Customer No.");
                if CustRec.FindFirst() then begin
                    OpenHrs := CustRec."Working Hours";
                end;
                CustAddr := SalesHeader."Ship-to Address" + ' ' + SalesHeader."Ship-to Address 2";
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
        actions
        {
            area(processing)
            {
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
    //TempBlob: Record TempBlob;
}
