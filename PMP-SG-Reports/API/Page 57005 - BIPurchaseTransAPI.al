page 57005 BIPurchaseTransAPI
{

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BIPurchaseTransAPI';
    DelayedInsert = true;
    EntityName = 'BIPurchaseTransAPI';
    EntitySetName = 'BIPurchaseTransAPI';
    PageType = API;
    SourceTable = "Item Ledger Entry";
    layout
    {
        area(content)
        {
            repeater(General)
            {
            }
        }
    }

}
