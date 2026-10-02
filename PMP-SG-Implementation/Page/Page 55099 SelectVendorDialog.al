page 55099 "Generic Input Dialog"
{
    PageType = StandardDialog;
    Caption = 'Input Dialog';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Input Dialog';
                ShowCaption = true;

                field(VendorCode; VendorCode)
                {
                    Caption = 'Vendor';
                    Description = 'Vendor';
                    ApplicationArea = All;
                    TableRelation = Vendor."No.";
                    Visible = VendorDisplay;
                }

                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    Description = 'Posting Date';
                    ApplicationArea = All;
                    Visible = PostingDateDisplay;
                }

            }
        }
    }

    var
        VendorCode: Code[20];
        VendorDisplay: Boolean;
        PostingDate: Date;
        PostingDateDisplay: Boolean;
        DefaultPostingDate: Date;


    trigger OnInit()
    begin
        VendorDisplay := false;
        PostingDateDisplay := false;
        DefaultPostingDate := 0D;
    end;

    procedure SetPostingDateVisible(ShowControl: Boolean)
    begin
        PostingDateDisplay := ShowControl;
    end;

    procedure SetDefaultPostingDate(DefaultDate: Date)
    begin
        PostingDate := DefaultDate;
        DefaultPostingDate := DefaultDate;
    end;

    procedure GetPostingDate(): Date
    begin
        if PostingDate <> 0D then
            exit(PostingDate)
        else
            exit(DefaultPostingDate);
    end;

    procedure SetVendorCodeVisible(ShowControl: Boolean)
    begin
        VendorDisplay := ShowControl;
    end;

    procedure GetVendorCode(): Code[20];
    begin
        exit(VendorCode);
    end;

}