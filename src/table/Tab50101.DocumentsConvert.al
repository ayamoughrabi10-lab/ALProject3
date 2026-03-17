table 50101 "Documents Convert"
{
    Caption = 'Documents Convert';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
            Editable = false;
        }

        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Sales,Purchase;
            OptionCaption = 'Sales,Purchase';
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Order,Invoice,"Credit Memo","Return Order";
            OptionCaption = 'Order,Invoice,Credit Memo,Return Order';
        }



        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }

        field(6; "Converted No."; Code[20])
        {
            Caption = 'Converted No.';
        }

        field(7; "Converted Type"; Option)
        {
            Caption = 'Converted Type';
            OptionMembers = ,Sales,Purchase;
            OptionCaption = ',Sales,Purchase';
        }

        field(8; "Converted Doc. Type"; Option)
        {
            Caption = 'Converted Doc. Type';
            OptionMembers = ,Order,Invoice,"Credit Memo","Return Order";
            OptionCaption = ',Order,Invoice,Credit Memo,Return Order';
        }

        field(9; "Converted Source No."; Code[20])
        {
            Caption = 'Converted Source No.';
        }

        field(10; Processed; Boolean)
        {
            Caption = 'Processed';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeriesMgt: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Entry No." = '' then
            "Entry No." := NoSeriesMgt.GetNextNo('DOC-CONVERT', WorkDate(), true);
    end;
}