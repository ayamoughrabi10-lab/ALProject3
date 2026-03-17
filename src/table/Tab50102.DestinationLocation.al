table 50102 "Destination Location"
{
    Caption = 'Destination Location';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No';

        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
