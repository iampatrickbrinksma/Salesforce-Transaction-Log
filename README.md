# Salesforce Transaction Log

Ever wondered what the exact order of changes are and what values are set for all the fields during a transaction, especially when it involves multiple objects, and there is a mix of synchronous and asynchronous transactions? The Salesforce Transaction Log provides insight into the transaction timeline and what field values are being set. I initially developed this to help me understand the Salesforce Field Service transactions, but it can be used for any object and any Salesforce application.

## Disclaimer
IMPORTANT: This code is not intended to be deployed to a Salesforce production environment, but to be used for debugging purposes to understand transactions or debug issues. This is not a Salesforce product and is not officially supported by Salesforce.

## Prerequisites
* Salesforce Org
* Salesforce Field Service - optional (if you want to use the Apex Triggers which are part of this repository)

## Deployment

Deploy the metadata in this repository to your Salesforce org. It's not required to deploy the Apex Triggers that are part of this repository, they are included to cover the typical Field Service objects.

## How To Use
Assign the permission set "Field Service Transaction Log Permissions" to the user(s) that will need access to view the transaction logs.

For the objects you want to log the transactions for, create an Apex Trigger as shown below:
```
trigger <Trigger Name> on <SObject API Name> (before insert, before update, before delete, after insert, after update, after delete) {
  new fieldServiceTransactionLog('<Trigger Name>').run();
}
```
So for example for the ServiceAppointment SObject it would look like:
```
trigger ServiceAppointmentLog on ServiceAppointment (before insert, before update, before delete, after insert, after update, after delete) {
    new fieldServiceTransactionLog('ServiceAppointmentLog').run();
}
```
If you have a Trigger Framework implemented, you can add the following line at the end of the single Apex Trigger you have on the object:
```
  new fieldServiceTransactionLog(<Trigger Name>).run();
```

To enable logging, make sure the "Log Transactions" checkbox field is checked in the Custom Setting "Field Service Transaction Log Settings", and make sure the ```<Trigger Name>``` is included on of the Enable Trigger fields in the custom setting. Multiple triggers can be added as comma separated value as shown in the screenshot below:

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/e95834a0-8b5e-4e01-a4f2-723b4cf0a375)

As the Custom Setting is Hierarchical, you can use different configurations per profile / user.

To view the transactions logs, open the Tab "Field Service Transaction Logs". Each record is an Apex Trigger event with the event details captured, and the individual field values which are set are stored in the "Field Service Transaction Field Changes" related list. See screenshots below:

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/a9a431cb-c1c3-4364-b6d4-6e1f78adeb02)

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/3aa12f83-1d8c-4179-bb40-876f6757c32a)


