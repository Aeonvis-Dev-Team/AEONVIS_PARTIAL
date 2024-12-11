global class SchedulableBatchSincroStatiInvoice implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
		BatchSincroStatiInvoice b = new BatchSincroStatiInvoice(); // Your batch class
		database.executeBatch(b, 1);
	}
}