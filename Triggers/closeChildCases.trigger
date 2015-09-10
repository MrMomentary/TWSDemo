/*    Author = Brad Herman
        Date = June 5, 2008
 Description = This trigger is active when a case is closed; it automatically closes all of the cases 
               that have the original case as a parent.  This is bulkified.
Dependencies = This trigger has no dependencies.
*/

trigger closeChildCases on Case (after update) {
  Case[] casesToUpdate = new Case[0];
  //select all cases
  Case[] cases = [select Id, Status, ParentId from Case];
  //loop through trigger
  for (Integer i=0;i<Trigger.size;i++) {
    //if there status is changing from anything else to closed
    if ((Trigger.old[i].Status != 'Closed') && (Trigger.new[i].Status == 'Closed')) {
      //loop through cases
      for (Integer j=0;j<cases.size();j++) {
        //check if a case has the trigger as a parent
        if (cases[j].ParentId == Trigger.new[i].Id) {
          //then close that case and add it to the list
          cases[j].Status = 'Closed';
          casesToUpdate.add(cases[j]);
        } //end if
      } //end for
    } //end if
  } //end for
  //update the list
  update casesToUpdate;
} //end trigger