const showcaseTable = Object.freeze({
  '0x37': {
    embedUrl: 'https://files.catbox.moe/5buknf.mp4'
  },
  apple: {
    embedUrl: 'https://files.catbox.moe/5gwc7y.mp4'
  },
  armenta_lib: {
    embedUrl: 'https://www.youtube.com/embed/svxssTh00O4?si=UMnueGury7wCeA_5'
  },
  aztup: {
    embedUrl: 'https://www.youtube.com/embed/0ivUX4me6r4?si=zs-fVfcySE0Ix-s7'
  },
  avilon_modified: {
    embedUrl: 'https://files.catbox.moe/duv7ak.mp4'
  },
  bacon: {
    embedUrl: 'https://www.youtube.com/embed/4g5VNQDMXlQ?si=BfYe_0sCPDZlW8NN'
  },
  discord_lib: {
    embedUrl: 'https://files.catbox.moe/wq7znk.mp4'
  },
  flux: {
    embedUrl: 'https://www.youtube.com/embed/0HE4YBxqWxY?si=IDI92_LwGOMHLBQ8'
  },
  synergyui: {
    embedUrl: 'https://files.catbox.moe/cw0lli.mp4'
  }
});

function getShowcase(libraryId) {
  return showcaseTable[libraryId] || null;
}

window.showcaseTable = showcaseTable;
window.getShowcase = getShowcase;

void window.showcaseTable;
void window.getShowcase;
