const showcaseTable = Object.freeze({
  armenta_lib: {
    embedUrl: 'https://files.catbox.moe/zl4njb.mp4'
  },
  aztup: {
    embedUrl: 'https://files.catbox.moe/di65fq.mp4'
  },
  bacon: {
    embedUrl: 'https://files.catbox.moe/bpo9er.mp4'
  },
  discord_lib: {
    embedUrl: 'https://files.catbox.moe/wq7znk.mp4'
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
