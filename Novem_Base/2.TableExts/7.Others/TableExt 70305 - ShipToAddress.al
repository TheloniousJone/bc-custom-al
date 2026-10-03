tableextension 70305 ShipToAddressTableExt extends "Ship-to Address"
{
    fields
    {
        field(70000; "I9G_Address3"; Text[250])
        {
            Caption = 'Address 3';
        }
        field(70001; "I9G_DistrictCode"; Code[20])
        {
            Caption = 'District Code';
            TableRelation = I9G_Districts;
        }
        field(70002; "I9G_CaseDR"; Text[100])
        {
            Caption = 'Case DR';
        }
        field(70003; "I9G_LicenseStartDate"; Date)
        {
            Caption = 'License Start Date';
        }
        field(70004; "I9G_LicenseEndDate"; Date)
        {
            Caption = 'License End Date';
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    UpdateLicenseStatus();
                end;
            end;
        }
        field(70005; "I9G_LicenseStatus"; Enum I9G_LicenseStatus)
        {
            Caption = 'License Status';
            Editable = false;
        }
    }

    keys
    {

    }

    procedure UpdateLicenseStatus()
    var
        SalesReceivableSetupRec: Record "Sales & Receivables Setup";
    begin
        SalesReceivableSetupRec.Get();
        SalesReceivableSetupRec.TestField(I9G_CustomerLicenseExpiration);
        if Rec.I9G_LicenseEndDate <> 0D then begin
            if Rec.I9G_LicenseEndDate < WorkDate() then begin
                Validate(I9G_LicenseStatus, I9G_LicenseStatus::Expired);
            end else begin
                if (Rec.I9G_LicenseEndDate - WorkDate() > SalesReceivableSetupRec.I9G_CustomerLicenseExpiration) then begin
                    Validate(I9G_LicenseStatus, I9G_LicenseStatus::New);
                end else begin
                    Validate(I9G_LicenseStatus, I9G_LicenseStatus::Soon);
                end;
            end;
        end else begin
            Validate(I9G_LicenseStatus, I9G_LicenseStatus::New);
        end;
    end;
}