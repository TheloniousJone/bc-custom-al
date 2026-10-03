page 56100 "Zuellig Integration Setup"
{
    Caption = 'Zuellig Integation Setup';
    PageType = Card;
    SourceTable = "Zuellig Integration Setup";
    PromotedActionCategories = 'Actions';
    UsageCategory = Administration; // Searchable Option
    Editable = true;
    AdditionalSearchTerms = 'Zuellig Integration Setup,Zuellig,EDI,PO,Setup,Config,Configuration';
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            group(General)
            {
                Caption = 'General';

                field("Enable ZPSG Location Code"; Rec."Enable EC-Web Customer ID")
                {
                    ApplicationArea = All;
                }

                field("Default ZPSG Location Code"; Rec."Assigned EC-Web Customer ID")
                {
                    ApplicationArea = All;
                }

                field("Location/Store Code"; Rec."Location/Store Code")
                {
                    ApplicationArea = All;
                }

                field("BC Vendor Code"; Rec."BC Vendor Code")
                {
                    ApplicationArea = All;
                }

            }

        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Simulate QR Code Scanning for GRN")
                {
                    ApplicationArea = all;
                    Caption = 'Simulate QR Code Scanning for GRN';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Simulate;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        sampleQRCode: Text;
                        IntegrationCU: Codeunit "Zuellig Integrations";
                    begin
                        sampleQRCode := 'P113920-1|1084358091|20210616|23214560|1|1|248.15|V49J|20220430|BDS28Z|2|1|5.90|0097286|20250331|CAR27T|10|1|15.50|JY5391|20220630|CYK02I|2|1|71.20|DP6687|20230228|23216148|3|1|36.00|LW61014|20230531|INV02I|30|1|75.00|U011560|20221111|23061757|40|1|5.60|KRU9277|20231031';
                        IntegrationCU.ValidateInvoiceBarcode(sampleQRCode, true);
                    end;
                }

                action("Simulate Invoice ASN Import")
                {
                    ApplicationArea = all;
                    Caption = 'Simulate Invoice ASN Import';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Simulate;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                    begin
                        IntegrationCU.ProcessInvoiceASN(true);
                    end;
                }

            }

        }
    }
}

