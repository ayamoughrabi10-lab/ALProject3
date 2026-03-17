table 50110 "Item Summary"
{
    DataClassification = CustomerContent;
    Caption = 'Item Summary';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "Entry Date"; Date)
        {
            DataClassification = SystemMetadata;
        }

        field(3; "User ID"; Code[50])
        {
            DataClassification = SystemMetadata;
        }

        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;

            TableRelation = Item."No.";

            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get("Item No.") then begin
                    Description := ItemRec.Description;
                    "Unit of Measure" := ItemRec."Base Unit of Measure";
                end else begin
                    Clear(Description);
                    Clear("Unit of Measure");
                end;
            end;
        }



        field(5; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(6; "Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        field(7; Barcode; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "LSC Barcodes" where("Item No." = field("Item No."));
        }

        field(8; "Item Inventory"; Decimal)
        {
            Caption = 'Item Inventory';
            FieldClass = FlowField;
            Editable = false;

            CalcFormula =
                Sum("Item Ledger Entry".Quantity
                    where("Item No." = field("Item No.")));
        }


        field(9; "Item Cost"; Decimal)
        {
            Caption = 'Item Cost';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Entry No.", "Entry Date")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        // Automatically fill system fields
        if "Entry Date" = 0D then
            "Entry Date" := Today;

        if "User ID" = '' then
            "User ID" := UserId;

    end;

}
