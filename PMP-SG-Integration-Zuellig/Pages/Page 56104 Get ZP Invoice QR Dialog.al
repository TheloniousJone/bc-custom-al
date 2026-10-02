page 56104 "Get ZP Invoice QR Dialog"
{
    // PageType = Card;
    PageType = StandardDialog;
    Caption = 'Get ZP Invoice QR Dialog';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Get ZP Invoice QR Dialog';
                ShowCaption = false;

                field(QRCode; QRCode)
                {
                    Caption = 'QR Code';
                    Description = 'QR Code';
                    ApplicationArea = All;
                }

            }
        }
    }

    var
        QRCode: Text[1000];

    procedure GetQRCode(): Text[1000];
    begin
        exit(QRCode);
    end;

}