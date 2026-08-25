const showcaseTable = Object.freeze({
  armenta_lib: {
    embedUrl: 'https://files.catbox.moe/zl4njb.mp4'
  },
  aztup: {
    embedUrl: 'https://mega.nz/embed/BQsiHbLZ#5HmpL81nfRptb5WdK7_neQLpwA4zpv8wfqMt37dMEws'
  },
  bacon: {
    embedUrl: 'https://mega.nz/embed/EZshGTAI#91w4D-Ur7h8xfGmL81Gs0IhfoOATmF7aDvzLyC0B18w'
  },
  discord_lib: {
    embedUrl: 'https://mega.nz/embed/dFtFBS4a#Rm0HKEYLSmSK7Udwy-UzKmTn4VKPekEsL8KAB0niaSo'
  },
  synergyui: {
    embedUrl: 'https://mega.nz/embed/9UdzlJbD#cbWE8v9-Q59CtYhD0zLPXjO7kCMSAROYCUA4SE2seH0'
  }
});

function getShowcase(libraryId) {
  return showcaseTable[libraryId] || null;
}

window.showcaseTable = showcaseTable;
window.getShowcase = getShowcase;

void window.showcaseTable;
void window.getShowcase;
