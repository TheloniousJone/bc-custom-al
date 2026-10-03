tableextension 70100 TransferHeaderTableExt extends "Transfer Header"
{
    fields
    {
        field(70000; "I9G_Consignment"; Boolean)
        {
            Caption = 'Consignment';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    if I9G_Consignment = false then begin
                        Validate(I9G_CustomerNo, '');
                        Validate(I9G_ShiptoCode, '');
                    end;
                end;
            end;
        }
        field(70001; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
        }
        field(70002; "I9G_Remarks"; text[250])
        {
            Caption = 'Remarks';
        }
        field(70003; "I9G_CaseDR"; Text[100])
        {
            Caption = 'Case DR';
        }
        field(70004; "I9G_DateUsed"; Date)
        {
            Caption = 'Date Used';
        }
        field(70005; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = false;
        }
        field(70006; "I9G_CustomerNo"; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(70007; "I9G_ShiptoCode"; Code[20])
        {
            Caption = 'Ship-To Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field(I9G_CustomerNo));
            trigger OnValidate()
            var
                ShipToAddressRec: Record "Ship-to Address";
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    ShipToAddressRec.Reset();
                    ShipToAddressRec.SetRange("Customer No.", I9G_CustomerNo);
                    ShipToAddressRec.SetRange(Code, I9G_ShiptoCode);
                    if ShipToAddressRec.FindFirst() then begin
                        if ShipToAddressRec.I9G_LicenseStatus = ShipToAddressRec.I9G_LicenseStatus::Expired then begin
                            Error('The license status must not be expired.');
                        end;

                        I9G_CustomerName := ShipToAddressRec.Name;
                        I9G_CustomerName2 := ShipToAddressRec."Name 2";
                        I9G_CustomerAddress := ShipToAddressRec.Address;
                        I9G_CustomerAddress2 := ShipToAddressRec."Address 2";
                        I9G_CustomerAddress3 := ShipToAddressRec.I9G_Address3;
                        I9G_CaseDR := ShipToAddressRec.I9G_CaseDR;
                    end else begin
                        I9G_CustomerName := '';
                        I9G_CustomerName2 := '';
                        I9G_CustomerAddress := '';
                        I9G_CustomerAddress2 := '';
                        I9G_CustomerAddress3 := '';
                        I9G_CaseDR := '';
                    end;
                end;
            end;
        }
        field(70008; "I9G_CustomerName"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(70009; "I9G_CustomerName2"; Text[50])
        {
            Caption = 'Customer Name 2';
            Editable = false;
        }
        FIeld(70010; "I9G_CustomerAddress"; Text[100])
        {
            Caption = 'Customer Address';
            Editable = false;
        }
        field(70011; "I9G_CustomerAddress2"; Text[50])
        {
            Caption = 'Customer Address 2';
            Editable = false;
        }
        field(70012; "I9G_CustomerAddress3"; Text[250])
        {
            Caption = 'Customer Address 3';
            Editable = false;
        }
        field(70013; "I9G_DeliveryDate"; Date)
        {
            Caption = 'Delivery Date';
        }
        field(70014; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
        }
    }
    trigger OnInsert()
    var
        CompanyInformationRec: Record "Company Information";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            Validate(I9G_Admin, UserId);
            "Direct Transfer" := true;
        end;
    end;
}