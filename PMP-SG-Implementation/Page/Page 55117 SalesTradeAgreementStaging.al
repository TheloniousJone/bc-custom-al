page 55117 SalesTradeAgreementStaging
{

    ApplicationArea = All;
    Caption = 'Sales Trade Agreement Staging';
    PageType = List;
    SourceTable = "Sales Trade Agreement Staging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sales Type"; Rec."Sales Type")
                {
                    ToolTip = 'Specifies the value of the Sales Type field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ToolTip = 'Specifies the value of the Sales Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                //DX        31 Jan 2025
                field(CustName; CustomerRec.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    Editable = false;
                }
                field(CustPriceGroup; CustomerRec."Customer Price Group")
                {
                    ApplicationArea = all;
                    Caption = 'Price Group';
                    Editable = false;
                }
                field(CustStatus; CustomerRec."Customer Status")
                {
                    ApplicationArea = all;
                    Caption = 'Customer Status';
                    Editable = false;
                }
                field(CustSalesClassification; CustomerRec."Customer Sales Classification")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                //DX        31 Jan 2025
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                    Editable = false;
                    Visible = true;
                }
                //DX        31 Jan 2025
                field(ItemStatus; ItemRec."Item Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //DX        31 Jan 2025
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Visible = false;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the value of the Minimum Quantity field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;

                    // YF 10 Jun 2022
                    trigger OnValidate()
                    begin
                        if Rec."Minimum Quantity" = 0 then
                            Rec."Minimum Quantity" := 1;
                    end;
                    // YF 10 Jun 2022
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ToolTip = 'Specifies the value of the Price Includes VAT field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Line Disc. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Invoice Disc field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Gr. (Price) field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;

                    trigger OnValidate()
                    begin
                        if Rec.Status = Rec.Status::Active then
                            gFieldStyle := ''
                        else
                            gFieldStyle := 'Attention';
                    end;
                }

                field(RecRefId; Rec.RecRefID)
                {
                    ApplicationArea = all;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }
                //RL    05 Jan 2021
                field(Principal; Principal)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //RL    05 Jan 2021

                // YF 18 Mar 2022
                field("TA Type"; Rec."TA Type")
                {
                    ApplicationArea = All;
                }

                field("Find Next"; Rec."Find Next")
                {
                    ApplicationArea = All;
                }
                // YF 18 Mar 2022
                field(SalesRepWS; SalesRepWS)
                {
                    ApplicationArea = All;
                    caption = 'Sales Rep (WS)';
                }
                field(I9G_LineStatus; Rec.I9G_LineStatus)
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
            action(Convert2PharmaPriceList)
            {
                Caption = 'Convert to Sales Trade Agreement';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    processLines();
                end;
            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemRec: Record item;
        ItemDesc: Text[100];
        Principal: Text[100];
        CustomerRec: Record Customer;
        SalesRepWS: Code[20];


    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
    end;

    trigger OnAfterGetRecord()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';

        ItemDesc := '';
        ItemRec.reset;
        ItemRec.SetLoadFields("No.", "Item Sales Classification", "Item Status", Description, Principal);   //DX        31 Jan 2025
        ItemRec.SetRange("No.", Rec."Item No.");
        ItemUOM.Reset;
        ItemUOM.SetLoadFields("Item No.", Code, "Alternate Description");     //DX        31 Jan 2025
        ItemUOM.SetRange("Item No.", Rec."Item No.");
        ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
        if Rec."Item No." <> '' then begin
            if ItemRec.FindFirst() then
                ItemDesc := ItemRec.Description;
            Principal := ItemRec.Principal;
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then begin
                    ItemDesc := ItemUOM."Alternate Description";
                end;
            end;
        end;

        CustomerRec.reset;
        CustomerRec.SetLoadFields("No.", "Corporate  Sales Rep (WS)", "Customer Price Group", "Customer Sales Classification", "Customer Status", Name);
        SalesRepWS := '';
        CustomerRec.SetRange("No.", Rec."Sales Code");
        if (Rec."Sales Code" <> '') and (Rec."Sales Type" = Rec."Sales Type"::Customer) then begin
            if CustomerRec.FindFirst() then
                SalesRepWS := CustomerRec."Corporate  Sales Rep (WS)";
        end;

        if Rec.I9G_LineStatus = Rec.I9G_LineStatus::Released then
            CurrPage.Editable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Active;
        Rec."Minimum Quantity" := 1; // YF 10 Jun 2022
    end;

    procedure processLines()
    var
        lrec_SalesTradeStaging: Record "Sales Trade Agreement Staging";
        lrec_PharmaSalesPrice: Record "Pharma Sales Price";
        lrec_PharmaSalesPrice2: Record "Pharma Sales Price";
        lrec_Item: Record Item;

        EmailInStream: InStream;
        EmailOutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        CompInfo: Record "Company Information";
        ToFile: Text;
        lrec_SL: Record "Sales Line" temporary;
        lrec_SL2: Record "Sales Line" temporary;
        lint_LineNo: Integer;
    // Items: Text;
    begin
        Clear(lrec_SalesTradeStaging);
        CurrPage.SetSelectionFilter(lrec_SalesTradeStaging);

        lrec_SalesTradeStaging.SetRange(I9G_LineStatus, lrec_SalesTradeStaging.I9G_LineStatus::Open);
        if lrec_SalesTradeStaging.FindSet() then begin
            repeat
                lrec_PharmaSalesPrice.Reset();
                lrec_PharmaSalesPrice.SetRange("Sales Type", lrec_SalesTradeStaging."Sales Type");
                lrec_PharmaSalesPrice.SetRange("Sales Code", lrec_SalesTradeStaging."Sales Code");
                lrec_PharmaSalesPrice.SetRange("Item No.", lrec_SalesTradeStaging."Item No.");
                lrec_PharmaSalesPrice.SetRange("Currency Code", lrec_SalesTradeStaging."Currency Code");
                lrec_PharmaSalesPrice.SetRange("Unit Of Measure Code", lrec_SalesTradeStaging."Unit Of Measure Code");
                lrec_PharmaSalesPrice.SetRange("Minimum Quantity", lrec_SalesTradeStaging."Minimum Quantity");
                lrec_PharmaSalesPrice.SetFilter("Ending Date", '>=%1', lrec_SalesTradeStaging."Starting Date");
                lrec_PharmaSalesPrice.SetRange("TA Type", lrec_SalesTradeStaging."TA Type");
                lrec_PharmaSalesPrice.SetFilter(Status, '=%1', lrec_PharmaSalesPrice.Status::Active);
                if lrec_PharmaSalesPrice.FindSet() then begin
                    repeat
                        lrec_PharmaSalesPrice."Ending Date" := CalcDate('-1D', lrec_SalesTradeStaging."Starting Date");
                        lrec_PharmaSalesPrice.Modify();
                    until lrec_PharmaSalesPrice.Next() = 0;
                end;

                lrec_PharmaSalesPrice.Reset();
                lrec_PharmaSalesPrice.Init();
                lrec_PharmaSalesPrice.TransferFields(lrec_SalesTradeStaging);
                if lrec_PharmaSalesPrice.Insert(true) then begin
                    //Send Email if Sales Typs = Customer >>
                    if (lrec_SalesTradeStaging."Sales Type" = lrec_SalesTradeStaging."Sales Type"::Customer) or (lrec_SalesTradeStaging."Sales Code" = 'IHH') then begin
                        lint_LineNo += 10000;
                        lrec_SL.Reset();
                        lrec_SL.Init();
                        lrec_SL."Document Type" := lrec_SL."Document Type"::"Blanket Order";
                        lrec_SL."Document No." := 'S-TRADE-A';
                        lrec_SL."Line No." := lint_LineNo;
                        lrec_SL."Sell-to Customer No." := lrec_SalesTradeStaging."Sales Code";
                        lrec_SL."No." := lrec_SalesTradeStaging."Item No.";
                        lrec_Item.Reset();
                        lrec_Item.SetLoadFields(Description);
                        lrec_Item.SetRange("No.", lrec_SalesTradeStaging."Item No.");
                        if lrec_Item.FindFirst() then begin
                            lrec_SL.Description := lrec_Item.Description;
                        end;
                        lrec_SL.Insert();
                        lrec_PharmaSalesPrice2.Reset();
                        lrec_PharmaSalesPrice2.SetLoadFields("Unit Price");
                        lrec_PharmaSalesPrice2.SetRange("Sales Type", lrec_SalesTradeStaging."Sales Type");
                        lrec_PharmaSalesPrice2.SetRange("Sales Code", lrec_SalesTradeStaging."Sales Code");
                        lrec_PharmaSalesPrice2.SetRange("Item No.", lrec_SalesTradeStaging."Item No.");
                        lrec_PharmaSalesPrice2.SetRange("Currency Code", lrec_SalesTradeStaging."Currency Code");
                        lrec_PharmaSalesPrice2.SetRange("Unit Of Measure Code", lrec_SalesTradeStaging."Unit Of Measure Code");
                        lrec_PharmaSalesPrice2.SetRange("Minimum Quantity", lrec_SalesTradeStaging."Minimum Quantity");
                        lrec_PharmaSalesPrice2.SetFilter("Ending Date", '=%1', CalcDate('-1D', lrec_SalesTradeStaging."Starting Date"));
                        lrec_PharmaSalesPrice2.SetRange("TA Type", lrec_SalesTradeStaging."TA Type");
                        lrec_PharmaSalesPrice2.SetFilter(Status, '=%1', lrec_PharmaSalesPrice2.Status::Active);
                        if lrec_PharmaSalesPrice2.FindLast() then begin
                            lrec_SL."Unit Cost" := lrec_PharmaSalesPrice2."Unit Price"; //From Price.
                        end;
                        lrec_SL."Unit Price" := lrec_SalesTradeStaging."Unit Price";
                        lrec_SL."Shipment Date" := lrec_SalesTradeStaging."Starting Date";
                        lrec_SL."Unit Volume" := lrec_SalesTradeStaging."Minimum Quantity";     //DX        31 Jan 2025
                        lrec_SL.Modify();

                        lrec_SL2.Reset();
                        lrec_SL2.Init();
                        lrec_SL2.TransferFields(lrec_SL);
                        lrec_SL2."Document No." := 'S-TRADE-A2';
                        lrec_SL2.Insert();

                        lrec_SalesTradeStaging.I9G_LineStatus := lrec_SalesTradeStaging.I9G_LineStatus::Released;
                        lrec_SalesTradeStaging.Modify();
                    end;

                end;
            until lrec_SalesTradeStaging.Next() = 0;

            if lrec_SalesTradeStaging."Sales Type" = lrec_SalesTradeStaging."Sales Type"::"Customer Price Group" then
                ProcessSendMailWithCustPriceGroup(lrec_SL, lrec_SL2)
            else
                ProcessSendMail(lrec_SalesTradeStaging, lrec_SL, lrec_SL2);
        end;
    end;

    procedure ProcessSendMail(var lrec_SalesTradeStaging: Record "Sales Trade Agreement Staging"; var lrec_SL: Record "Sales Line"; var lrec_SL2: Record "Sales Line")
    var
        LCustRec: Record Customer;
        SSetup: Record "Sales & Receivables Setup";
        EmailToList: List of [Text];
        EmailBody: Text;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        SSetup.Get();

        lrec_SL.Reset();
        if lrec_SL.FindSet() then begin
            repeat
                lrec_SL2.Reset();
                lrec_SL2.SetRange("Sell-to Customer No.", lrec_SL."Sell-to Customer No.");
                if lrec_SL2.FindSet() then begin

                    LCustRec.RESET;
                    if LCustRec.Get(lrec_SalesTradeStaging."Sales Code") then begin
                        if LCustRec.I9G_EmailonPriceChg <> '' then begin
                            Clear(EmailToList);
                            if StrPos(LCustRec.I9G_EmailonPriceChg, ';') > 0 then begin
                                EmailToList := LCustRec.I9G_EmailonPriceChg.Split(';');
                            end else begin
                                EmailToList.Add(LCustRec.I9G_EmailonPriceChg);
                            end;
                            EmailBody := SSetup.I9G_SalesTradeAgreementStaging;

                            EmailBody += '<br><br> Price Changed for Items : ';

                            repeat
                                EmailBody += '<br>' + lrec_SL2."No.";
                                EmailBody += '<br>' + lrec_SL2.Description;
                                EmailBody += '<br>  Price from : ' + format(lrec_SL2."Unit Cost");
                                EmailBody += '<br>  Price to : ' + format(lrec_SL2."Unit Price");
                                EmailBody += '<br> Effective date from ' + format(lrec_SL."Shipment Date") + '<br>';
                                EmailBody += '<br> Minimum Quantity : ' + format(lrec_SL."Unit Volume") + '<br>';
                                lrec_SL2.Delete();
                            until lrec_SL2.Next() = 0;

                            EmailBody += '<br><br> "This is an auto-generated email, please DO NOT REPLY. Any replies to this email will be disregarded."';

                            EmailMessage.Create(EmailToList, 'Price Changed for Items', EmailBody, true);

                            if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then
                                Message('Failed to send email for ' + LCustRec."No." + '.')
                            else
                                Message('Email Sent');

                            EmailBody := '';
                        end;
                    end;
                end;

            until lrec_SL.Next() = 0;
        end;
    end;

    procedure ProcessSendMailWithCustPriceGroup(var lrec_SL: Record "Sales Line"; var lrec_SL2: Record "Sales Line")
    var
        SSetup: Record "Sales & Receivables Setup";
        EmailToList: List of [Text];
        EmailBody: Text;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        SSetup.Get();

        lrec_SL.Reset();
        if lrec_SL.FindSet() then begin
            repeat
                lrec_SL2.Reset();
                lrec_SL2.SetRange("Sell-to Customer No.", lrec_SL."Sell-to Customer No.");
                if lrec_SL2.FindSet() then begin

                    Clear(EmailToList);
                    EmailToList.Add(SSetup."Distribution Email");

                    EmailBody := SSetup.I9G_SalesTradeAgreementStaging;
                    EmailBody += '<br><br> Price Changed for Items : ';

                    repeat
                        EmailBody += '<br>' + lrec_SL2."No.";
                        EmailBody += '<br>' + lrec_SL2.Description;
                        EmailBody += '<br>  Price from : ' + format(lrec_SL2."Unit Cost");
                        EmailBody += '<br>  Price to : ' + format(lrec_SL2."Unit Price");
                        EmailBody += '<br> Effective date from ' + format(lrec_SL."Shipment Date") + '<br>';
                        lrec_SL2.Delete();
                    until lrec_SL2.Next() = 0;

                    EmailBody += '<br><br> "This is an auto-generated email, please DO NOT REPLY. Any replies to this email will be disregarded."';

                    EmailMessage.Create(EmailToList, 'Price Changed for Items', EmailBody, true);

                    if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then
                        Message('Failed to send email.')
                    else
                        Message('Email Sent');

                    EmailBody := '';
                end;

            until lrec_SL.Next() = 0;
        end;
    end;

}
