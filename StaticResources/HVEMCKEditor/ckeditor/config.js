/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.startupMode = 'wysiwyg';
	config.resize_enabled = false;
	config.toolbar =
	[
		['Font','FontSize','BGColor','TextColor','Bold', 'Italic','Underline', 'Link','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','BulletedList','NumberedList','Indent','Outdent']
	];
};
