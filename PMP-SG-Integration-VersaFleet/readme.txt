	https://versafleet.docs.apiary.io/#reference/0/customer-api/archive-a-customer?console=1
	https://tabrezblog.azurewebsites.net/post/2021/03/10/how-to-consume-rest-api-url-in-microsoft-d365-business-central-example-getting-data-from-jsonplaceholder-api
	https://community.dynamics.com/business/f/dynamics-365-business-central-forum/307894/how-to-consume-rest-api-url-in-microsoft-d365-business-central
	https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/httpcontent/httpcontent-data-type
	https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/httpclient/httpclient-data-type
	https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/httpclient/httpclient-post-method
	https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/httpclient/httpclient-send-method
	
	
	
	User trigger delivery from action via Posted Sales Invoice. 
	This in turn slot an entry to a staging table.
	A Job Queue runs every 15 mins to process the staging table to send delivery entries to Versafleet 
	This will change order status of Posted Sales Invoice from Pending delivery to delivery in progress, current done when print delivery listing
	Do not process Posted Sales invoice that have blank "Order no." field 

	Reference:
		https://versafleet.docs.apiary.io/#reference/0/jobs-api/list-all-jobs	
		•	VersaFleet Login as a planner: 
		o	URL: https://go.versafleet.co/ (Recommended to use Google Chrome)
		o	Username: richmondlim@9itgroup.com
		o	Password: POMtest2021!
		•	Driver & Vehicle
		o	We have created 1 Driver (Driver ABC) and 1 Vehicle (Vehicle 123) in the test account
		o	For the driver, you may install 'VersaDrive' on your phone and log in using pomdriverabc as both the username and password.
		•	API keys for integration:
		o	client_id: 2527637596eab186c90874aedbc6410fca286d550efadb9ab60eac6531b453aa
		o	client_secret: 3ad300ec730716a3a5d8061209542fe21535efac45c67d50a9a7195dbf470075
		o	Note: the endpoints will be different for the production account.

	Requirements:
		[ Actionable]
		a. Create a New Job (for creating the 'pickup' and there should only be 2 jobs per day) - Morning/Evening shift based on time - ask Rich 
		b. Add a New Task to a Job (for creating each SI / Tracking ID as tasks in VF, items can be added at this point)
		c. Webhooks( update BC order status) - to be done via Middleware (Remind Rich to coordinate with Kel)
		
		* for (b) Tracking ID - Use checkingid - system assignment list via pick - ask Rich
		
		[ Fug it not doing bucket ]
		d. Add/Update/Delete Item Details in a Task (for creating additional items to the task)
		e. View Task Completion Histories of a Task for pulling out the 'line item validation for the actual quantity of items delivered by the driver)
			