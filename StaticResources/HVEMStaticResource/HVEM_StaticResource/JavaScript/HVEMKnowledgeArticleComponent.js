/*
Copyright (c) 2012, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// updates the hidden field to the id of the current article from the current selected element
function setCurrentId(element){
  document.getElementById('idCurrentArticleHidden').value = element.parentNode.id;
}

//updates the hidden field to the id of the current article from the search list index
function setCurrentArticle(newIdx) {
    var idCurrentArticleHidden = document.getElementById('idCurrentArticleHidden');
    idCurrentArticleHidden.value = 'HVEMKnowledgeArticlePageId:KnowledgeArticleComId:HVEMKnowledgeArticleCompId:HVEMKnowledgeArticleFormId:SearchResultId:idArticlePageBlockTable:'
        + newIdx + ':idSingleArticlePanel';
}

// highlight the specified article in the search results list
function setStyleClass(element){

    var previousId = document.getElementById('idPreviousArticleHidden').value;
    var currentId = document.getElementById('idCurrentArticleHidden').value;
    document.getElementById(previousId).className = "hvemCaseItem";
    document.getElementById(currentId).className = "hvemCaseItemSelection";

    document.getElementById('idPreviousArticleHidden').value = document.getElementById(currentId).id;
}

// highlight the first article in the search results list
function setFirstArticleStyle(){
    if(document.getElementById('HVEMKnowledgeArticlePageId:KnowledgeArticleComId:HVEMKnowledgeArticleCompId:HVEMKnowledgeArticleFormId:SearchResultId:idArticlePageBlockTable:0:idSingleArticlePanel') != null){
        document.getElementById('HVEMKnowledgeArticlePageId:KnowledgeArticleComId:HVEMKnowledgeArticleCompId:HVEMKnowledgeArticleFormId:SearchResultId:idArticlePageBlockTable:0:idSingleArticlePanel').className = "hvemCaseItemSelection";
    }
    document.getElementById('idPreviousArticleHidden').value="HVEMKnowledgeArticlePageId:KnowledgeArticleComId:HVEMKnowledgeArticleCompId:HVEMKnowledgeArticleFormId:SearchResultId:idArticlePageBlockTable:0:idSingleArticlePanel";
}

// hide / show the advanced search options
function toggleFilters(show) {
    var filters = document.getElementById('searchFilters');
    var filtersToggle = document.getElementById('searchFiltersToggle');
    if (show) {
        filters.style.display = 'table-row';
        filtersToggle.style.display = 'none';
    } else {
        filters.style.display = 'none';
        filtersToggle.style.display = 'table-row';
    }
}

// run the search based on search parameters
function fetchSelection(){
    document.getElementById('HVEMKnowledgeArticlePageId:KnowledgeArticleComId:HVEMKnowledgeArticleCompId:HVEMKnowledgeArticleFormId:HVEMKnowledgeArticleFilterPageBlockId:SearchButtonId').focus();
    if(categoryGroupNames != null && categoryGroupNames != ''){
        var CategoryGroupsList = categoryGroupNames.split(",");
        var withDataCategoryClause = '';
        for(var i = 0; i < CategoryGroupsList.length; i++){
            var singleCategoryGroupName = document.getElementById('categoryType_'+CategoryGroupsList[i]);
            if(singleCategoryGroupName != null && singleCategoryGroupName.value != 'No Filter' ){
                withDataCategoryClause = withDataCategoryClause + singleCategoryGroupName.value +' AND ';
            }
        }
        if(withDataCategoryClause != ''){
            withDataCategoryClause = withDataCategoryClause.substr(0,withDataCategoryClause.length-4);
            withDataCategoryClause = 'WITH DATA CATEGORY ' + withDataCategoryClause;
        }
        //runSearch(withDataCategoryClause,'page');
        refreshSearchResultAF(withDataCategoryClause,'page');
    }
}

// kicks the insertion of a link to the current article in the email publisher
function insertArticleLink(idx) {
    var articleId = getKavIdFromIdx(idx);
    insertArticleLinkAF(
            'en_US',
            document.getElementById("kaId_" + idx).value,
            document.getElementById("urlname_" + articleId).value,
            document.getElementById("type_" + articleId).value,
            document.getElementById("title_" + articleId).value
            );
}

// kicks the insertion of the current article content in the email publisher
function insertArticleContent(idx) {
    var articleId = getKavIdFromIdx(idx);
    insertArticleContentAF(
            'en_US',
            document.getElementById("kaId_" + idx).value,
            document.getElementById("urlname_" + articleId).value,
            document.getElementById("type_" + articleId).value,
            document.getElementById("title_" + articleId).value,
            document.getElementById("summary_" + articleId).value
            );
}

// display an article in the renderer part of the component
// from a result list index
function displayArticle(newIdx) {
    setCurrentArticle(newIdx);

    var articleId = getKavIdFromIdx(newIdx);
    var articleType = document.getElementById("type_" + articleId).value;
    var articleTitle = document.getElementById("title_" + articleId).value;
    var articleSummary = document.getElementById("summary_" + articleId).value;
    displayCustomArticleAF(articleId, "n/a", articleType, articleTitle, articleSummary);
    idxCurrentArticle = newIdx;

}

// display an article in the renderer part of the component from an article id
function displayArticleById(id) {
    displayArticle(getArticleIdxFromKavId(id));
}

// kicks the insertion of a link to the current article in the email publisher from an article id
function insertArticleLinkById(id) {
    insertArticleLink(getArticleIdxFromKavId(id));
}

// kicks the insertion of the current article content in the email publisher from an article id
function insertArticleContentById(id) {
    insertArticleContent(getArticleIdxFromKavId(id));
}

// get the article id (KavId) from search result list index
function getKavIdFromIdx(idx) {
    var id = document.getElementById('kavId_' + idx).value;
    return id;
}

// get the search result list index from article id (KavId)
function getArticleIdxFromKavId(id) {
    var idx = document.getElementById('articleIdx_' + id).value;
    return idx;
}

// get the search result list index from article id (KaId)
function getArticleIdxFromKaId(id) {
    var idx = document.getElementById('articleIdx_' + id).value;
    return idx;
}

// article link/content insertion in the editor
//   if content mode (rather than link) article is not the current one, then first select it
function insertArticleInEditor(kaId,articleTitleForUrl,url,articleType,articleSummary){
    if (bInsertContent) {
        console.log("Preparing hvemInsertInEditor -content");
        var renderer = document.getElementById("articleRenderer");
        if (renderer!=null) {
            var selectedArticleId = getKavIdFromIdx(idxCurrentArticle);
            var kavId = getKavIdFromIdx(getArticleIdxFromKaId(kaId));
            if (kavId!=selectedArticleId) {
                console.log("Preparing hvemInsertInEditor -content (loading article)");
                setCurrentArticle(getArticleIdxFromKavId(kavId));
                displayAndInsertArticleContentAF(
                        kavId,
                        "n/a",
                        articleType,
                        articleTitleForUrl,
                        articleSummary);
                return;
            }
            var content = renderer.innerHTML;
            console.log("Firing hvemInsertInEditor -content (1)");
            sforce.console.fireEvent('hvemInsertInEditor', 'Content:::' + content, callback);

        } else {
            console.log("HVEM--Can't get article renderer content");
        }
    } else {
        console.log("Firing hvemInsertInEditor -link");
        sforce.console.fireEvent('hvemInsertInEditor', 'Link:::' + articleTitleForUrl + '][' + url, callback);
    }
}

// article content insertion
function insertArticleContentInEditor(obj) {
    console.log("Firing hvemInsertInEditor -content (2)");
    setStyleClass(obj);
    var renderer = document.getElementById("articleRenderer");
    if (renderer!=null) {
        var selectedArticleId = getKavIdFromIdx(idxCurrentArticle);
        var content = renderer.innerHTML;
        console.log("Firing hvemInsertInEditor -content (3)");
        sforce.console.fireEvent('hvemInsertInEditor', 'Content:::' + content, callback);
    }
}

var callback = function(result) {
    if (result.success) {
        console.log("Fired hvemInsertInEditor");
    } else {
        console.log("NOT fired hvemInsertInEditor");
    }
};

// kicks off article insertion (from a click on the clipper icon)
function insertArticle(idx) {
    var articleId = getKavIdFromIdx(idx);
    insertArticleAF(
            'en_US',
            document.getElementById("kavId_" + idx).value,
            document.getElementById("kaId_" + idx).value,
            document.getElementById("urlname_" + articleId).value,
            document.getElementById("type_" + articleId).value,
            document.getElementById("title_" + articleId).value
            );
}

//kicks off article insertion (from a click on the clipper icon)
function insertArticleById(id) {
    insertArticle(getArticleIdxFromKavId(id));
}

/*
 * up, down and insert events handling
 *
 * events are processed only if the component is contained in
 * the focused primary tab
 */
