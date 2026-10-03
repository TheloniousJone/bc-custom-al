xmlport 60100 "Import Wellaway PO Header"
{
    Caption = 'Import Wellaway PO Header';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    RecordSeparator = '<LF>';
    // RecordSeparator = '<NewLine>';
    // TextEncoding = UTF8;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(IncomingPOHeader; "Incoming Wellaway PO Header")
            {
                // AutoSave = false;
                // AutoReplace = false;
                // AutoUpdate = false;

                fieldelement(PurchaseOrderID; IncomingPOHeader."Purchase Order ID") { }
                textelement(TransactionDate)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader."Transaction Date" := GetDateValue(TransactionDate, WorkDate());
                    end;
                }
                fieldelement(PhysicalPOID; IncomingPOHeader."Physical PO ID") { }
                fieldelement(CustomerCode; IncomingPOHeader."Customer Code") { }
                fieldelement(CustomerName; IncomingPOHeader."Customer Name") { }
                fieldelement(LoginID; IncomingPOHeader."Login ID") { }
                fieldelement(OrderBy; IncomingPOHeader."Order by") { }
                fieldelement(Currency; IncomingPOHeader."Currency") { }
                fieldelement(TermsOfPayment; IncomingPOHeader."Terms of Payment") { }
                fieldelement(ContactPerson; IncomingPOHeader."Contact Person") { }
                fieldelement(StreetName; IncomingPOHeader."Street Name") { }
                fieldelement(CountryRegion; IncomingPOHeader."Country/Region") { }
                fieldelement(ZipCode; IncomingPOHeader."Zip Code") { }
                fieldelement(Email; IncomingPOHeader.Email) { }
                fieldelement(Telephone; IncomingPOHeader.Telephone) { }
                fieldelement(Fax; IncomingPOHeader.Fax) { }
                textelement(OnlineDiscountAmount)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader."Online Discount Amount" := GetDecimalValue(OnlineDiscountAmount, 0);
                    end;
                }
                textelement(OnlineDiscountPercent)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader."Online Discount Percent" := GetDecimalValue(OnlineDiscountPercent, 0);
                    end;
                }
                fieldelement(Remarks1; IncomingPOHeader."Remarks 1") { }
                textelement(OrderDate)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader."Order Date" := GetDateValue(OrderDate, 0D);
                    end;
                }
                textelement(PatientDOB)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader."Patient Date of Birth" := GetDateValue(PatientDOB, 0D);
                    end;
                }
                textelement(PatientGender)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        if UpperCase(PatientGender) = UpperCase('Male') then
                            IncomingPOHeader."Patient Gender" := IncomingPOHeader."Patient Gender"::Male
                        else
                            IncomingPOHeader."Patient Gender" := IncomingPOHeader."Patient Gender"::Female;
                    end;
                }
                fieldelement(PatientID; IncomingPOHeader."Patient NRIC/FIN/Passport No.") { }
                fieldelement(DrugAllergies; IncomingPOHeader."Drug Allergies") { }
                fieldelement(ClinicID; IncomingPOHeader."Clinic ID") { }
                fieldelement(ClinicFullName; IncomingPOHeader."Clinic Full Name") { }
                fieldelement(ClinicBranch; IncomingPOHeader."Clinic Branch") { }
                fieldelement(ClinicAddress1; IncomingPOHeader."Clinic Address Line 1") { }
                fieldelement(ClinicAddress2; IncomingPOHeader."Clinic Address Line 2") { }
                fieldelement(ClinicPostalCode; IncomingPOHeader."Clinic Postal Code") { }
                fieldelement(ClinicCountry; IncomingPOHeader."Clinic Country") { }
                fieldelement(DoctorFullName; IncomingPOHeader."Doctor Full Name") { }
                fieldelement(DoctorMobileCountryCode; IncomingPOHeader."Doctor Mobile Country Code") { }
                fieldelement(DoctorMobileNo; IncomingPOHeader."Doctor Mobile No.") { }
                fieldelement(Remarks2; IncomingPOHeader."Remarks 2") { }

                trigger OnBeforeInsertRecord()
                begin
                    if CaptionRow then begin
                        CaptionRow := false;
                        CurrXMLport.Skip();
                    end;
                end;

                trigger OnAfterInitRecord()
                begin
                    if CaptionRow then begin
                        CaptionRow := false;
                        CurrXMLport.Skip();
                    end;
                end;

                trigger OnAfterInsertRecord()
                begin
                    CountVar := CountVar + 1;
                end;
            }

        }

    }

    var
        CaptionRow: Boolean;
        CountVar: Integer;

    trigger OnPreXmlPort()
    begin
        CaptionRow := true;
        CountVar := 0;
    end;

    trigger OnPostXmlPort()
    begin
        Message('Imported %1 record(s). XMLPort Processing Done', CountVar);
    end;

    procedure GetFileName(FileName: Text[200])
    begin
        CurrXMLport.Filename := FileName;
    end;

    local procedure GetTextValue(String: Text[250]): Text
    begin
        exit(String.TrimStart('"').TrimEnd('"'));
    end;

    local procedure GetDateValue(String: Text[250]; DefaultValue: Date): Date
    var
        DateText: Text;
        DateValue: Date;
    begin
        DateValue := DefaultValue;
        DateText := GetTextValue(String);
        if DateText = '' then
            DateValue := DefaultValue
        else
            if not Evaluate(DateValue, DateText) then
                DateValue := DefaultValue;
        exit(DateValue);
    end;

    local procedure GetDecimalValue(String: Text[250]; DefaultValue: Decimal): Decimal
    var
        DecimalText: Text;
        DecimalValue: Decimal;
    begin
        DecimalValue := DefaultValue;
        DecimalText := GetTextValue(String);
        if DecimalText = '' then
            DecimalValue := DefaultValue
        else
            if not Evaluate(DecimalValue, DecimalText) then
                DecimalValue := DefaultValue;
        exit(DecimalValue);
    end;
}