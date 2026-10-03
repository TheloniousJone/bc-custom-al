page 52105 "DKSH Stag. Incoming PR Subform"
{
    AutoSplitKey = true;
    Caption = 'DKSH Stag. Incoming PR Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "DKSH Staging Purch. Rcpt. Line";

    layout
    {
        area(content)
        {
            repeater(Details)
            {
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }

                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }

                field(lineItem_number; Rec.lineItem_number)
                {
                    ApplicationArea = All;
                }

                field(buyer_alternateItemId_type; Rec.buyer_alternateItemId_type)
                {
                    ApplicationArea = All;
                }

                field(buyer_alternateItemId_value; Rec.buyer_alternateItemId_value)
                {
                    ApplicationArea = All;
                }

                field(buyer_additionalItemId_type; Rec.buyer_additionalItemId_type)
                {
                    ApplicationArea = All;
                }

                field(buyer_additionalItemId_value; Rec.buyer_additionalItemId_value)
                {
                    ApplicationArea = All;
                }

                field(seller_additionalItemId_type; Rec.seller_additionalItemId_type)
                {
                    ApplicationArea = All;
                }

                field(seller_additionalItemId_value; Rec.seller_additionalItemId_value)
                {
                    ApplicationArea = All;
                }

                field(item_brandName; Rec.item_brandName)
                {
                    ApplicationArea = All;
                }

                field(item_modelNo; Rec.item_modelNo)
                {
                    ApplicationArea = All;
                }

                field(item_desc_language; Rec.item_desc_language)
                {
                    ApplicationArea = All;
                }

                field(item_desc_text; Rec.item_desc_text)
                {
                    ApplicationArea = All;
                }

                field(item_colorCodeListAgency; Rec.item_colorCodeListAgency)
                {
                    ApplicationArea = All;
                }

                field(item_colorCodeValue; Rec.item_colorCodeValue)
                {
                    ApplicationArea = All;
                }

                field(color_desc_language; Rec.color_desc_language)
                {
                    ApplicationArea = All;
                }

                field(color_desc_text; Rec.color_desc_text)
                {
                    ApplicationArea = All;
                }

                field(item_quantityOfNextLevel; Rec.item_quantityOfNextLevel)
                {
                    ApplicationArea = All;
                }

                field(item_sizeCodeListAgency; Rec.item_sizeCodeListAgency)
                {
                    ApplicationArea = All;
                }

                field(item_sizeCodeValue; Rec.item_sizeCodeValue)
                {
                    ApplicationArea = All;
                }

                field(size_desc_language; Rec.size_desc_language)
                {
                    ApplicationArea = All;
                }

                field(size_desc_text; Rec.size_desc_text)
                {
                    ApplicationArea = All;
                }

                field(item_invoicedQuantity; Rec.item_invoicedQuantity)
                {
                    ApplicationArea = All;
                }

                field(item_unitp_amount; Rec.item_unitp_amount)
                {
                    ApplicationArea = All;
                }

                field(item_unitp_currencyISOcode; Rec.item_unitp_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_netp_amount; Rec.item_netp_amount)
                {
                    ApplicationArea = All;
                }

                field(item_netp_currencyISOcode; Rec.item_netp_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_ttl_amount; Rec.item_ttl_amount)
                {
                    ApplicationArea = All;
                }

                field(item_ttl_currencyISOcode; Rec.item_ttl_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_uom; Rec.item_uom)
                {
                    ApplicationArea = All;
                }

                field(item_baseUnit; Rec.item_baseUnit)
                {
                    ApplicationArea = All;
                }

                field(item_focQuantity; Rec.item_focQuantity)
                {
                    ApplicationArea = All;
                }

                field(item_focbaseUnit; Rec.item_focbaseUnit)
                {
                    ApplicationArea = All;
                }

                field(item_focUom; Rec.item_focUom)
                {
                    ApplicationArea = All;
                }

                field(item_disca_amount; Rec.item_disca_amount)
                {
                    ApplicationArea = All;
                }

                field(item_disca_currencyISOcode; Rec.item_disca_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_discp_amount; Rec.item_discp_amount)
                {
                    ApplicationArea = All;
                }

                field(item_discp_currencyISOcode; Rec.item_discp_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_neta_amount; Rec.item_neta_amount)
                {
                    ApplicationArea = All;
                }

                field(item_neta_currencyISOcode; Rec.item_neta_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_itemRemarks; Rec.item_itemRemarks)
                {
                    ApplicationArea = All;
                }

                field(item_batchNumber; Rec.item_batchNumber)
                {
                    ApplicationArea = All;
                }

                field(item_expiry_referenceDateOnly; Rec.item_expiry_referenceDateOnly)
                {
                    ApplicationArea = All;
                }

                field(item_manu_referenceDateOnly; Rec.item_manu_referenceDateOnly)
                {
                    ApplicationArea = All;
                }

                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                }

                field("Date Modified"; Rec."Date Modified")
                {
                    ApplicationArea = All;
                }

                field("Is Rejected"; Rec."Is Rejected")
                {
                    ApplicationArea = All;
                }

                field("Has Error"; Rec."Has Error")
                {
                    ApplicationArea = All;
                }

                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }

                field("PO No. Updated"; Rec."PO No. Updated")
                {
                    ApplicationArea = All;
                }

                field("PO Line No. Updated"; Rec."PO Line No. Updated")
                {
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
