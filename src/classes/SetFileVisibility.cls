public class SetFileVisibility  {

	 public static void CondivisioneFile(list<ContentDocumentLink> listNew){
        for (ContentDocumentLink cdl : listNew){
        cdl.visibility = 'AllUsers';
    	}        
     }

}