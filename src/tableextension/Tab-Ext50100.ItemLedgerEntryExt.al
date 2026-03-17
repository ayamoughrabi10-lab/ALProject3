namespace ALProject.ALProject;

using Microsoft.Inventory.Ledger;

tableextension 50100 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        field(50100; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = ToBeClassified;
        }
    }
}
