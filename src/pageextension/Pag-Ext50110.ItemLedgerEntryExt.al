namespace ALProject.ALProject;

using Microsoft.Inventory.Ledger;

pageextension 50110 ItemLedgerEntryExt extends "Item Ledger Entries"
{
    layout
    {
        addbefore("Entry Type")
        {
            field(Processed; Rec.Processed)
            {
                ApplicationArea = all;
            }
        }
    }

}
