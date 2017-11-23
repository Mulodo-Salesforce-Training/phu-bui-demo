public class test {
    public String name = 'Here is string';
	
    public static void runTest()
    {
        Account[] acctsWithContacts = [ SELECT Name, (SELECT FirstName,LastName FROM Contacts)
                               			FROM Account];
        // Get child records
        Contact[] cts = acctsWithContacts[0].Contacts;
        SYSTEM.debug(acctsWithContacts);
        SYSTEM.debug(cts);
        System.debug('Name of first associated contact: ' 
                     + cts[0].FirstName + ', ' + cts[0].LastName);
        
    }
}