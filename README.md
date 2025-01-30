# Salesforce Transaction Log

Ever wondered what the exact order of changes are and what values are set for all the fields during a transaction, especially when it involves multiple objects, and there is a mix of synchronous and asynchronous transactions? The Salesforce Transaction Log provides insight into the transaction timeline and what field values are being set. I initially developed this to help me understand the Salesforce Field Service transactions, but it can be used for any object and any Salesforce application.

## Disclaimer

**Please do not log a support case with Salesforce support. If you encounter an issue or have a question, create a new issue in this repository!**

This repository contains code intended to help Salesforce Field Service customers and partners accelerate their implementations. Please note the following:
* This code is not an official Salesforce product.
* It is not officially supported by Salesforce.
* The code serves as an example of how to implement specific functionality or make use of certain features.

Before using this code in a production environment, it is crucial that you:
* Adopt the code to fit your specific needs.
* Test thoroughly to ensure it works as expected in your environment.
* Consider the code to be your own and take full responsibility for its use.

By using this code, you acknowledge that Salesforce is not liable for any issues that may arise from its use.

## Prerequisites
* Salesforce Org
* Salesforce Field Service - optional (if you want to use the Apex Triggers which are part of this repository)

## Deployment

Deploy the metadata in this repository to your Salesforce org. It's not required to deploy the Apex Triggers that are part of this repository, they are included to cover the typical Field Service objects.

## How To Use
- Assign the permission set "Field Service Transaction Log Permissions" to the user(s) that will need access to view the transaction logs.
- For the objects you want to log the transactions for, create an Apex Trigger as shown below:

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

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/762855ac-65fe-4e20-b98b-991c0903d578)

As the Custom Setting is Hierarchical, you can use different configurations per profile / user.

To view the transactions logs, open the Tab "Field Service Transaction Logs". Each record is an Apex Trigger event with the event details captured, and the individual field values which are set are stored in the "Field Service Transaction Field Changes" related list. See screenshots below:

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/b3705379-0d36-4499-a1ff-c1af919dbdda)

- Note: When records are inserted, during the ```before insert``` event the record Id is not known yet. In those cases the Record Id field in the Transaction Log object is populated with ```New Record x```, where x is an incremental number.

![image](https://github.com/iampatrickbrinksma/SFS-Transaction-Log/assets/78381570/7ec39f89-9555-4f39-be76-9da5cceeb9e4)

