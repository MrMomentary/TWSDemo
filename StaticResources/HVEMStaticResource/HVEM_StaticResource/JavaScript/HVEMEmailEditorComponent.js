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

function testIsInConsole() {
    if (sforce.console.isInConsole()) {
        return 1;
    } else {
        return 0;
    }
}

function displayComponents(pValue){
    var additionalToVar = document.getElementById('idAdditionalToTr');
    var addCcVar = document.getElementById('idCcToTr');
    var addBccVar = document.getElementById('idBccToTr');

    if(pValue == 'additionalTo'){
        if(additionalToVar.style.display == 'table-row' ){
            additionalToVar.style.display = 'none';
        }else{
            additionalToVar.style.display = 'table-row';
        }
    }
    if(pValue == 'addCc'){
        if(addCcVar.style.display == 'table-row'){
            addCcVar.style.display = 'none';
        }else{
            addCcVar.style.display = 'table-row';
        }
    }
    if(pValue == 'addBcc'){
        if(addBccVar.style.display == 'table-row'){
            addBccVar.style.display = 'none';
        }else{
            addBccVar.style.display = 'table-row';
        }
    }
}

function displayEmailAddresses(finalAdditionalTo,finalCcTo,finalBccTo){
    document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idAdditionalTo').value += finalAdditionalTo;
    document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idCcTo').value += finalCcTo;
    document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idBccTo').value += finalBccTo;
}


/*
 * Add content to email editor or CKeditor
 */
function populateEditorJS(){
    isTemplateDeleted = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:TemplateDeleted').value;
    templateType = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:templateType').value;
    editorTextValue = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:textValue').value;
    editorHtmlValue = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:htmlValue').value;

    /*
    if(isTemplateDeleted == true){
        alert('deleted');
        CKEDITOR.instances.idMainEmailBody.destroy();
        document.getElementById('idMainEmailBody').value = '';
    }else
    */
    if(templateType == 'custom'){
        if(previousEmailTemplate != 'custom'){
            //previous template is text
            var editor = CKEDITOR.replace( 'nameMainEmailBody');
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,false);
            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            CKEDITOR.instances.idMainEmailBody.setData(decoded);
        }else{
            CKEDITOR.instances.idMainEmailBody.setData('abc');
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,false);

            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            CKEDITOR.instances.idMainEmailBody.setData(decoded);
        }
        previousEmailTemplate = templateType;
    }else{
        if(previousEmailTemplate == 'custom'){
            //CKEDITOR.instances.idMainEmailBody.setData('');
            CKEDITOR.instances.idMainEmailBody.destroy();
            editorTextValue = editorTextValue.replace(/<br\/>/g, "\n");
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,true);
            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            document.getElementById('idMainEmailBody').value = decoded;
        }else{
            editorTextValue = editorTextValue.replace(/<br\/>/g, "\n");
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,true);
            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            document.getElementById('idMainEmailBody').value = decoded;
        }
        previousEmailTemplate = templateType;
    }
}

/*
 * JS to be called after discard changes is complete
 */
