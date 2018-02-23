global class PushTopics() {

    PushTopic accountPT = new PushTopic();
    accountPT.Name = 'Account';
    accountPT.Query = 'SELECT Account_General_Email__c,Account_Logo_URL__c,Account_Operating_Status__c,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BRI_Contract_Status__c,BRI_New_Builder_Date__c,BRI_Sales_Market__c,BRI_Sales_Region__c,Builder_Type__c,Company_Table_Record_ID_Parent__c,Company_Table_Record_ID__c,Contract_Start_Date__c,Contract_Termination_Date__c,Current_Year_Estimated_Closings__c,Estimated_Manufacturer_Closing_Revenue__c,Fax,HomeSphere_Relationship__c,HomeSphere_Services__c,Housing_Product_Type__c,Id,Included_on_Brand_Usage__c,IsDeleted,LastModifiedById,Last_Closing_Submitted_Date__c,Name,One_and_Done_Account__c,OwnerId,ParentId,Phone,Product_Category__c,RecordTypeId,Reporting_Frequency__c,Unengaged_Builder_Status__c,Website, EnterpriseId__c, Account_Type__c From Account';
    accountPT.ApiVersion = 41.0;
    accountPT.NotifyForOperationCreate = true;
    accountPT.NotifyForOperationUpdate = true;
    accountPT.NotifyForOperationUndelete = true;
    accountPT.NotifyForOperationDelete = true;
    accountPT.NotifyForFields = 'Referenced';
    insert accountPT;

    PushTopic contactPT = new PushTopic();
    contactPT.Name = 'Contact';
    contactPT.Query = 'SELECT Account_Company_Table_Record_ID__c, AccountId,Check_Recipient__c, Communication_Method__c, Id, Contact_Status__c, Contact_Table_Record_ID__c, CreatedById, CreatedDate, Email, Name, LastModifiedById, MailingAddress, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, MobilePhone, Opt_Out_Email__c, OwnerId, Phone_Extension__c, Primary_Contact__c, Primary_Phone__c, RecordTypeId, Title, Product__c, Subscription_Level__c, EnterpriseId__c FROM Contact';
    contactPT.ApiVersion = 41.0;
    contactPT.NotifyForOperationCreate = true;
    contactPT.NotifyForOperationUpdate = true;
    contactPT.NotifyForOperationUndelete = true;
    contactPT.NotifyForOperationDelete = true;
    contactPT.NotifyForFields = 'Referenced';
    insert contactPT;

}