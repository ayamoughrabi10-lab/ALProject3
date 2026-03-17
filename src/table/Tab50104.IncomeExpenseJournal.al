// table 50104 "Income/Expense Journal"
// {
//     Caption = 'Income/Expense Journal';
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Line No."; Integer)
//         {
//             Caption = 'Line No.';
//         }
//         field(2; "Posting Date"; Date)
//         {
//             Caption = 'Posting Date';
//         }
//         field(3; "Document No."; Integer)
//         {
//             Caption = 'Document No.';
//         }
//         // 4- Account Type (Option(Customer-Vendor-Bank Account))
//         field(4; "Account Type"; Option)
//         {
//             Caption = 'Account Type';
//             OptionMembers = Customer,Vendor,"Bank Account";
//             OptionCaption = 'Customer,Vendor,Bank Account';

//             trigger OnValidate()
//             begin
//                 if "Account Type" <> xRec."Account Type" then
//                     "Account No." := '';
//             end;
//         }

//         // 5- Account No. (Code(20))
//         field(5; "Account No."; Code[20])
//         {
//             Caption = 'Account No.';
//             TableRelation = if ("Account Type" = const(Customer)) Customer
//             else if ("Account Type" = const(Vendor)) Vendor
//             else if ("Account Type" = const("Bank Account")) "Bank Account";
//         }
//         field(6; "Currency Code"; Code[10])
//         {
//             Caption = 'Currency Code';
//         }
//         field(7; Amount; Decimal)
//         {
//             Caption = 'Amount';
//         }
//         field(8; "Amount(LCY)"; Decimal)
//         {
//             Caption = 'Amount(LCY)';
//         }
//         field(9; "Bal. Account Type"; Option)
//         {
//             Caption = 'Bal. Account Type';
//             OptionMembers = "GL Account","Bank Account";
//             OptionCaption = 'GL Account, Bank Account';
//         }
//         field(10; "Bal. Account No."; Code[20])
//         {
//             Caption = 'Bal. Account No.';
//         }
//         field(11; "Bal. Currency Code"; Code[10])
//         {
//             Caption = 'Bal. Currency Code';
//         }
//         field(12; "Bal. Amount "; Decimal)
//         {
//             Caption = 'Bal. Amount ';
//         }
//         field(13; "Journal Type"; Option)
//         {
//             Caption = 'Journal Type';
//             OptionMembers = Receipt,Payment;
//             OptionCaption = 'Receipt, Payment';
//         }
//     }
//     keys
//     {
//         key(PK; "Line No.")
//         {
//             Clustered = true;
//         }
//     }
// }



table 50104 "Income/Expense Journal"
{
    DataClassification = CustomerContent;
    Caption = 'Income/Expense Journal';

    fields
    {
        // 1- Line No. (Integer) - Primary Key
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        // 2- Posting Date (Date)
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        // 3- Document No.
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        // 4- Account Type (Option(Customer-Vendor-Bank Account))
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionMembers = Customer,Vendor,"Bank Account";
            OptionCaption = 'Customer,Vendor,Bank Account';

            trigger OnValidate()
            begin
                if "Account Type" <> xRec."Account Type" then
                    "Account No." := '';
            end;
        }

        // 5- Account No. (Code(20))
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const(Customer)) Customer
            else if ("Account Type" = const(Vendor)) Vendor
            else if ("Account Type" = const("Bank Account")) "Bank Account";
        }

        // 6- Currency Code (Code(10))
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }

        field(7; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }

        // 8- Amount (decimal)
        field(8; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
        }

        // 9- Bal. Account Type
        field(9; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
        }

        // 10- Bal. Account No.
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else if ("Bal. Account Type" = const(Customer)) Customer
            else if ("Bal. Account Type" = const(Vendor)) Vendor
            else if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
        }

        // 11- Bal. Currency Code
        field(11; "Bal. Currency Code"; Code[10])
        {
            Caption = 'Bal. Currency Code';
            TableRelation = Currency;
        }

        // 12- Bal. Amount (decimal)
        field(12; "Bal. Amount"; Decimal)
        {
            Caption = 'Bal. Amount';
        }

        // 13- Journal Type (Option(Receipt/Payment))
        field(13; "Journal Type"; Option)
        {
            Caption = 'Journal Type';
            OptionMembers = Receipt,Payment;
            OptionCaption = 'Receipt,Payment';
        }
    }

    keys
    {
        // Primary Key is Line No. as per your requirement
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}