const showcaseTable = Object.freeze({
  armenta_lib: {
    embedUrl: 'https://mega.nz/embed/MRkRBApL#KFE30TjcbNAfCv-aY8FJSjKAxzEM_eU_6zvRJSydwms'
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

