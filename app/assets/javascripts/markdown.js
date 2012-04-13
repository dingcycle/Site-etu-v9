// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// MarkDown tags example
// http://en.wikipedia.org/wiki/Markdown
// http://daringfireball.net/projects/markdown/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------

// Dorian : définit l'url vers la page d'accueil via la bannière (ou /)
ROOT_URL = (typeof(ROOT_URL) == 'undefined') ? '/' : ROOT_URL.href;

mySettings = {
  resizeHandle: false, // Dorian : Géré par le navigateur
  previewAutoRefresh: true, // Dorian : Met à jour automatiquement la preview
  previewParserPath: ROOT_URL + '/preview', // Dorian : prévisualisation via l'application Rails
  onShiftEnter: {keepDefault:false, openWith:'\n\n'},
  markupSet: [
    {name:'First Level Heading', key:'1', placeHolder:'Votre titre...', closeWith:function(markItUp) { return miu.markdownTitle(markItUp, '=') } },
    {name:'Second Level Heading', key:'2', placeHolder:'Votre titre...', closeWith:function(markItUp) { return miu.markdownTitle(markItUp, '-') } },
    {name:'Heading 3', key:'3', openWith:'### ', placeHolder:'Votre titre...' },
    {name:'Heading 4', key:'4', openWith:'#### ', placeHolder:'Votre titre...' },
    {name:'Heading 5', key:'5', openWith:'##### ', placeHolder:'Votre titre...' },
    {name:'Heading 6', key:'6', openWith:'###### ', placeHolder:'Votre titre...' },
    {separator:'-' },
    {name:'Bold', key:'B', openWith:'**', closeWith:'**'},
    {name:'Italic', key:'I', openWith:'_', closeWith:'_'},
    {separator:'-' },
    {name:'Bulleted List', openWith:'- ' },
    {name:'Numeric List', openWith:function(markItUp) {
      return markItUp.line+'. ';
    }},
    {separator:'-' },
    {name:'Picture', key:'P', openWith:'![', closeWith:']([![Url:!:http://]!])', placeHolder:'Une description...'},
    {name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!])', placeHolder:'Le texte du lien...' },
    {separator:'-'},
    {name:'Quotes', openWith:'> '},
    {name:'Code Block / Code', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)'},
    {separator:'-'},
    {name:'Preview', call:'preview', className:"preview"}
  ]
}

// mIu nameSpace to avoid conflict.
miu = {
  markdownTitle: function(markItUp, char) {
    heading = '';
    n = $.trim(markItUp.selection||markItUp.placeHolder).length;
    for(i = 0; i < n; i++) {
      heading += char;
    }
    return '\n'+heading;
  }
}
