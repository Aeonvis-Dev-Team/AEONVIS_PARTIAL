public class SetFileVisibilityTriggerSupport  {

	//gestione ripetizione trigger
    public static Boolean disableSetFileVisibilityTrigger=false;

    //gestione delle azioni del trigger
    public static void SetFileVisibilityTriggerHandler(Map<Id, ContentDocumentLink> oldMap,Map<Id, ContentDocumentLink> newMap,List<ContentDocumentLink> listNew,
         Boolean boolIsBefore,Boolean boolIsInsert,Boolean boolIsUpdate,Boolean boolIsDelete) {

        if(oldMap == NULL){
			oldMap = new Map<Id, ContentDocumentLink>();
		}
        if(newMap == NULL){
			newMap = new Map<Id, ContentDocumentLink>();
		}
        if(listNew == NULL){listNew = new List<ContentDocumentLink>();
		}

        if(boolIsBefore) {
            if(boolIsInsert) {SetFileVisibility.CondivisioneFile(listNew);}
            //if(boolIsUpdate) {}
            //if(boolIsDelete) {}
        } else { //i.e. trigger.isAfter
            //if(boolIsInsert) {}
            //if(boolIsUpdate) {}
            //if(boolIsDelete) {}
        }

	}
}