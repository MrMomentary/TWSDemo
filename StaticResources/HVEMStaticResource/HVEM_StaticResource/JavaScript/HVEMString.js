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

var HVEMApp = window.HVEMApp || {};

HVEMApp.Util = HVEMApp.Util || {};

HVEMApp.Util.String = (function() {

    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    var typeCheck = Object.prototype.toString;

    function isArray(target) {
        if (target === undefined || target === null) {
            return false;
        }
        return typeCheck.call(target) === "[object Array]";
    };

    function isEmpty(target) {
        return target === null || target === undefined || target === '' || (isArray(target) && !target.length);
    }

    function htmlEscapeChararacter(ch) {
        switch (ch) {
            case '\'' :
                // apostrophe - '\'' - do not use &apos; because it does not work in IE
                return '&#39;';
            case '&':
                return '&amp;';
            case '<':
                return '&lt;';
            case '>':
                return '&gt;';
            case '"':
                return '&quot;';
            case '\u00a9':
                return '&copy;';
            case '\u2028':
                return '<br>';
            case '\u2029':
                return '<p>';
            default:
                return ch;
        }
    }

    return {
        escapeToHtml : function (input, escapeNewline) {
            if (input == null) {
                return "";
            }

            if (isEmpty(input)) {
                return input;
            }

            var result = input.replace(/[&<>"'\u00a9\u2028\u2029]/g, htmlEscapeChararacter);

            if (escapeNewline) {
                result = result.replace(/\n/g, '<br>');
            }

            return result;
        },

        unescapeHtml : function (input, replaceBRwithNewline) {
            if (input == null) {
                return "";
            }

            if (isEmpty(input)) {
                return input;
            }

            var result = input.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '\"').replace(/&apos;/g, "'").replace(/&#39;/g, "'").replace(/&copy;/g, '©').replace(/&amp;/g, '&');

            if (replaceBRwithNewline) {
                result = result.replace(/<br>/g, '\n').replace(/<br\/>/g, '\n');
            }

            return result;
        }
    }
})();


