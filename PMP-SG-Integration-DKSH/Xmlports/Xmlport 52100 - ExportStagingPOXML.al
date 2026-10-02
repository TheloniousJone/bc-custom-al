xmlport 52100 "Export DKSH Staging PO XML"
{
    Caption = 'Export DKSH Staging PO XML';
    Direction = Export;
    Format = Xml;
    UseRequestPage = false;
    Encoding = UTF8;
    Namespaces = sanc = 'http://www.sanc.org.sg/schemas/ean';

    schema
    {
        tableelement("order"; "DKSH Staging Purch. Order Hdr.")
        {
            NamespacePrefix = 'sanc';

            textattribute("xmlns:xsi")
            {
                trigger OnBeforePassVariable()
                begin
                    "xmlns:xsi" := 'http://www.w3.org/2001/XMLSchema-instance'
                end;
            }

            fieldelement("version"; "order".version)
            {
                fieldattribute(Spec; "order".seller_postalCode) { }

                textattribute(County)
                {
                    trigger OnBeforePassVariable()
                    begin
                        County := 'COPY';
                    end;
                }

            }
        }
    }
}