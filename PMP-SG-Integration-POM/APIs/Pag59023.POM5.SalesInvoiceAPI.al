page 59023 "POM5 Sales Invoice API"
{
    PageType = API;
    APIPublisher = 'illum9';
    APIGroup = 'pom_integration';
    APIVersion = 'v2.0';

    EntityName = 'salesInvoice';
    EntitySetName = 'salesInvoices';

    SourceTable = "Sales Invoice Header";
    SourceTableView = where(
        "Your Reference" = filter('P5-*')
    );

    ODataKeyFields = SystemId;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                }
                field(number; Rec."No.")
                {
                }
                field(so_number; Rec."Order No.")
                {
                }
                field(status; Rec."Order Status")
                {
                }
                field(reference; Rec."Your Reference")
                {
                }
                field(post_date; Rec."Posting Date")
                {
                }
                field(exported; Rec."I9G Line Export")
                {
                }
                field(modified_at; Rec.SystemModifiedAt)
                {
                }
                part(lines; "POM5 Sales Invoice Line API")
                {
                    SubPageLink = "Document No." = Field("No."), Type = Filter('Item');
                }
            }
        }
    }

    [ServiceEnabled]
    procedure MarkExported(var actionContext: WebServiceActionContext)
    var
        CU: Codeunit POM5;
    begin
        CU.MarkExported(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}