function reloadCKEditor(){
    document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idfullBodyPanel').style.display = 'block';
    isTemplateDeleted = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:TemplateDeleted').value;
    templateType = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:templateType').value;
    editorTextValue = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:textValue').value;
    editorHtmlValue = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:htmlValue').value;

    if(isTemplateDeleted == 'true'){
        if(previousEmailTemplate == 'custom'){
            CKEDITOR.remove(CKEDITOR.instances.idMainEmailBody);
        }
        document.getElementById('idMainEmailBody').value = '';
    }else if(templateType == 'custom'){
        if(previousEmailTemplate != 'custom'){
            var editor = CKEDITOR.replace( 'nameMainEmailBody');
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,false);
            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            CKEDITOR.instances.idMainEmailBody.setData(decoded);
        }else{
            try{
               //CKEDITOR.instances.idMainEmailBody.destroy();
                CKEDITOR.remove(CKEDITOR.instances.idMainEmailBody);
                var editor = CKEDITOR.replace( 'nameMainEmailBody' );
                var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,false);
                decoded = decoded.replace('<![CDATA[', '');
                decoded = decoded.replace(']]>', '');
                CKEDITOR.instances.idMainEmailBody.setData(decoded);
            }catch(e){
                var e1 = e;
            }
        }
    }else{
        if(previousEmailTemplate == 'custom'){
            CKEDITOR.remove(CKEDITOR.instances.idMainEmailBody);
            editorTextValue = editorTextValue.replace(/<br\/>/g, "\n");
            document.getElementById('idMainEmailBody').value = editorTextValue ;
        }else{
            editorTextValue = editorTextValue.replace(/<br\/>/g, "\n");
            var decoded = HVEMApp.Util.String.unescapeHtml(editorTextValue,true);
            decoded = decoded.replace('<![CDATA[', '');
            decoded = decoded.replace(']]>', '');
            document.getElementById('idMainEmailBody').value = editorTextValue ;
        }

    }
    previousEmailTemplate = templateType;
    if(isTemplateDeleted == 'true'){
        previousEmailTemplate = 'text';
    }
    var discardLink = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:DiscardId');
    discardLink.style.display = 'none';
    document.getElementById('discardChangesSpan').style.display='block';
}

/*
 * JS on click of save draft functionality
 */
function saveDraftJS(element){
    if(previousEmailTemplate == '' || previousEmailTemplate == 'text'){
        var editorContent = document.getElementById('idMainEmailBody').value;
    }else if(previousEmailTemplate == '' || previousEmailTemplate == 'custom'){
        var editorContent =  CKEDITOR.instances.idMainEmailBody.getData();
    }

    additionalTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idAdditionalTo').value;
    ccTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idCcTo').value ;
    bccTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idBccTo').value ;
    saveDraftAF(editorContent,additionalTo,ccTo,bccTo);
}

/*
 * JS on click of Send and next button
 */
function sendAndNextActionJS(type){
    if(previousEmailTemplate == '' || previousEmailTemplate == 'text'){
        var editorContent = document.getElementById('idMainEmailBody').value;
    }else if(previousEmailTemplate == '' || previousEmailTemplate == 'custom'){
        var editorContent =     CKEDITOR.instances.idMainEmailBody.getData();
    }
    additionalTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idAdditionalTo').value;
    ccTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idCcTo').value ;
    bccTo = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idBccTo').value ;
    if(type == 'SuperUserApproval'){
        sendAndNextActionAF(editorContent,additionalTo,ccTo,bccTo,true);
    }else{
        sendAndNextActionAF(editorContent,additionalTo,ccTo,bccTo,false);
    }
}

/*
 * to open new tab on click of Send and next button
 */
function handleTabs(){
    var isValidated = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:isValidated').value;
    var nextCaseId = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:nextCaseId').value;
    var nextCaseId = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:nextCaseId').value;
    var nextCaseNumber = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:nextCasenumber').value;
    var isNoCustomError = document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:isNoCustomError').value;

    if(isNoCustomError == 'true'){
        if(nextCaseId != null && nextCaseId != ''){
            sforce.console.openPrimaryTab(undefined,'/' +nextCaseId , true, nextCaseNumber);
            testCloseTab();
            sforce.console.fireEvent('hvemKbUp', 'HVEM:::CaseList:::Refresh', null);
        }else{
            document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idfullBodyPanel').style.display = 'none';
            document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com1:hvemEmailEditoComponentId:idNoCaseinQueuePanel').style.display = 'block';
            document.getElementById('HVEMEmailEditorPublishierPageId:HVEMEmailPublisierForm:com').style.display = 'none';
        }
    }
}

function testCloseTab() {
    //First find the ID of the current tab to close it
    sforce.console.getEnclosingTabId(closeSubtab);
}

var closeSubtab = function closeSubtab(result) {
    //Now that we've got the tab ID, we can close it
    var tabId = result.id;
    sforce.console.closeTab(tabId);
};
