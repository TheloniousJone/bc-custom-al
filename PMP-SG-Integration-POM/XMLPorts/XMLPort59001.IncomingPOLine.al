xmlport 59001 "Import POM PO Line"
{
    Caption = 'Import POM PO Line';
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
            tableelement(IncomingPOLine; POM2DetailsTbl)
            {
                // AutoSave = false;
                // AutoReplace = false;
                // AutoUpdate = false;

                fieldelement(PurchaseOrderID; IncomingPOLine.PurchaseOrderID)
                {
                    trigger OnAfterAssignField()
                    begin
                        IncomingPOLine."Line No." := LineNo;
                    end;
                }
                fieldelement(ProductCode; IncomingPOLine."Product Code") { }
                fieldelement(ProductName; IncomingPOLine."Product Name") { }
                textelement(QuantityOrdered)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOLine.QuantityOrdered := GetDecimalValue(QuantityOrdered, 0);
                    end;
                }
                textelement(BonusQuantity)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOLine.BonusQuantity := GetDecimalValue(BonusQuantity, 0);
                    end;
                }
                textelement(UnitPrice)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOLine.UnitPrice := GetDecimalValue(UnitPrice, 0);
                    end;
                }
                fieldelement(UOMCode; IncomingPOLine.UOMCode) { }
                textelement(ExpiryDate)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        IncomingPOLine.ExpiryDate := GetDateValue(ExpiryDate, 0D);
                    end;
                }

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
                    LineNo := LineNo + 10000;
                end;
            }

        }

    }

    var
        CaptionRow: Boolean;
        CountVar: Integer;
        LineNo: Integer;

    trigger OnPreXmlPort()
    begin
        CaptionRow := true;
        CountVar := 0;
        LineNo := 10000;
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