page 50195 "Halal Certificate"
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Halal Certificate";

    layout
    {
        area(Content)
        {
            group(Halal)
            {
                Caption = 'Halal Certificate Information';
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Halal Certificate Name';
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    ApplicationArea = All;
                    Caption = 'Country of Origin';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Authorized Cert Body"; Rec."Authorized Cert Body")
                {
                    ApplicationArea = All;
                    Caption = 'Authorized Certification Body';
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = All;
                    Caption = 'Expired';
                }
                // RL20200804 - Start
                field("PSS/PL"; Rec."PSS/PL")
                {
                    ApplicationArea = All;

                }
                // RL20200804 - End
                field("Halal Certificate Logo"; Rec."Halal Certificate Logo")
                {
                    ApplicationArea = All;
                    Caption = 'Halal Certificate Logo';
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
            }
            part(HalalCertLine; "Halal Certificate Subform")
            {
                Caption = 'Halal Certificate Line';
                ApplicationArea = Basic, Suite;
                Editable = Rec.Name <> '';
                Enabled = Rec.Name <> '';
                SubPageLink = "Halal Certificate Name" = field(Name);
                UpdatePropagation = Both;


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateItem)
            {
                Caption = 'Update Halal Cert for Item';
                Image = UpdateDescription;

                trigger OnAction()
                var
                    lrec_Item: Record Item;
                    lrec_HalalCertLine: Record "Halal Certificate Line";
                begin
                    lrec_HalalCertLine.Reset();
                    lrec_HalalCertLine.SetRange("Halal Certificate Name", Rec.Name);
                    if lrec_HalalCertLine.FindSet() then
                        repeat
                            lrec_Item.Reset();
                            lrec_Item.SetRange("No.", lrec_HalalCertLine."Item No.");
                            if lrec_Item.FindFirst() then begin
                                lrec_Item.Halal := true;
                                lrec_Item.Validate("Halal Certification", lrec_HalalCertLine."Halal Certificate Name");
                                lrec_Item."Description 2" := lrec_HalalCertLine."Item Description 2"; //KM20200309 - To Update Description 2
                                lrec_Item.Modify();
                            end;
                        until lrec_HalalCertLine.Next() = 0;
                end;
            }
        }
    }

    var

}