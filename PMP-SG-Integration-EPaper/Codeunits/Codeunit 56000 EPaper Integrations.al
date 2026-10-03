codeunit 56000 "EPaper Integrations"
{
    // YF        05 Aug 2021         Handle Connection Timeout Issues

    local procedure CheckSetup();
    begin
        if Not EPaperIntegrationSetup.Get() then
            Error('EPaper Integration not Setup');
    end;

    procedure Login(): Text;
    var
        ErrorState: Boolean;
        ErrorCode: Integer;
        TokenKey: Text;

        ETagLoginAPIAddress: Text[100];
        ETagLoginID: Text;
        ETagPassword: Text;
    begin
        // Login
        ClearObjects();
        CheckSetup();

        ETagLoginAPIAddress := EPaperIntegrationSetup."Login API URL";
        ETagLoginID := EPaperIntegrationSetup."Login ID";
        ETagPassword := EPaperIntegrationSetup.Password;
        apiRequestQuery := '{"username": "' + ETagLoginID + '","password": "' + ETagPassword + '"}';
        // Message(apiRequestQuery);

        _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Request.Content := _httpContent;
        Request.SetRequestUri(ETagLoginAPIAddress);
        Request.Method := 'POST';
        if Not Client.Send(Request, Response) then
            ErrorCode := 999;

        If not Response.IsSuccessStatusCode() then begin
            if EPaperIntegrationSetup."Enable Logging" then begin
                InsertEventLogEntry(
                    EPaperAPIEventLog."Action Type"::LOGIN,
                    ETagLoginAPIAddress,
                    true,
                    '',
                    '',
                    0,
                    0,
                    EPaperAPIEventLog."Data Type"::" ",
                    'Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase())
                );
            end;

            Message('Web service returned error:\\' +
                'Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            // Message(ResponseText);

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    ErrorState := GetJsonValueAsBoolean(jsonObj, 'error');
                    ErrorCode := GetJsonValueAsInteger(jsonObj, 'errorCode');
                    TokenKey := GetJsonValueAsText(jsonObj, 'token');
                end;
            end;
        end;

        if EPaperIntegrationSetup."Enable Logging" then begin
            InsertEventLogEntry(
                EPaperAPIEventLog."Action Type"::LOGIN,
                ETagLoginAPIAddress,
                ErrorState,
                Format(ErrorCode),
                '',
                0,
                0,
                EPaperAPIEventLog."Data Type"::" ",
                ''
            );
        end;

        // Write TokenKey to database config
        EPaperIntegrationSetup.Token := TokenKey;
        EPaperIntegrationSetup.Modify();

        exit(TokenKey);

    end;

    procedure TurnOnETag(dataId: Text; colorId: Integer): Text
    var
        ETagAPIAddress: Text[100];
        ETagToken: Text;
        ETagDataId: Text; // Comma separated
        ETagColorId: Text; // 1-6 types of color
        ETagTimerInSeconds: Integer;
        ETagDataType: Text; // EAN - Item ID Based | SHELFID - Location Based | TAGID - Tag ID Based
        // ArrayOfDataIds: List of [Text];

        ErrorCustomCode: Text;
        ErrorState: Boolean;
        ErrorCode: Integer;
    begin
        // Turn on codes here
        ClearObjects();
        CheckSetup();

        ETagAPIAddress := EPaperIntegrationSetup."Turn On LED API URL";
        ETagToken := EPaperIntegrationSetup.Token;
        ETagDataId := dataId;
        // ETagColorId := Format(TranslateColourOptionValue(colorId));
        ETagColorId := Format(colorId);
        ETagTimerInSeconds := EPaperIntegrationSetup."Turn On LED Timer in Seconds";
        ETagDataType := Format(EPaperIntegrationSetup."Default Tag Type");

        apiRequestQuery := '{"token":"' + ETagToken + '",';
        apiRequestQuery += '"dataid":"' + ETagDataId + '",';
        apiRequestQuery += '"colourid":"' + ETagColorId + '",';
        apiRequestQuery += '"timer":"' + Format(ETagTimerInSeconds) + '",';
        apiRequestQuery += '"datatype":"' + ETagDataType + '"}';

        _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Request.Content := _httpContent;
        Request.SetRequestUri(ETagAPIAddress);
        Request.Method := 'POST';
        if Not Client.Send(Request, Response) then
            ErrorCode := 999;

        If not Response.IsSuccessStatusCode() then begin
            if EPaperIntegrationSetup."Enable Logging" then begin
                InsertEventLogEntry(
                    EPaperAPIEventLog."Action Type"::TURNON,
                    ETagAPIAddress,
                    true,
                    '',
                    ETagDataId,
                    colorId,
                    ETagTimerInSeconds,
                    EPaperIntegrationSetup."Default Tag Type",
                    'Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase())
                );
            end;
            if UserId = 'BCADMIN' then
                Message('Web service returned error:\\' +
                    'Status code: %1\' +
                    'Description: %2',
                    Response.HttpStatusCode(),
                    Response.ReasonPhrase());
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    ErrorState := GetJsonValueAsBoolean(jsonObj, 'error');
                    ErrorCode := GetJsonValueAsInteger(jsonObj, 'errorCode');
                end;
            end;
        end;

        // Process Error Code
        ErrorCustomCode := 'OK';
        if ErrorCode = 901 then
            ErrorCustomCode := 'DATA_ERR';
        if ErrorCode = 912 then
            ErrorCustomCode := 'EQ_ERR';
        if ErrorCode = 903 then
            ErrorCustomCode := 'AUTH_ERR';
        if ErrorCode = 999 then
            ErrorCustomCode := 'CONN_ERR';
        if ErrorCode = 0 then
            ErrorCustomCode := 'OK';

        if EPaperIntegrationSetup."Enable Logging" then begin
            InsertEventLogEntry(
                EPaperAPIEventLog."Action Type"::TURNON,
                ETagAPIAddress,
                ErrorState,
                Format(ErrorCode),
                ETagDataId,
                colorId,
                ETagTimerInSeconds,
                EPaperIntegrationSetup."Default Tag Type",
                ErrorCustomCode
            );
        end;

        exit(ErrorCustomCode);

    end;

    procedure TurnOffETag(dataId: Text; colorId: Integer): Text
    var
        ETagAPIAddress: Text[100];
        ETagToken: Text;
        ETagDataId: Text; // Comma separated Item Ids
        ETagColorId: Text; // 0 - Turn off all | 1-6 types of colors
        ETagDataType: Text; // EAN - Item ID Based | SHELFID - Location Based | TAGID - Tag ID Based
        // ArrayOfDataIds: List of [Text];

        ErrorCustomCode: Text;
        ErrorState: Boolean;
        ErrorCode: Integer;
    begin
        // Turn on codes here
        ClearObjects();
        CheckSetup();

        ETagAPIAddress := EPaperIntegrationSetup."Turn Off LED API URL";
        ETagToken := EPaperIntegrationSetup.Token;
        ETagDataId := dataId;
        // ETagColorId := Format(TranslateColourOptionValue(colorId));
        ETagColorId := Format(colorId);
        ETagDataType := Format(EPaperIntegrationSetup."Default Tag Type");

        apiRequestQuery := '{"token":"' + ETagToken + '",';
        apiRequestQuery += '"itemid":"' + ETagDataId + '",';
        apiRequestQuery += '"colourid":"' + ETagColorId + '",';
        apiRequestQuery += '"datatype":"' + ETagDataType + '"}';

        // Message('API Debug ' + apiRequestQuery); // debug

        _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Request.Content := _httpContent;
        Request.SetRequestUri(ETagAPIAddress);
        Request.Method := 'POST';
        if Not Client.Send(Request, Response) then
            ErrorCode := 999;

        If not Response.IsSuccessStatusCode() then begin
            if EPaperIntegrationSetup."Enable Logging" then begin
                InsertEventLogEntry(
                    EPaperAPIEventLog."Action Type"::TURNOFF,
                    ETagAPIAddress,
                    true,
                    '',
                    ETagDataId,
                    colorId,
                    0,
                    EPaperIntegrationSetup."Default Tag Type",
                    'Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase())
                );
            end;
            if UserId = 'BCADMIN' then
                Message('Web service returned error:\\' +
                    'Status code: %1\' +
                    'Description: %2',
                    Response.HttpStatusCode(),
                    Response.ReasonPhrase());

            ErrorCode := 999;
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            // Message('API Debug ' + ResponseText); // debug

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    ErrorState := GetJsonValueAsBoolean(jsonObj, 'error');
                    ErrorCode := GetJsonValueAsInteger(jsonObj, 'errorCode');
                end;
            end;
        end;

        // Process Error Code
        ErrorCustomCode := 'OK';
        if ErrorCode = 901 then
            ErrorCustomCode := 'DATA_ERR';
        if ErrorCode = 910 then
            ErrorCustomCode := 'EQ_ERR';
        if ErrorCode = 908 then
            ErrorCustomCode := 'EQ_ERR';
        if ErrorCode = 909 then
            ErrorCustomCode := 'EQ_ERR';
        if ErrorCode = 903 then
            ErrorCustomCode := 'AUTH_ERR';
        if ErrorCode = 999 then
            ErrorCustomCode := 'CONN_ERR';
        if ErrorCode = 0 then
            ErrorCustomCode := 'OK';

        if EPaperIntegrationSetup."Enable Logging" then begin
            InsertEventLogEntry(
                EPaperAPIEventLog."Action Type"::TURNOFF,
                ETagAPIAddress,
                ErrorState,
                Format(ErrorCode),
                ETagDataId,
                colorId,
                0,
                EPaperIntegrationSetup."Default Tag Type",
                ErrorCustomCode
            );
        end;

        exit(ErrorCustomCode);
    end;

    procedure ClearObjects()
    begin
        Clear(Client);
        Clear(Response);
        Clear(json);
        Clear(jsonObj);
        Clear(contentHeaders);
        Clear(Request);
        Clear(ResponseText);
        Clear(_jsonToken);
    end;

    procedure ProcessSwitchOnETag(dataId: Text; colorId: Integer)
    var
        resultCode: Text;
    begin
        // Process Switch On ETag with Login Error Handling - 1 retry only
        ClearObjects();
        CheckSetup();

        resultCode := TurnOnETag(dataId, colorId);

        if resultCode = 'AUTHERR' then begin
            // retry after re-login
            Login();
            resultCode := TurnOnETag(dataId, colorId);
        end;

        if resultCode <> 'OK' then
            if UserId = 'BCADMIN' then
                Message('Turn On API call failed with code ' + resultCode);
    end;

    procedure ProcessSwitchOffETag(dataId: Text; colorId: Integer)
    var
        resultCode: Text;
    begin
        // Process Switch Off ETag with Login Error Handling - 1 retry only
        ClearObjects();
        CheckSetup();

        resultCode := TurnOffETag(dataId, colorId);

        if resultCode = 'AUTHERR' then begin
            // retry after re-login
            Login();
            resultCode := TurnOffETag(dataId, colorId);
        end;

        if resultCode <> 'OK' then
            if UserId = 'BCADMIN' then
                Message('Turn Off API call failed with code ' + resultCode);
    end;


    // GetJsonValue is use to get the value format and helpful to convert in any data type 
    procedure GetJsonValue(var json_Object: JsonObject; Property: Text; var json_Value: JsonValue): Boolean
    var
        json_Token: JsonToken;
    begin
        if not json_Object.Get(Property, json_Token) then
            exit;
        json_Value := json_Token.AsValue();
        exit(true);
    end;


    // Work for Text Response
    procedure GetJsonValueAsText(var json_Object: JsonObject; Property: Text) Value: Text
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsText;
    end;

    procedure GetJsonValueAsBoolean(var json_Object: JsonObject; Property: Text) Value: Boolean
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsBoolean();
    end;

    procedure GetJsonValueAsInteger(var json_Object: JsonObject; Property: Text) Value: Integer
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsInteger();
    end;

    procedure GetJsonValueAsDecimal(var json_Object: JsonObject; Property: Text) Value: Decimal
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsDecimal();
    end;

    procedure GetJsonToken(json_Object: JsonObject; tokenKey: Text) json_Token: JsonToken;
    begin
        if not json_Object.Get(tokenKey, json_Token) then
            Error('Token not found with key %1', tokenKey);
    end;

    procedure TranslateColourOptionValue(ColourOption: Option " ",Red,Green,Blue,Yellow,Magenta,Cyan): Integer
    begin
        if ColourOption = ColourOption::" " then
            exit(0);
        if ColourOption = ColourOption::Red then
            exit(1);
        if ColourOption = ColourOption::Green then
            exit(2);
        if ColourOption = ColourOption::Blue then
            exit(3);
        if ColourOption = ColourOption::Yellow then
            exit(4);
        if ColourOption = ColourOption::Magenta then
            exit(5);
        if ColourOption = ColourOption::Cyan then
            exit(6);
    end;

    local procedure InsertEventLogEntry(
        ActionType: Option " ",LOGIN,TURNON,TURNOFF;
        APIURL: Text[150];
        ErrorFlag: Boolean;
        ErrorCode: Text[10];
        DataID: Text[500];
        ColourID: Integer;
        TimerInSecond: Integer;
        DataType: Option " ",EAN,SHELFID,TAGID;
        Comments: Text[250]
        )
    var
        EventLogRec: Record "EPaper API Event Log";
    begin
        EventLogRec.Init();
        EventLogRec."Action Type" := ActionType;
        EventLogRec."API URL" := APIURL;
        EventLogRec.Error := ErrorFlag;
        EventLogRec."Error Code" := ErrorCode;
        EventLogRec."Event Date Time" := CurrentDateTime;
        EventLogRec."Data ID" := DataID;
        EventLogRec."Colour ID" := ColourID;
        EventLogRec."Timer in Seconds" := TimerInSecond;
        EventLogRec."Data Type" := DataType;
        EventLogRec.Comments := Comments;
        EventLogRec.UserId := UserId;
        EventLogRec.Insert();
    end;

    procedure DeleteAllEventLogEntries(SilentRun: Boolean)
    var
        EventLogRec: Record "EPaper API Event Log";
    begin
        if SilentRun then begin
            EventLogRec.Reset();
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not EventLogRec.IsEmpty then
                EventLogRec.DeleteAll();
            // YF 10 Aug 2022 // To avoid unnecessary table lock
        end
        else begin
            if Confirm('Delete all EPaper Integration Event Log Entries?', false) then begin
                EventLogRec.Reset();
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not EventLogRec.IsEmpty then
                    EventLogRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                Message('EPaper Integration Event Log Entries Deleted');
            end;
        end;
    end;

    var

        Client: HttpClient;
        Response: HttpResponseMessage;
        json: Text;
        jsonObj: JsonObject;
        _jsonToken: JsonToken;
        _httpContent: HttpContent;
        apiRequestQuery: Text;
        contentHeaders: HttpHeaders;
        Request: HttpRequestMessage;
        ResponseText: Text;
        ETagLoginToken: Text;
        EPaperIntegrationSetup: Record "EPaper Integration Setup";
        EPaperAPIEventLog: Record "EPaper API Event Log";

}