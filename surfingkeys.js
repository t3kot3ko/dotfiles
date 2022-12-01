const {
    aceVimMap,
    mapkey,
    imap,
    imapkey,
    getClickableElements,
    vmapkey,
    map,
    unmap,
    cmap,
    addSearchAlias,
    removeSearchAlias,
    tabOpenLink,
    readText,
    Clipboard,
    Front,
    Hints,
    Visual,
    RUNTIME
} = api;

// an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
map('gt', 'T');

addSearchAlias('g', 'Google', 'https://www.google.com/search?q=', 's', 'https://www.google.com/complete/search?client=chrome-omni&gs_ri=chrome-ext&oit=1&cp=1&pgcl=7&q=', function(response) {
    var res = JSON.parse(response.text);
    return res[1];
});

map("b", "t") // Tab list
unmap("t")

map("h", "S") // Back
map("l", "D") // Foward

map("S", "og") // Search with Google in a new tab
map("o", "go") // Open URL in current tab
mapkey('tt', '#8Open a URL', function() {
    Front.openOmnibar({type: "URLs", extra: "getAllSites"});
});

// mapkey('Q', '#8Open omnibar for word translation', function() {
//     Front.openomnibar({type: Normal.getWordUnderCursor(), style: "opacity: 0.8;"});
// });

map("T", ";u") // new tab
map("O", ";U") // current

// Search with Google in current tab
mapkey('s', '#8Open Search with alias g', function() {
    Front.openOmnibar({type: "SearchEngine", extra: "g", tabbed: false});
});

map("@", '<Alt-p>') // Toggle pin

map("[[", 'gx0') // Close all left tabs
map("]]", 'gx$') // Close all right tabs

map("<Ctrl-f>", "d") // Page down
map("<Ctrl-b>", "u") // Page up

map("u", "X") // Restore closed tab

mapkey("th", "Go one tab left", function() {
  RUNTIME("previousTab");
})

mapkey("tl", "Go one tab left", function() {
  RUNTIME("nextTab");
})
// Yank URL
// mapkey('yy', "#7Copy current page's URL", function() {
// Yank
map("yt", 'yl') // Yank title

mapkey("yA", "Copy ASIN URL", function() {
 const asin = window.document.getElementById('ASIN').value
 Clipboard.write("http://amazon.jp/dp/" + asin)
});

mapkey("yx", "Copy title and URL", function() {
 const title = window.document.title;
 const url = window.document.location.href;
 Clipboard.write("< " + title + " >\r" + url)
});

// Marks
// mapkey('gm', '#10Add current URL to vim-like marks', Normal.addVIMark);
// mapkey("go", '#10Jump to vim-like mark', Normal.jumpVIMark);
// mapkey("gn", '#10Jump to vim-like mark in new tab.', function(mark) {
//     Normal.jumpVIMark(mark);
// });
mapkey('gl', '#8Open URL from vim-like marks', function() {
    Front.openOmnibar({type: "VIMarks"});
});

unmap("p")
mapkey("p", "#0Open URL or search with cliopboard in current tab", function() {
    Clipboard.read(function(response) {
      const data = response.data
      if (data.match(/^http|^https/)) {
        RUNTIME("openLink", {
            tab: { tabbed: false },
            url: data
        });
      } else {
        RUNTIME("openLink", {
            tab: { tabbed: false },
            url: "https://www.google.com/search?q=" + data
        });
      }
    });
  }
)

mapkey("P", "#0Open URL or search with cliopboard in new tab", function() {
    Clipboard.read(function(response) {
      const data = response.data
      if (data.match(/^http|^https/)) {
        tabOpenLink(data);
      } else {
        tabOpenLink("https://www.google.com/search?q=" + data);
      }
    });
  }
);

unmap("ta");
mapkey("ta", "#0Open Japanese-translated version of Azure doc", function() {
    const url = window.location.href.replace("en-us", "ja-jp");
    RUNTIME("openLink", {
        tab: { tabbed: false },
        url: url
    });
});
unmap("te");
mapkey("te", "#0Open English version of Azure doc", function() {
    const url = window.location.href.replace("ja-jp", "en-us");
    RUNTIME("openLink", {
        tab: { tabbed: false },
        url: url
    });
});
unmap("tk");
mapkey("tk", "#0Open Kudu", function() {
    const url = window.location.href.replace(".azurewebsites.net", ".scm.azurewebsites.net");
    RUNTIME("openLink", {
        tab: { tabbed: true },
        url: url
    });
});

settings.smoothScroll = false
settings.tabsThreshold = 0
settings.omnibarPosition = "bottom"
settings.blacklistPattern = undefined

// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 14pt;
}
#sk_omnibar {
    width: 100%;
    left: 0%;
}
`;
