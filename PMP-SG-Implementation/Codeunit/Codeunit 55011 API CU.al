/*
                trigger OnAction()
                var
                    url: Label 'https://xxx';
                    ApiCU: Codeunit ApiCU;
                begin
                    ApiCU.SendApi1(url, 'Authorization', 'xxx');
                end;
*/

codeunit 55011 "API CU"
{
    Permissions = tabledata "Sales Invoice Line" = rmid,
                  tabledata "Sales Invoice Header" = rmid;

    trigger OnRun()
    begin
        PixelSquadSetup.Reset();
        PixelSquadSetup.Get();
        PostedSalesInvHeader.Reset();
        PostedSalesInvHeader.SetFilter("Your Reference", 'P3-* | W1-*');
        PostedSalesInvHeader.SetFilter("Posting Date", '24/4/2024..');
        PostedSalesInvHeader.SetRange("I9G Line Export", false);
        if PostedSalesInvHeader.FindSet() then begin
            repeat
                PostedSalesInvLine.Reset();
                PostedSalesInvLine.SetRange("Document No.", PostedSalesInvHeader."No.");
                PostedSalesInvLine.SetRange(Type, "Sales Line Type"::Item);
                PostedSalesInvLine.SetFilter("Posting Date", '24/4/2024..');
                PostedSalesInvLine.SetRange("I9G Line Export", false);
                PostedSalesInvLine.SetFilter(Quantity, '>0');
                if PostedSalesInvLine.FindSet() then begin
                    repeat
                        SendApi1(PixelSquadSetup.Url, PixelSquadSetup.Username, PixelSquadSetup.Password, PostedSalesInvLine);
                    until PostedSalesInvLine.Next() = 0;
                end;
                PostedSalesInvHeader."I9G Line Export" := true;
                PostedSalesInvHeader.Modify(false);
            // Message(PostedSalesInvHeader."No.");
            until PostedSalesInvHeader.Next() = 0;
        end;
    end;

    var
        apiRequestQuery: Text;
        Base64Convert: Codeunit "Base64 Convert";
        PixelSquadSetup: Record "Pixel Squad Setup";
        PostedSalesInvLine: Record "Sales Invoice Line";
        PostedSalesInvHeader: Record "Sales Invoice Header";

    procedure SendApi1(Url: Text[2048]; Username: Text[2048]; Password: Text[2048]; var PostedSalesInvLine: Record "Sales Invoice Line")
    var
        httpClient: HttpClient;
        httpHeader: HttpHeaders;
        httpContent: HttpContent;
        httpRequestMsg: HttpRequestMessage;
        httpResponseMsg: HttpResponseMessage;
        Response: Text;
        Base64String: Text;
    begin
        Clear(apiRequestQuery);

        apiRequestQuery := GenQuery(PostedSalesInvLine);
        // Message(apiRequestQuery);

        httpContent.WriteFrom(apiRequestQuery);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Clear();
        httpHeader.Add('Content-Type', 'application/json');
        httpRequestMsg.GetHeaders(httpHeader);

        Base64String := Base64Convert.ToBase64(Username + ':' + Password);

        httpHeader.Add('Authorization', 'Basic ' + Base64String);
        httpHeader.Add('Accept', 'application/json');
        httpHeader.Add('Accept-Encoding', 'gzip, deflate, br');

        httpRequestMsg.Content := httpContent;

        httpRequestMsg.SetRequestUri(Url);
        httpRequestMsg.Method := 'POST';

        httpClient.Send(httpRequestMsg, httpResponseMsg);
        httpResponseMsg.Content().ReadAs(Response);
        // Message(Response);

        ReadJson(Response);
    end;

    local procedure ReadJson(Response: Text)
    var
        JsonResponse: JsonObject;
        JsonObj1: JsonObject;
        JsonObj2: JsonObject;
        JsonTokenValue: JsonToken;
        JsonTokenArray: JsonToken;
        JsonToken1: JsonToken;
        JsonToken2: JsonToken;
        JsonToken3: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        i: Integer;
        JsonCU: Codeunit "JSON Management";
        Text1: Text;
        Text2: Text;
        Text3: Text;
    begin

        if JsonResponse.ReadFrom(Response) then begin

            if tryGetasArray(JsonResponse) then begin
                JsonResponse.Get('PO_ACK', JsonTokenArray);
                JsonArray := JsonTokenArray.AsArray();

                foreach JsonTokenArray in JsonArray do begin

                    // Message(Format(JsonTokenArray));
                    JsonObj1 := JsonTokenArray.AsObject();

                    JsonObj1.Get('po_no', JsonToken1);
                    JsonObj1.Get('ack_status', JsonToken2);
                    JsonObj1.Get('ack_error', JsonToken3);

                    if JsonToken1.AsValue().IsNull = false then
                        Text1 := JsonToken1.AsValue().AsText();
                    if JsonToken2.AsValue().IsNull = false then
                        Text2 := JsonToken2.AsValue().AsText();
                    if JsonToken3.AsValue().IsNull = false then
                        Text3 := JsonToken3.AsValue().AsText();
                    // Message('%1, %2, %3', Text1, Text2, Text3);
                end;
            end;

            if tryGetasValue(JsonResponse) then begin

                JsonResponse.Get('PO_ACK', JsonTokenValue);

                JsonObj1 := JsonTokenValue.AsObject();
                JsonObj1.Get('ack_status', JsonToken1);
                //or
                //JsonTokenValue.AsObject().Get('ack_status',JsonToken1);

                if JsonToken1.AsValue().IsNull = false then
                    Text1 := JsonToken1.AsValue().AsText();
                if JsonToken2.AsValue().IsNull = false then
                    Text2 := JsonToken2.AsValue().AsText();
                if JsonToken3.AsValue().IsNull = false then
                    Text3 := JsonToken3.AsValue().AsText();
                // Message('%1, %2, %3', Text1, Text2, Text3);
            end;
        end;
    end;

    [TryFunction]
    local procedure tryGetasArray(JsonRespon: JsonObject)
    var
        JsonTokenArray: JsonToken;
        JsonArray: JsonArray;
    begin
        JsonRespon.Get('PO_ACK', JsonTokenArray);
        JsonArray := JsonTokenArray.AsArray();
    end;

    [TryFunction]
    local procedure tryGetasValue(JsonRespon: JsonObject)
    var
        JsonTokenValue: JsonToken;
        JsonObj1: JsonObject;
    begin
        JsonRespon.Get('PO_ACK', JsonTokenValue);
        JsonObj1 := JsonTokenValue.AsObject();
    end;

    local procedure GenQuery(var PostedSalesInvLine: Record "Sales Invoice Line"): Text
    var
        isFirstRecHdr: Boolean;
        isFirstRecLine: Boolean; //for control adding ','
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        PostedSalesInvHeader: Record "Sales Invoice Header";
        StringPos: Integer;
        OrderNoEditedString: Text;
        i: Integer;
        FindString: Label '-';
    begin
        isFirstRecHdr := true;
        isFirstRecLine := true;

        if PostedSalesInvLine.FindFirst() then begin
            apiRequestQuery += '{';
            PostedSalesInvHeader.SetRange("No.", PostedSalesInvLine."Document No.");
            if PostedSalesInvHeader.FindFirst() then
                OrderNoEditedString := PostedSalesInvHeader."Your Reference";

            StringPos := StrPos(OrderNoEditedString, FindString);
            while StringPos <> 0 do begin
                OrderNoEditedString := DelStr(OrderNoEditedString, 1, StringPos);
                StringPos := StrPos(OrderNoEditedString, FindString);
            end;

            apiRequestQuery += '    "Order_No": "' + OrderNoEditedString + '",';
            apiRequestQuery += '    "Item_No": "' + PostedSalesInvLine."No." + '",';

            SalesLine.Reset();
            SalesLine.SetRange("Document Type", "Sales Document Type"::Order);
            SalesLine.SetRange("Document No.", PostedSalesInvLine."Order No.");
            SalesLine.SetRange("Line No.", PostedSalesInvLine."Line No.");

            if SalesLine.FindFirst() then begin
                apiRequestQuery += '    "Quantity_Ordered": ' + Format(SalesLine."Order Qty") + ',';
                apiRequestQuery += '    "Quantity_Delivered": ' + Format(SalesLine."Qty Delivered") + ',';
                apiRequestQuery += '    "FOC_Quantity": ' + Format(SalesLine."FOC Qty") + ',';
                apiRequestQuery += '    "FOC_Quantity_Delivered": ' + Format(SalesLine."FOC Qty Delivered");
            end
            else begin
                apiRequestQuery += '    "Quantity_Ordered": ' + Format(PostedSalesInvLine."Order Qty") + ',';
                apiRequestQuery += '    "Quantity_Delivered": ' + Format(PostedSalesInvLine."Qty Delivered" + PostedSalesInvLine."Qty To Deliver") + ',';
                apiRequestQuery += '    "FOC_Quantity": ' + Format(PostedSalesInvLine."FOC Qty") + ',';
                apiRequestQuery += '    "FOC_Quantity_Delivered": ' + Format(PostedSalesInvLine."FOC Qty Delivered" + PostedSalesInvLine."FOC Qty To Deliver");
            end;


            apiRequestQuery += '}';

            // Sample
            // apiRequestQuery += '{';
            // apiRequestQuery += '"Order_No": "2775",'; //POM Order No. ('Your Reference' field in BC is P3-115-2775, we only take characters after the last -
            // apiRequestQuery += '"Item_No": "ACT31T",'; //BC SKU
            // apiRequestQuery += '"Quantity_Ordered": 10,'; //in posted sales Inv line
            // apiRequestQuery += '"Quantity_Delivered": 10,'; //to check from Sales Order no. and sales order line. if not exist means follow "Quantity_Ordered"
            // apiRequestQuery += '"FOC_Quantity": 0,'; //in posted sales Inv line
            // apiRequestQuery += '"FOC_Quantity_Delivered": 0';
            // apiRequestQuery += '}';

            PostedSalesInvLine.Validate("I9G Line Export", true);
            PostedSalesInvLine.Modify();
        end;

        exit(apiRequestQuery);
    end;

    /*
   {
        "Order_No": "2775", //POM Order No. ('Your Reference' field in BC is P3-115-2775, we only take characters after the last -
        "Item_No": "ACT31T", //BC SKU
        "Quantity_Ordered": 10, //in posted sales Inv line
        "Quantity_Delivered": 10, //to check from Sales Order no. and sales order line. if not exist means follow "Quantity_Ordered"
        "FOC_Quantity": 0, //in posted sales Inv line
        "FOC_Quantity_Delivered": 0
    }
    */
}
//reference : https://businesscentralgeek.com/json-full-guide-in-business-central