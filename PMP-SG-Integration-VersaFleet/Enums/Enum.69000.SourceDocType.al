enum 69000 "Source Document Type"
{
    Caption = 'Source Document Type';
    Extensible = true;
    AssignmentCompatibility = true;

    value(3; " ") { Caption = ' '; }
    value(0; "Posted Sales Invoice") { Caption = 'Posted Sales Invoice'; }
    value(1; "TBA Ledger") { Caption = 'TBA Ledger'; }
    value(2; "Misc. Delivery Charge") { Caption = 'Misc. Delivery Charge'; }
    value(4; "Transfer Shipment") { Caption = 'Transfer Shipment'; }
    value(5; "Sales Return Order") { Caption = 'Sales Return Order'; }
}