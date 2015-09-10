public with sharing class RFP_AJAXInterface 
{
  private static ILanguageStemmingAlgorithm STEMMING_ALGORITHM = null;
  
  public class Response
  {
    public String Id {get; set;}
    public String Summary {get; set;}
    public Integer Hits;
    public String Status {get; set;}
  }
    
  public String SelectedRFP {get; set;}
  public String Question {get; set;}

  public class RFP_Document
  {
    public String Id {get; set;}
    public String Name {get; set;}
  }
  
  public RFP_AJAXInterface()
  {
    if (STEMMING_ALGORITHM == null)
    {
      STEMMING_ALGORITHM = new PorterStemmer();  
      STEMMING_ALGORITHM.initialize();      
    } // endif
  }
  
  public static Integer getStopWordCount() {
    Integer result = [SELECT COUNT() FROM Stop_Word__c r];
    return result;
  }
  
  public PageReference deleteStopWords() {
    batchDeleteStopWords();
    return null;
  }
  
  @future
  private static void batchDeleteStopWords() {
    Stop_Word__c[] stopWords = [SELECT r.Id from Stop_Word__c r LIMIT 150];
    for (Stop_Word__c sw: stopWords) {
        delete sw;
    }
  } 
      
  private static boolean isStopWord(String pWord)
  {
    String wordLC = pWord.toLowerCase();
    Integer result = [Select COUNT() From Stop_Word__c r where r.Name = :wordLC];
    boolean boolResult = result > 0;
    return boolResult;
  }
  
  public static string[] scrubAndStemQuestion(string pQuestion)
  {
    if (pQuestion != null)
    {
        pQuestion = pQuestion.trim();
    } // endif
    
    // Break question into words    
    String[] words = pQuestion.split('[\\W]+');
    
    // Eliminate any duplicate words
    for (Integer k = 0; k < words.size() - 1; k++)
    {
      for (Integer l = k + 1; l < words.size(); l++)
      {
        // Delete any duplicate keywords.
        if (words[l].equals(words[k]))
        {
            words[l] = '';
            break;
        }
      } // endfor
    } // endfor
        
    List<String> keywords = new List<String>();
        
    // For remaining words, eliminate stop words and stem.
    for (String word: words)
    {
      if ((word.length() > 0) && (!isStopWord(word)))
      {
        keywords.add(STEMMING_ALGORITHM.stem(word));
      } // endif
    } // endfor
        
    return keywords;
  }
    
  public Response[] getResponses()
  {
    PageReference pageRef = ApexPages.currentPage();
    Map<String, String> parameters = pageRef.getParameters();
    String pQuestion = parameters.get('question');
    String pSearchTarget = parameters.get('search');
    Response[] results = new Response[0];
    if (pQuestion != null)
    {
      pQuestion = pQuestion.trim();
    } // endif
    if ((pQuestion != null) && (pQuestion.length() > 0))
    {
      if ((pSearchTarget != null) && (pSearchTarget.equals('Questions')))
      {
        results = searchRFPForce(pQuestion, 'Question__c');
      }
      else
      {
        results = searchRFPForce(pQuestion, 'Response__c');
      } // endif
    } // endif
    return results;
  } 
  
  private Response[] searchRFPForce(String pQuestion, String pSearchObject)
  {
    List<Response> rankedResponses = new List<Response>();  
    String[] keywords = scrubAndStemQuestion(pQuestion);        
    Map<String, Response> foundResponses = new Map<String, Response>();
    
    String fields = null;
    if (pSearchObject.equals('Response__c'))
    {
      fields = 'Name, Response_Text__c, Status__c';
    }
    else if (pSearchObject.equals('Question__c'))
    {
      fields = 'Question__c, Response__c, Response_Status__c ';
    } // endif
    
    // Throw the spearQuery to capture the resonses that have 
    // ALL the keywords in them using an AND query.
    String spearQuery = constructQuery(pSearchObject, fields, keywords, 'AND');
    System.debug(spearQuery);
    List<List<SObject>>searchList = null;
    try
    {
      searchList = search.query(spearQuery);
    }
    catch (QueryException e)
    {
      // QueryExceptions are caused by query strings provided by the user that are
      // too short - like 'S*';
      // Just return an empty list.
      searchList = new List<List<SObject>>();
    } // endcatch
    if (searchList.size() > 0)
    {      
      sObject[] results = ((List<sObject>) searchList[0]);
      for (sObject s: results)
      {
        Response r = createSearchResponse(s, null);
        r.Hits = keywords.size();
        if (!foundResponses.containsKey(r.Id)) // Eliminate results that go to same Response article.
        {
          foundResponses.put(r.Id, r);
          rankedResponses.add(r);
        } // endif
      } // endfor   
    } // endif
    
    // Only search further if we have fewer than 20 results and more than 1 keyword.
    if ((foundResponses.size() < 20) && (keywords.size() > 1))
    {
      // Cast the netQuery to capture the responses which have  
      // ANY the keywords in them using an OR query.
      String netQuery = constructQuery(pSearchObject, fields, keywords, 'OR');
      System.debug(netQuery);
      try
      {
        searchList = search.query(netQuery);
      }
      catch (QueryException e)
      {
        // QueryExceptions are caused by query strings provided by the user that are
        // too short - like 'S*';
        // Just return an empty list.
        searchList = new List<List<SObject>>();
      } // endcatch     
      if (searchList.size() > 0)
      {
        sObject[] results = ((List<sObject>) searchList[0]);
        for (sObject s: results)
        {
          String responseId = s.Id;
          if (s.getsObjectType() == Question__c.sObjectType)
          {
            responseId = (String) s.get('Response__c');
          }
          // Screen out any results (Questions that point to responses, or responses)
          // that have already been found.  If we're querying on questions, we want
          // each question returned to point to a unique response, rather than a bunch
          // of very similar questions pointing to the same response.
          // 
          // We also want the result list to have the BEST matched questions in it for 
          // a given response.
          Response newResponse = createSearchResponse(s, keywords);
          Response existingResponse = foundResponses.get(responseId);
          if ((existingResponse == null) || (newResponse.Hits > existingResponse.Hits))
          {
            foundResponses.put(responseId, newResponse);
          }
        } // endfor 
      } // endif
    } // endif
    
    // The best responses are already at the top of the rankedResponse list.
    // We need to remove them from the foundResponses map so we can iterate through the 
    // foundResponses and add the remaning Responses in descending order of hits to the 
    // rankedResponses list.
    for (Response r: rankedResponses)
    {
      foundResponses.remove(r.Id);
    } // endif
    
    while (!foundResponses.isEmpty())
    {
      Integer biggestHitValue = -1;
      Response bestResponse = null;
      for (Response r: foundResponses.values())
      {
        if (r.Hits > biggestHitValue)
        {
          bestResponse = r;
          biggestHitValue = r.Hits;
        } // endif
      } // endfor
      rankedResponses.add(bestResponse);
      foundResponses.remove(bestResponse.Id);
    }
    return rankedResponses;
  }
  
  private Response createSearchResponse(sObject s, String[] keywords)
  {
    Integer hitCount = 0;
    Response r = new Response();
    if (s.getsObjectType() == Response__c.sObjectType)
    {
      r.Id = s.Id;
      r.Summary = (String) s.get('Name');
      r.Status = (String) s.get('Status__c');
    } // endif
    
    if (s.getsObjectType() == Question__c.sObjectType)
    {
      r.Id = (String) s.get('Response__c');
      r.Summary = (String) s.get('Question__c');
      r.Status = (String) s.get('Response_Status__c');
    } // endif
    
    if (keywords != null)
    {
      for (String keyword: keywords)
      {
        String keywordLC = keyword.toLowerCase();
        if ((r.Summary != null) && r.Summary.toLowerCase().contains(keywordLC))
        {
          hitCount+=2;  // Double points for keyword in Title or Question
        } // endif
        if (s.getsObjectType() == Response__c.sObjectType)
        {
          String solutionNote = (String) s.get('Response_Text__c');
          if ((solutionNote != null) && solutionNote.toLowerCase().contains(keywordLC))
          {
            hitCount++;
          }
        } // endif
      } // endfor
    } // endif
    r.Hits = hitCount;
    return r;
  }
  
  public String[] getResponseText()
  {
    PageReference pageRef = ApexPages.currentPage();
    Map<String, String> parameters = pageRef.getParameters();
    String pResponseId = parameters.get('id');
    return getResponseTextById(pResponseId);
  }
  
  private String[] getResponseTextById(String pId)
  {
    String[] result = new String[1];
    if ((pId != null) && (pId.length() > 0))
    {
      try
      {
        Response__c r = [Select r.Response_Text__c From Response__c r where Id = :pId LIMIT 1];
        result[0] = r.Response_Text__c;
      }
      catch (QueryException e)
      {
        result[0] = '';
      }
    } // endif
    return result;      
  }
    
  private string constructQuery(String searchObject, String fields, String[] keywords, String logicalOperator)
  {
    String searchQuery = '';
    for (String keyword: keywords)
    {
        keyword = keyword.trim();
        if (keyword.length() > 0)
        {
            if (searchQuery.length() == 0)
            {
                searchQuery= 'FIND \'' + keyword +  '*';
            }
            else
            {
                searchQuery += ' ' + logicalOperator + ' ' + keyword + '*';
            } // endif
        } // endif 
    } // endfor
    searchQuery += '\' IN ALL FIELDS RETURNING ' + SearchObject + ' (' + fields + ') LIMIT 20';
    return searchQuery;
  }  
   
  static testMethod void testRFPForce()
  {     
    PorterStemmer.testPorterStemmer();
    RFP_AJAXInterface i = new RFP_AJAXInterface();

    PageReference pg = Page.RFP_GetResponses; 
    Test.setCurrentPage(pg); 
    ApexPages.currentPage().getParameters().put('question', null);    
    ApexPages.currentPage().getParameters().put('search', 'questions');    
    Response[] r = i.getResponses();

    ApexPages.currentPage().getParameters().put('question', 'What are your competitive differentiators?');    

    String[] fixedSearchResults = new String[]{'a03E0000001DzCV', 'a03E0000001DzEC' };
    Test.setFixedSearchResults(fixedSearchResults);
    r = i.getResponses();
    
    fixedSearchResults = new String[]{'a03E0000001DzCV', 'a03E0000001DzEC'};
    Test.setFixedSearchResults(fixedSearchResults);
    ApexPages.currentPage().getParameters().put('search', 'responses');    
    r = i.getResponses();   
    
    // Trigger Test: Create a duplicate usage entry
    Question__c u = new Question__c();
    u.Question__c = 'Test Question';
    u.Original_Response__c = false;
    u.Response__c = 'a03E0000001DzIX';
    u.RFP__c = 'a01E0000000CFo8';
    try
    {
      insert u;
    }
    catch (DMLException e)
    {
      System.debug(e.getMessage());
      // expected behavior.
    }
    
    Integer result = RFP_AJAXInterface.getStopWordCount();
    
  }
 
 
 
  
}