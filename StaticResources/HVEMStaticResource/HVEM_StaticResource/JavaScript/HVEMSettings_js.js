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

/*
function OnTransferBtnClick1(blnFromLeft) {
    var LeftListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:CategoryGroups1Id');
    var RightListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:CategoryGroups2Id');
    var ListItems = new Array();
    FromList = (blnFromLeft ? LeftListBox : RightListBox);
    ToList = (blnFromLeft ? RightListBox : LeftListBox);
    for(var i=(FromList.options.length - 1);i>=0;i--)
    if(FromList.options[i].selected) {
        ListItems[ListItems.length] = new Option(FromList.options[i].text,FromList.options[i].value,true,false);
        FromList.options[i] = null;
     }
     for(var i=ListItems.length - 1;i>=0;i--)
      	ToList.options[ToList.options.length]= ListItems[i];
}
*/

function OnTransferBtnClick2(blnFromLeft, type) {
    var LeftListBox;
    var RightListBox;
    if( type == 'articleType'){
        LeftListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:articleTypesFilter1Id');
        RightListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:articleTypesFilter2Id');
    }
    else if(type == 'publicGroups'){
        LeftListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:PublicGroupSelectList1Id');
        RightListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:PublicGroupSelectList2Id');
    }else if(type == 'userLanguage'){
        LeftListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:AvailableLanguageId');
        RightListBox = document.getElementById('HVEMPageId:hvemForm:hvemPageBlockId:SelectedLanguageId');
    }
    var ListItems = new Array();
    FromList = (blnFromLeft ? LeftListBox : RightListBox);
    ToList = (blnFromLeft ? RightListBox : LeftListBox);
    for(var i=(FromList.options.length - 1);i>=0;i--)
    if(FromList.options[i].selected) {
        ListItems[ListItems.length] = new Option(FromList.options[i].text,FromList.options[i].value,true,false);
        FromList.options[i] = null;
     }
     for(var i=ListItems.length - 1;i>=0;i--)
      	ToList.options[ToList.options.length]= ListItems[i];
}