var enclosingTabId = -1;
var focusedTabId = -1;
var maxWait=10;
var waited=0;

var eventGoUp = function () {
    focusedTabId = -1;
    sforce.console.getFocusedPrimaryTabId(processEventGoUp);
}
var eventGoDown = function () {
    focusedTabId = -1;
    sforce.console.getFocusedPrimaryTabId(processEventGoDown);
}
var eventInsertArticleLink = function () {
    focusedTabId = -1;
    sforce.console.getFocusedPrimaryTabId(processEventInsertArticleLink);
}
var eventInsertArticleContent = function () {
    focusedTabId = -1;
    sforce.console.getFocusedPrimaryTabId(processEventInsertArticleContent);
}

/* processor for the 'up' event: move up in the result list */
var processEventGoUp = function(result) {
    // is this the focused tab?
    focusedTabId = result.id;
    if (enclosingTabId!=focusedTabId) return;

    // move selection 1 up
    if (iResultsListSize>1 && idxCurrentArticle>0) {
        var newIdx = 0 + parseInt(idxCurrentArticle) - 1;
        displayArticle(newIdx);
    }
}

/* processor for the 'down' event: move down in the result list */
var processEventGoDown = function(result) {
    // is this the focused tab?
    focusedTabId = result.id;
    if (enclosingTabId!=focusedTabId) return;

    // move selection 1 down
    if (iResultsListSize>1 && idxCurrentArticle<(iResultsListSize-1)) {
        var newIdx = parseInt(idxCurrentArticle) + 1;
        displayArticle(newIdx);
    }
}

/* processor for the 'insert link' event: insert link to current article in the editor */
var processEventInsertArticleLink = function(result) {
    // is this the focused tab?
    focusedTabId = result.id;
    if (enclosingTabId!=focusedTabId) return;

    // insert link to article
    insertArticleLink(idxCurrentArticle);
}

/* processor for the 'insert content' event: insert current article content in the editor */
var processEventInsertArticleContent = function(result) {
    // is this the focused tab?
    focusedTabId = result.id;
    if (enclosingTabId!=focusedTabId) return;

    // move selection 1 up
    insertArticleContent(idxCurrentArticle);
}

