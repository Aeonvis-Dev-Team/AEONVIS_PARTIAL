@isTest 
private class TestSetFileVisibility {

    testmethod static void CondivisioneFile()
    {
        Test.startTest();
        ImpTrigger__c setup = DataFactory.createCustomSettings();
		setup.SetFileVisibility__c=true;
		update setup;
        
        Account acc =new Account(Name='Test');
        insert acc ; 
 
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=acc.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        Test.stopTest();
	}
}