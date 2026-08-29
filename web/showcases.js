const showcaseTable = Object.freeze({
  '0x37': {
    embedUrl: 'https://files.catbox.moe/5buknf.mp4'
  },
  apple: {
    embedUrl: 'https://files.catbox.moe/5gwc7y.mp4'
  },
  armenta_lib: {
    embedUrl: 'https://files.catbox.moe/zl4njb.mp4'
  },
  aztup: {
    embedUrl: 'https://files.catbox.moe/di65fq.mp4'
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
    embedUrl: 'https://files.catbox.moe/1mg3kd.mp4'
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
