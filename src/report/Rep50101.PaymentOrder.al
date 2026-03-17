// namespace ALProject.ALProject;

// report 50101 "Payment Order"
// {
//     Caption = 'Payment Order';
//     dataset
//     {
//         dataitem(PaymentOrder; "Payment Order")
//         {
//             column(PaymentNo; "Payment No.")
//             {
//             }
//             column(PaymentType; "Payment Type")
//             {
//             }
//             column(AccountType; "Account Type")
//             {
//             }
//             column(AccountNo; "Account No.")
//             {
//             }
//             column(CurrencyCode; "Currency Code")
//             {
//             }
//             column(CurrencyFactor; "Currency Factor")
//             {
//             }
//             column(Amount; Amount)
//             {
//             }
//             column(AmountLCY; "Amount(LCY)")
//             {
//             }
//             column(PostingDate; "Posting Date")
//             {
//             }
//             column(LastDateModified; "Last Date Modified ")
//             {
//             }
//             column(CreatedBy; "Created By")
//             {
//             }
//             column(BalAccountType; "Bal. Account Type")
//             {
//             }
//             column(BalAccountNo; "Bal. Account No.")
//             {
//             }
//             column(BalCurrencyCode; "Bal. Currency Code")
//             {
//             }
//             column(BalAmount; "Bal. Amount")
//             {
//             }
//             column(BalAmountLCY; "Bal. Amount(LCY)")
//             {
//             }
//             column(Status; Status)
//             {
//             }
//         }
//     }
//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                 }
//             }
//         }
//         actions
//         {
//             area(Processing)
//             {
//             }
//         }
//     }
// }
namespace ALProject.ALProject;

report 50101 "Payment Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Payment Order';
    DefaultLayout = RDLC;
    RDLCLayout = './PaymentOrder.rdl';

    dataset
    {
        dataitem(PaymentOrder; "Payment Order")
        {
            // This allows the user to pick a specific Payment No. when running the report
            RequestFilterFields = "Payment No.";

            column(PaymentNo; "Payment No.") { }
            column(PaymentType; "Payment Type") { }
            column(AccountType; "Account Type") { }
            column(AccountNo; "Account No.") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount(LCY)") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(PostingDate; "Posting Date") { }
            column(Status; Status) { }
            column(CreatedBy; "Created By") { }

            // Helpful for the layout
            column(CompanyName; COMPANYPROPERTY.DisplayName()) { }
        }
    }
}