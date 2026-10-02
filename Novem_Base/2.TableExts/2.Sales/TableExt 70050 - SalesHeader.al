tableextension 70050 SalesHeaderTableExt extends "Sales Header"
{
    fields
    {
        field(70000; "I9G_Purchaser"; Text[150])
        {
            Caption = 'Purchaser';
        }
        field(70001; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
        }
        field(70002; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
        }
        field(70003; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
        }
        field(70004; "I9G_SignedOrder"; Boolean)
        {
            Caption = 'Signed Order';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
                SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    I9G_DeliveryOrder := not I9G_SignedOrder;
                    "Shipping No." := '';
                    SalesReceivablesSetupRec.Get();

                    if I9G_SignedOrder = true then
                        Validate("Shipping No. Series", SalesReceivablesSetupRec."Posted Shipment Nos.")
                    else
                        Validate("Shipping No. Series", SalesReceivablesSetupRec.I9G_PostedSalesShipmentNo2);
                end;
            end;
        }
        field(70005; "I9G_DeliveryOrder"; Boolean)
        {
            Caption = 'Delivery Order';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
                SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    I9G_SignedOrder := not I9G_DeliveryOrder;
                    "Shipping No." := '';
                    SalesReceivablesSetupRec.Get();

                    if I9G_DeliveryOrder = true then
                        Validate("Shipping No. Series", SalesReceivablesSetupRec.I9G_PostedSalesShipmentNo2)
                    else
                        Validate("Shipping No. Series", SalesReceivablesSetupRec."Posted Shipment Nos.");
                end;
            end;
        }
        field(70006; "I9G_SellToAddress3"; Text[250])
        {
            Caption = 'Address 3';
        }
        field(70007; "I9G_StartDate"; Date)
        {
            Caption = 'Start Date';
        }
        field(70008; "I9G_EndDate"; Date)
        {
            Caption = 'End Date';
        }
        field(70009; "I9G_FulfilledStatus"; Enum I9G_SalesStatus)
        {
            Caption = 'Fullfilled Status';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    if I9G_FulfilledStatus = I9G_FulfilledStatus::Fulfilled then begin
                        Validate(I9G_TerminationDate, I9G_TerminationDate::Closed);
                    end else begin
                        Validate(I9G_TerminationDate, I9G_TerminationDate::Open);
                    end;
                end;
            end;
        }
        field(70010; "I9G_RowStatus"; enum I9G_SalesStatus)
        {
            Caption = 'Row Status';
            Editable = false;
        }
        field(70011; "I9G_TerminationDate"; Enum I9G_SalesStatus)
        {
            Caption = 'Termination Date';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    I9G_RowStatus := I9G_TerminationDate;
                end;
            end;
        }
        field(70012; "I9G_ShipToAddress3"; Text[250])
        {
            Caption = 'Address 3';
            Editable = False;
        }
        field(70013; "I9G_ShipToDistrictCode"; Code[20])
        {
            Caption = 'District Code';
            Editable = false;
        }
        field(70014; "I9G_DRIC"; Text[100])
        {
            Caption = 'DR / IC';
        }
        field(70015; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = False;
        }
        field(70016; "I9G_BlanketSalesOrder"; Boolean)
        {
            Caption = 'Blanket Sales Order';
            Editable = false;
        }
        field(70017; "I9G_BlanketSalesOrderNo"; code[20])
        {
            Caption = 'Blanket Sales Order No.';
            Editable = false;
        }
        field(70018; "I9G_ReferenceInvoiceNo"; Code[50])
        {
            Caption = 'Ref. Invoice No.';
        }
        field(70019; "I9G_ProductCode"; Code[50])
        {
            Caption = 'Product Code';
            Editable = false;
        }
        field(70020; "I9G_ProductDescription"; Text[250])
        {
            Caption = 'Product Description';
            Editable = false;
        }
        field(70021; "I9G_ProductDescription2"; Text[250])
        {
            Caption = 'Product Description 2';
            Editable = false;
        }
        field(70022; "I9G_BillToAddress3"; Text[250])
        {
            Caption = 'Address 3';
        }
        field(70023; "I9G_CaseDoctor"; Text[100])
        {
            Caption = 'Case Doctor';
        }
        field(70024; "I9G_DateUsed"; Date)
        {
            Caption = 'Date Used';
        }
        field(70025; "I9G_Name (CN)"; Text[100])
        {
            Caption = 'Name (CN)';
        }
        field(70026; "I9G_Ship-to Name 2 (CN)"; Text[50])
        {
            Caption = 'Ship-to Name 2 (CN)';
        }
        field(70027; "I9G_Address (CN)"; Text[100])
        {
            Caption = 'Address (CN)';
        }
        field(70028; "I9G_Address 2 (CN)"; Text[50])
        {
            Caption = 'Address 2 (CN)';
        }
        field(70029; "I9G_Address 3 (CN)"; Text[250])
        {
            Caption = 'Address 3 (CN)';
        }
        field(70030; "I9G_District Code (CN)"; Code[20])
        {
            Caption = 'District Code (CN)';
        }
        field(70031; "I9G_City (CN)"; Text[30])
        {
            Caption = 'City (CN)';
        }
        field(70032; "I9G_Postcode (CN)"; Code[20])
        {
            Caption = 'Postcode (CN)';
        }
        field(70033; "I9G_GPOR/ContactNo"; Text[100])
        {
            Caption = 'GPOR/Contact No';
        }
        field(70034; "I9G_Notes"; Blob)
        {
            Caption = 'Notes';
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                CustomerRecord: Record Customer;
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    CustomerRecord.Reset();
                    CustomerRecord.SetRange("No.", "Sell-to Customer No.");
                    if CustomerRecord.FindFirst() then begin
                        I9G_SellToAddress3 := CustomerRecord.I9G_Adddress3;
                    end else begin
                        I9G_SellToAddress3 := '';
                    end;
                end;
            end;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                ShiptoAddressRec: Record "Ship-to Address";
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                        I9G_ShipToAddress3 := '';
                        I9G_ShipToDistrictCode := '';
                        I9G_DRIC := '';
                    end
                    else begin
                        ShiptoAddressRec.Reset();
                        ShiptoAddressRec.SetRange("Customer No.", "Sell-to Customer No.");
                        ShiptoAddressRec.SetRange(Code, "Ship-to Code");
                        if ShiptoAddressRec.FindFirst() then begin
                            I9G_ShipToAddress3 := ShiptoAddressRec.I9G_Address3;
                            I9G_ShipToDistrictCode := ShiptoAddressRec.I9G_DistrictCode;
                            I9G_DRIC := ShiptoAddressRec.I9G_CaseDR;
                        end
                        else begin
                            I9G_ShipToAddress3 := '';
                            I9G_ShipToDistrictCode := '';
                            I9G_DRIC := '';
                        end;
                    end;
                end;
            end;
        }
    }

    trigger OnInsert()
    var
        CompanyInformationRec: Record "Company Information";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            I9G_Admin := UserId;
            Validate(I9G_FulfilledStatus, I9G_FulfilledStatus::NonFullfiled);
            Validate(I9G_TerminationDate, I9G_TerminationDate::Open);
            SalesReceivablesSetupRec.Get();
            if SalesReceivablesSetupRec.I9G_DefaultOrder = SalesReceivablesSetupRec.I9G_DefaultOrder::"Signed Order" then begin
                Validate(I9G_SignedOrder, true);
            end else if SalesReceivablesSetupRec.I9G_DefaultOrder = SalesReceivablesSetupRec.I9G_DefaultOrder::"Delivery Order" then begin
                Validate(I9G_DeliveryOrder, true);
            end;
        end;
    end;

    procedure SetNotes(NewNotes: Text)
    var
        OutStream: OutStream;
    begin
        Clear(I9G_Notes);
        I9G_Notes.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewNotes);
        Modify();
    end;

    procedure GetNotes() Notes: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(I9G_Notes);
        I9G_Notes.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(I9G_Notes)));
    end;
}