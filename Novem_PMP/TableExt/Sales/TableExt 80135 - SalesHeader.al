tableextension 80135 SalesHeaderTableExt3PL extends "Sales Header"
{
    fields
    {
        field(80135; "I9G_SOCreated"; Boolean)
        {
            Caption = 'Sales Order Created';
            Editable = false;
        }
        field(80136; "I9G_SONo"; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
        }
        field(80137; "I9G_SOCreatedDateTime"; DateTime)
        {
            Caption = 'Sales Order Created Date Time';
            Editable = false;
        }
        field(80138; "I9G_SOCreatedBy"; Code[50])
        {
            Caption = 'Sales Order Created By';
            Editable = false;
        }
        field(80139; "I9G_NeedToCreateSO"; Boolean)
        {
            Caption = 'Create Sales Order';
        }
        field(80140; "I9G_FromCompanyName"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            Editable = false;
        }
        field(80141; "I9G_SOLastModifiedDateTime"; DateTime)
        {
            Caption = 'Sales Order Last Modifited Date Time';
            Editable = false;
        }
        field(80142; "I9G_3PLRemarks"; Text[500])
        {
            Caption = '3PL Remarks';
        }
        field(80143; "I9G_ShipmentNo"; Code[20])
        {
            Caption = 'Shipment No';
            Editable = false;
        }
        field(80144; "I9G_InvoiceNo"; Code[20])
        {
            Caption = 'Invoice No';
            Editable = false;
        }
        field(80145; "I9G_CreditMemoNo"; Code[20])
        {
            Caption = 'Credit Memo No';
            Editable = false;
        }
        field(80146; "I9G_CustVendName"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(80147; "I9G_NovemCustNoOfCopies"; Integer)
        {
            Caption = 'Novem Cust. No. Of Copies';
        }
        field(80148; "I9G_CustVendCode"; Code[20])
        {
            Caption = 'Customer Code';
            Editable = false;
        }
        field(80149; "I9G_NovemShipToAddress"; Text[250])
        {
            Caption = 'Novem Ship-to Address';
            Editable = false;
        }
        field(80150; "I9G_NovemShipToAddress2"; Text[250])
        {
            Caption = 'Novem Ship-to Address 2';
            Editable = false;
        }
        field(80151; "I9G_NovemShipToAddress3"; Text[250])
        {
            Caption = 'Novem Ship-to Address 3';
            Editable = false;
        }
        field(80152; "I9G_NovemShipToCustomerName"; Text[250])
        {
            Caption = 'Novem Ship-to Customer Name';
            Editable = false;
        }
        field(80153; "I9G_NovemShipToCustomerName2"; Text[250])
        {
            Caption = 'Novem Ship-to Customer Name 2';
            Editable = false;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                CustomerRec: Record Customer;
                ShipToAddressRec: Record "Ship-to Address";
            begin
                CustomerRec.Reset();
                CustomerRec.SetRange("No.", "Sell-to Customer No.");
                if CustomerRec.FindFirst() then begin
                    if CheckCompanyNameIsNovem = true then begin
                        ShipToAddressRec.Reset();
                        ShipToAddressRec.SetRange("Customer No.", CustomerRec."No.");
                        ShipToAddressRec.SetRange(Code, CustomerRec."Ship-to Code");
                        if ShipToAddressRec.FindFirst() then begin
                            "Delivery Charge" := ShipToAddressRec.I9G_DeliveryCharge;
                            "Delivery Zone" := ShipToAddressRec.I9G_DeliveryZone;
                            I9G_NovemShipToCustomerName := ShipToAddressRec.Name;
                            I9G_NovemShipToCustomerName2 := ShipToAddressRec."Name 2";
                            I9G_NovemShipToAddress := ShipToAddressRec.Address;
                            I9G_NovemShipToAddress2 := ShipToAddressRec."Address 2";
                            I9G_NovemShipToAddress3 := ShipToAddressRec.I9G_Address3;
                            I9G_NovemCustNoOfCopies := ShipToAddressRec.I9G_NovemCustNoOfCopies;
                        end;
                    end;
                end;
            end;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                ShipToAddressRec: Record "Ship-to Address";
            begin
                if CheckCompanyNameIsNovem = true then begin
                    ShipToAddressRec.Reset();
                    ShipToAddressRec.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    ShipToAddressRec.SetRange(Code, Rec."Ship-to Code");
                    if ShipToAddressRec.FindFirst() then begin
                        "Delivery Charge" := ShipToAddressRec.I9G_DeliveryCharge;
                        "Delivery Zone" := ShipToAddressRec.I9G_DeliveryZone;
                        I9G_NovemShipToCustomerName := ShipToAddressRec.Name;
                        I9G_NovemShipToCustomerName2 := ShipToAddressRec."Name 2";
                        I9G_NovemShipToAddress := ShipToAddressRec.Address;
                        I9G_NovemShipToAddress2 := ShipToAddressRec."Address 2";
                        I9G_NovemShipToAddress3 := ShipToAddressRec.I9G_Address3;
                        I9G_NovemCustNoOfCopies := ShipToAddressRec.I9G_NovemCustNoOfCopies;
                    end;
                end;
            end;
        }
    }

    trigger OnAfterModify()
    var
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::"Credit Memo") or (Rec."Document Type" = Rec."Document Type"::Invoice) then begin
            if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (Rec.I9G_SOCreated = true) then begin
                    Rec.I9G_SOLastModifiedDateTime := CurrentDateTime();
                end;
            end;
        end;
    end;

    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;

    procedure CheckCompanyNameIsNovem(): Boolean
    var
        CompanyInformationRec: Record "Company Information";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.Name = 'Novem Healthcare Pte Ltd' then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;
}