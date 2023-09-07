# Salesforce Transaction Log

Ever wondered what the exact order of changes are and what values are set for all the fields during a transaction, especially when it involves multiple objects, and there is a mix of synchronous and asynchronous transactions? The Salesforce Transaction Log provides insight into the transaction timeline and what field values are being set. I initially developed this to help me understand the Salesforce Field Service transactions, but it can be used for any object and any Salesforce application.

## Disclaimer
IMPORTANT: This code is not intended to be deployed to a Salesforce production environment, but to be used for debugging purposes to understand transactions or debug issues. This is not a Salesforce product and is not officially supported by Salesforce.

## Prerequisites
* Salesforce Org

## Deployment

Deploy the metadata in this repository to your Salesforce org

## How To Use
Assign the permission set "Field Service Transaction Log Permissions" to the user(s) that will need access to view the transaction logs.

For the objects you want to log the transactions for, create an Apex Trigger as shown below:
```
trigger <Trigger Name> on <SObject API Name> (before insert, before update, before delete, after insert, after update, after delete) {
  new fieldServiceTransactionLog().run();
}
```
So for example for the ServiceAppointment SObject it would look like:
```
trigger ServiceAppointmentLog on ServiceAppointment (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog().run();
}
```
To enable logging, make sure the "Log Transactions" checkbox field is checked in the Custom Setting "Field Service Transaction Log Settings"

To view the transactions logs, open the Tab "Field Service Transaction Logs". Each record is an Apex Trigger event with the event details captured, and the individual field values which are set are stored in the "Field Service Transaction Field Changes" related list.
