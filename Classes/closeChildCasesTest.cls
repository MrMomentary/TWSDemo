public class closeChildCasesTest {
  static testMethod void testCloseChildCases() {
  	//create a case
  	Case parentCase = new Case();
  	parentCase.Subject = 'Parent Case';
  	parentCase.Status = 'New';
  	insert parentCase; 
  	Case pCase = [select id, Status from Case where id = :parentCase.Id];
  	System.assertEquals('New',pCase.Status);
  	//create a child case
  	Case childCase = new Case();
  	childCase.Subject = 'Child Case';
  	childCase.ParentId = parentCase.Id;
  	insert childCase;
  	Case cCase = [select id, Status from Case where id = :childCase.Id];
  	System.assertEquals('New',cCase.Status);
  	//close the original case
  	parentCase.Status = 'Closed';
  	update parentCase;
  	//assert that the child case is closed
  	Case ccCase = [select id, Status from Case where id = :childCase.Id];
  	System.assertEquals('Closed',ccCase.Status);
  }
}