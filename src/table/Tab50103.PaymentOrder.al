table 50103 "Payment Order"
{
    Caption = 'Payment Order';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payment No."; Code[10])
        {
            Caption = 'Payment No.';
        }
        field(2; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionMembers = Receipt,Payment;
            OptionCaption = 'Receipt,Payment';
        }

        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            // Strictly defining only these 3 options
            OptionMembers = Customer,Vendor,"Bank Account";
            OptionCaption = 'Customer,Vendor,Bank Account';

            trigger OnValidate()
            begin
                // Clear the Account No. if the Type changes to prevent data mismatch
                if "Account Type" <> xRec."Account Type" then
                    "Account No." := '';
            end;
        }

        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            // Relation depends on the Option index (0=Customer, 1=Vendor, 2=Bank Account)
            TableRelation = if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account";
        }
        field(5; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        // field(6; "Currency Factor"; Decimal)
        // {
        //     Caption = 'Currency Factor';
        // }
        // field(7; Amount; Decimal)
        // {
        //     Caption = 'Amount';
        // }

        field(6; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;

            trigger OnValidate()
            begin
                UpdateAmountLCY(); // Call the math procedure
            end;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                UpdateAmountLCY(); // Call the math procedure
            end;
        }
        field(8; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(10; "Last Date Modified "; Date)
        {
            Caption = 'Last Date Modified ';
        }
        field(11; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(12; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionMembers = "G/L Account","Bank Account";
            OptionCaption = 'G/L Account,Bank Account';

            trigger OnValidate()
            begin
                // If the type changes, clear the account number to prevent errors
                if "Bal. Account Type" <> xRec."Bal. Account Type" then
                    "Bal. Account No." := '';
            end;
        }

        // 13- Bal. Account No. (Code(20)) - Relation exists between bal. Account type and bal. Acc. No
        field(13; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            // Relation filtered to only G/L Account (Posting type) and Bank Account
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting), Blocked = const(false))
            else if ("Bal. Account Type" = const("Bank Account")) "Bank Account";

            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
                BankAcc: Record "Bank Account";
            begin
                if "Bal. Account No." = '' then
                    exit;

                // Simple logic to fetch details based on your specific requirements
                case "Bal. Account Type" of
                    "Bal. Account Type"::"G/L Account":
                        begin
                            GLAcc.Get("Bal. Account No.");
                            // You can add logic here to fetch Currency if needed
                        end;
                    "Bal. Account Type"::"Bank Account":
                        begin
                            BankAcc.Get("Bal. Account No.");
                            // 14- Bal. Currency Code: refers to the currency of bal. Account No.
                            "Bal. Currency Code" := BankAcc."Currency Code";
                        end;
                end;
            end;
        }
        field(14; "Bal. Currency Code"; Code[10])
        {
            Caption = 'Bal. Currency Code';
        }
        field(15; "Bal. Amount"; Decimal)
        {
            Caption = 'Bal. Amount';
        }
        field(16; "Bal. Amount(LCY)"; Decimal)
        {
            Caption = 'Bal. Amount(LCY)';
        }
        field(17; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Processing,"Waiting Approval",Approved,Rejected,Finalaized;
            OptionCaption = 'Processing, Waiting Approval, Approved, Rejected, Finalaized';
        }



    }
    keys
    {
        key(PK; "Payment No.")
        {
            Clustered = true;
        }
    }


    local procedure UpdateAmountLCY()
    begin
        // Logic: Amount (LCY) = Amount / Currency Factor
        // Example: 100 USD / 0.02 Factor = 5,000 LCY
        if "Currency Factor" <> 0 then
            "Amount(LCY)" := Amount / "Currency Factor"
        else
            "Amount(LCY)" := Amount; // If Factor is 0, we assume it is Local Currency
    end;
}
