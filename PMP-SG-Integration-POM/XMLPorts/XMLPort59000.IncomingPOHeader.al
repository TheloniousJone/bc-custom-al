xmlport 59000 "Import POM PO Header"
{
    Caption = 'Import POM PO Header';
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
            tableelement(IncomingPOHeader; POM2HeaderTbl)
            {
                // AutoSave = false;
                // AutoReplace = false;
                // AutoUpdate = false;

                fieldelement(PurchaseOrderID; IncomingPOHeader.PurchaseOrderID) { }
                textelement(TransactionDate)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader.TransactionDate := GetDateValue(TransactionDate, WorkDate());
                    end;
                }
                fieldelement(PhysicalPOID; IncomingPOHeader.PhysicalPOID) { }
                fieldelement(CustomerAccount; IncomingPOHeader."Customer Account") { }
                fieldelement(CustomerName; IncomingPOHeader."Customer Name") { }
                fieldelement(LoginID; IncomingPOHeader.LoginID) { }
                fieldelement(OrderBy; IncomingPOHeader.OrderBy) { }
                fieldelement(Currency; IncomingPOHeader.Currency) { }
                fieldelement(TermsOfPayment; IncomingPOHeader."Terms of Payment") { }
                fieldelement(ContactPerson; IncomingPOHeader.ContactPerson) { }
                fieldelement(StreetName; IncomingPOHeader.StreetName) { }
                fieldelement(CountryRegion; IncomingPOHeader."Country/Region") { }
                fieldelement(ZipCode; IncomingPOHeader."Zip Code") { }
                fieldelement(Email; IncomingPOHeader.Email) { }
                fieldelement(Telephone; IncomingPOHeader.Telephone) { }
                fieldelement(Fax; IncomingPOHeader.Fax) { }
                textelement(OnlineDiscountAmount)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader.OnlineDiscountAmount := GetDecimalValue(OnlineDiscountAmount, 0);
                    end;
                }
                textelement(OnlineDiscountPercent)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOHeader.OnlineDiscountPercent := GetDecimalValue(OnlineDiscountPercent, 0);
                    end;
                }
                fieldelement(Remarks; IncomingPOHeader.Remarks) { }

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