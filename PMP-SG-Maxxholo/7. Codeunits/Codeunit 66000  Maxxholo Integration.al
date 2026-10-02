codeunit 66000 "Maxxholo Integration"
{
    trigger OnRun()
    begin

    end;

    var

    procedure IsItemMaxxholo(par_ItemNo: Code[20]): Boolean
    var
        lrec_Item: Record Item;
    begin
        lrec_Item.Reset();
        lrec_Item.SetRange("No.", par_ItemNo);
        lrec_Item.SetRange(I9G_Maxxholo, true);
        if lrec_Item.FindFirst() then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;

    procedure checkMaxxholoHdrField(par_MaxxholoHdr: Record MaxxholoHeader)
    var
    begin
        par_MaxxholoHdr.TestField(I9G_DocNo);
        par_MaxxholoHdr.TestField(I9G_BillAddress);
        par_MaxxholoHdr.TestField(I9G_BillCode);
        par_MaxxholoHdr.TestField(I9G_BillName);
        par_MaxxholoHdr.TestField(I9G_ProductCode);
        par_MaxxholoHdr.TestField(I9G_ProductName);
        par_MaxxholoHdr.TestField(I9G_ShipAddress);
        par_MaxxholoHdr.TestField(I9G_ShipCode);
        par_MaxxholoHdr.TestField(I9G_ShipName);
        // par_MaxxholoHdr.TestField();
    end;

    procedure CheckingHeaderMaxxholoCheck(var par_CheckingLine: Record "Checking Line")
    var
        lrec_Item: Record Item;
        lrec_MaxxholoHeader: Record MaxxholoHeader;
        lrec_MaxxholoLine: Record MaxxholoLine;
    begin
        if par_CheckingLine.FindSet() then begin
            repeat
                // lrec_Item.Reset();
                // lrec_Item.SetRange("No.", par_CheckingLine."Item No.");
                // lrec_Item.SetRange(I9G_Maxxholo, true);
                // if lrec_Item.FindFirst() then begin
                if IsItemMaxxholo(par_CheckingLine."Item No.") then begin
                    lrec_MaxxholoHeader.Reset();
                    lrec_MaxxholoHeader.SetRange(I9G_SourceDocNo, par_CheckingLine."Doc No.");
                    lrec_MaxxholoHeader.SetRange(I9G_SourceDocLineNo, par_CheckingLine."Line No.");
                    lrec_MaxxholoHeader.SetRange(I9G_ProductCode, par_CheckingLine."Item No.");
                    if lrec_MaxxholoHeader.FindFirst() then begin
                        lrec_MaxxholoLine.Reset();
                        lrec_MaxxholoLine.SetRange(I9G_DocNo, lrec_MaxxholoHeader.I9G_DocNo);
                        if lrec_MaxxholoLine.Count <> par_CheckingLine.Quantity then begin
                            Error('%1 number of Label IDs is needed for for Whse. Shipment Line, Document No. : %2 , Line No. : %3 , Item No. : %4'
                            , par_CheckingLine.Quantity, par_CheckingLine."Doc No.", par_CheckingLine."Line No.", par_CheckingLine."Item No.");
                        end;
                    end else begin
                        Error('Please insert %1 Label IDs for Whse. Shipment Line, Document No. : %2 , Line No. : %3 , Item No. : %4'
                        , par_CheckingLine.Quantity, par_CheckingLine."Doc No.", par_CheckingLine."Line No.", par_CheckingLine."Item No.");
                    end;
                end;
            until par_CheckingLine.Next() = 0;
        end;
    end;

    [TryFunction]
    procedure InsertRecord(entity: text; object: JsonObject; crmUrl: text; accessToken: text; var responseText: Text)
    var
        jsonText: text;
        client: HttpClient;
        content: HttpContent;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        request: HttpRequestMessage;
        j: JsonObject;
        jsonToken: JsonToken;
    begin
        // if client.Get('http://echo-http-requests.appspot.com/echo', response) then begin
        //     if response.IsSuccessStatusCode() then begin
        //         response.content().ReadAs(jsonText);
        //         Message(jsonText);
        //     end;
        // end;
        object.WriteTo(jsonText);
        content.WriteFrom(jsonText);

        content.GetHeaders(headers);
        headers.Clear();
        headers.Add('Content-Type', 'application/json');
        headers.Add('MERCHANTID', accessToken);

        // crmUrl := 'http://61.8.238.204/InfologPGNWebAPI/API/prod';
        // client.SetBaseAddress('http://61.8.238.204/InfologPGNWebAPI/API/prod');
        // client.DefaultRequestHeaders.Add('MERCHANTID', accessToken);

        if client.Post(crmUrl, content, response)
        then begin
            response.Content().ReadAs(responseText);

            // if not response.IsSuccessStatusCode then
            //     Error('The web service returned an error message:\\' +
            //           'Status code: %1\' +
            //           'Description: %2\' +
            //           'Text: %3',
            //           response.HttpStatusCode,
            //           response.ReasonPhrase,
            //           jsonText);

            // // Message(jsonText);
            // // exit(jsonText);
            // Message(responseText);

        end
        else begin
            Error('Failed to connect to Maxxholo');
        end;
    end;

    procedure sendToMaxxholo(var CheckingHeader: Record "Checking Header"; par_SourceLineNo: Integer)
    var
        JObjectLabel: JsonObject;
        JArrayLabel: JsonArray;
        JobjectMaxxHolo: JsonObject;

        lrec_CheckingLine: Record "Checking Line";
        lrec_MaxxholoHeader: Record MaxxholoHeader;
        lrec_MaxxholoLine: Record MaxxholoLine;
        lrec_Item: Record Item;
        lrec_MaxxholoSetup: Record MaxxholoSetup;

        responseText: Text;
        responseObj: JsonObject;
        responseToken: JsonToken;
        responseSubToken: JsonToken;
        responseSubToken2: JsonToken;
        responseSubToken3: JsonToken;
        responseSubToken4: JsonToken;

        counter: Integer;
        ErrMsg: Text;
    begin
        lrec_CheckingLine.Reset();
        lrec_CheckingLine.SetLoadFields("Doc No.", "Line No.", "Item No.");
        lrec_CheckingLine.SetRange("Doc No.", CheckingHeader."No.");
        if par_SourceLineNo <> 0 then
            lrec_CheckingLine.SetRange("Line No.", par_SourceLineNo);
        if lrec_CheckingLine.FindSet() then begin
            CheckingHeaderMaxxholoCheck(lrec_CheckingLine);
            repeat
                lrec_Item.Reset();
                lrec_Item.SetLoadFields(I9G_Maxxholo);
                lrec_Item.SetRange("No.", lrec_CheckingLine."Item No.");
                lrec_Item.SetRange(I9G_Maxxholo, true);
                if lrec_Item.FindFirst() then begin
                    lrec_MaxxholoHeader.Reset();
                    lrec_MaxxholoHeader.SetRange(I9G_SourceDocNo, lrec_CheckingLine."Doc No.");
                    lrec_MaxxholoHeader.SetRange(I9G_SourceDocLineNo, lrec_CheckingLine."Line No.");
                    lrec_MaxxholoHeader.SetRange(I9G_ProductCode, lrec_CheckingLine."Item No.");
                    if lrec_MaxxholoHeader.FindFirst() then begin
                        checkMaxxholoHdrField(lrec_MaxxholoHeader);
                        lrec_MaxxholoLine.Reset();
                        lrec_MaxxholoLine.SetRange(I9G_DocNo, lrec_MaxxholoHeader.I9G_DocNo);
                        if lrec_MaxxholoLine.FindSet() then begin
                            Clear(JArrayLabel);
                            repeat
                                // Clear(JObjectLabel);
                                // JObjectLabel.Add(lrec_MaxxholoLine.I9G_LabelID);
                                JArrayLabel.Add(lrec_MaxxholoLine.I9G_LabelID);
                            until lrec_MaxxholoLine.Next() = 0;
                            JobjectMaxxHolo.Add('labelIds', JArrayLabel);
                            JobjectMaxxHolo.Add('batchId', lrec_MaxxholoHeader.I9G_DocNo);
                            JobjectMaxxHolo.Add('shipCode', lrec_MaxxholoHeader.I9G_ShipCode);
                            JobjectMaxxHolo.Add('shipName', lrec_MaxxholoHeader.I9G_ShipName);
                            JobjectMaxxHolo.Add('shipAddress', lrec_MaxxholoHeader.I9G_ShipAddress);
                            JobjectMaxxHolo.Add('billCode', lrec_MaxxholoHeader.I9G_BillCode);
                            JobjectMaxxHolo.Add('billName', lrec_MaxxholoHeader.I9G_BillName);
                            JobjectMaxxHolo.Add('billAddress', lrec_MaxxholoHeader.I9G_BillAddress);
                            JobjectMaxxHolo.Add('productCode', lrec_MaxxholoHeader.I9G_ProductCode);
                            JobjectMaxxHolo.Add('productName', lrec_MaxxholoHeader.I9G_ProductName);
                            // Message(Format(JobjectMaxxHolo));

                            lrec_MaxxholoSetup.Get();
                            InsertRecord('', JobjectMaxxHolo, lrec_MaxxholoSetup.I9G_URL, lrec_MaxxholoSetup.I9G_MerchantID, responseText);

                            if responseObj.ReadFrom(responseText) then begin
                                // Message(Format(responseObj));
                                if responseObj.Get('Status', responseToken) then begin
                                    if responseToken.AsValue().AsText() = 'true' then begin
                                        lrec_MaxxholoHeader.I9G_SentMaxxholo := true;
                                        lrec_MaxxholoHeader.I9G_ResponseFrmMaxxholo := 'SUCCESS';
                                        lrec_MaxxholoHeader.Modify();
                                        Message('SUCCESS');
                                    end;
                                end else begin
                                    if responseObj.Get('error', responseToken) then begin
                                        if responseToken.AsObject().Get('message', responseSubToken) then begin
                                            if responseSubToken.AsValue().AsText() <> '' then begin
                                                lrec_MaxxholoHeader.I9G_ResponseFrmMaxxholo := responseSubToken.AsValue().AsText();
                                                lrec_MaxxholoHeader.Modify();
                                                Message(Format(responseObj));
                                            end;
                                        end;
                                    end else begin
                                        Error(Format(responseObj));
                                    end;
                                end;
                            end;
                        end else begin

                        end;
                    end else begin

                    end;
                end;
            until lrec_CheckingLine.Next() = 0;
        end else begin

        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Checking Card", 'OnCheckProofTag', '', false, false)]
    local procedure OnCheckProofTag(CheckingHeader: Record "Checking Header");
    var
        CheckingLine: Record "Checking Line";
        CheckingProofTagLine: Record "Checking Proof Tag Line";
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
    begin
        CheckingLine.Reset();
        CheckingLine.SetRange("Doc No.", CheckingHeader."No.");
        if CheckingLine.FindSet() then begin
            InventorySetup.Get();

            repeat
                Item.Reset();
                if Item.Get(CheckingLine."Item No.") then begin
                    if Item.I9G_ProofTag = true then begin
                        InventorySetup.TestField(I9G_SiteID);

                        CheckingProofTagLine.Reset();
                        CheckingProofTagLine.SetRange("Doc No.", CheckingLine."Doc No.");
                        CheckingProofTagLine.SetRange("Doc Line No.", CheckingLine."Line No.");
                        CheckingProofTagLine.SetFilter("Proof Tag Reference", '<> %1', '');
                        if CheckingProofTagLine.IsEmpty then
                            Error('Proof Tag Reference for Doc Line No. %1 cannot be empty.', CheckingLine."Line No.");
                    end;
                end;
            until CheckingLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Checking Card", 'OnInsertProofTag', '', false, false)]
    local procedure OnInsertProofTag(SalesInvoiceHeader: Record "Sales Invoice Header"; CheckingHeader: Record "Checking Header");
    var
        //SalesInvoiceLine: Record "Sales Invoice Line";
        CheckingLine: Record "Checking Line";
        CheckingProofTagLine: Record "Checking Proof Tag Line";
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
        ProofTag: Record "Proof Tag";
    begin
        CheckingLine.Reset();
        CheckingLine.SetRange("Doc No.", CheckingHeader."No.");
        if CheckingLine.FindSet() then begin
            InventorySetup.Get();

            repeat
                if Item.Get(CheckingLine."Item No.") then begin
                    if Item.I9G_ProofTag = true then begin
                        CheckingProofTagLine.Reset();
                        CheckingProofTagLine.SetRange("Doc No.", CheckingLine."Doc No.");
                        CheckingProofTagLine.SetRange("Doc Line No.", CheckingLine."Line No.");
                        CheckingProofTagLine.SetFilter("Proof Tag Reference", '<> %1', '');
                        if CheckingProofTagLine.FindSet() then begin
                            repeat
                                ProofTag.Init();
                                ProofTag."Entry No." := 0;
                                ProofTag.EN := '204';
                                ProofTag.EV_DATE := SalesInvoiceHeader."Posting Date";
                                ProofTag.TARGET_SITE_ID := InventorySetup.I9G_SiteID;
                                ProofTag.REFERENCE := CheckingProofTagLine."Proof Tag Reference";
                                ProofTag.EVT_DATA1 := SalesInvoiceHeader."No.";

                                if SalesInvoiceHeader."Sell-to Country/Region Code" = '' then
                                    ProofTag.EVT_DATA2 := 'SG'
                                else
                                    ProofTag.EVT_DATA2 := SalesInvoiceHeader."Sell-to Country/Region Code";

                                ProofTag."Document No." := CheckingLine."Doc No.";
                                ProofTag."Document Line No." := CheckingLine."Line No.";
                                ProofTag."Item No." := CheckingLine."Item No.";

                                ProofTag.Insert();
                            until CheckingProofTagLine.Next() = 0;
                        end;
                    end;
                end;
            until CheckingLine.Next() = 0;
        end;

        /*
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SetFilter(Quantity, '<> %1', 0);
        if SalesInvoiceLine.FindSet() then begin
            repeat
                if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
                    if Item.Get(SalesInvoiceLine."No.") then begin
                        if Item.I9G_ProofTag = true then begin
                            InventorySetup.Get();

                            ProofTag.Init();
                            ProofTag."Entry No." := 0;
                            ProofTag.EN := '204';
                            ProofTag.EV_DATE := SalesInvoiceHeader."Posting Date";
                            ProofTag.TARGET_SITE_ID := InventorySetup.I9G_SiteID;
                            ProofTag.REFERENCE := CheckingHeader.I9G_ProofTagReference;
                            ProofTag.EVT_DATA1 := SalesInvoiceHeader."No.";

                            if SalesInvoiceHeader."Sell-to Country/Region Code" = '' then
                                ProofTag.EVT_DATA2 := 'SG'
                            else
                                ProofTag.EVT_DATA2 := SalesInvoiceHeader."Sell-to Country/Region Code";

                            ProofTag.Insert();
                        end;
                    end;
                end;
            until SalesInvoiceLine.Next() = 0;
        end;
        */
    end;

}