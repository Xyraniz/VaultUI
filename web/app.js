const libraryBase = window.location.pathname.includes('/web/') ? '../Libraries' : 'Libraries';

const libraries = [
  {
    id: '0x37',
    name: '0x37',
    label: '0x37',
    number: '01',
    type: 'Loadstring + backup',
    description: 'A compact window library with sliders, toggles and direct callbacks.',
    tags: ['Window', 'Sliders', 'Toggles'],
    files: {
      source: `${libraryBase}/0x37/source.lua`,
      example: `${libraryBase}/0x37/example.lua`
    },
    showcase: {
      url: `${libraryBase}/0x37/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'apple',
    name: 'Apple Library',
    label: 'Apple Library',
    number: '02',
    type: 'Source',
    description: 'A lightweight library with sections, switches, text fields and notifications.',
    tags: ['Sections', 'Switches', 'Notifications'],
    files: {
      source: `${libraryBase}/Apple/source.lua`,
      example: `${libraryBase}/Apple/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Apple/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'avilon_modified',
    name: 'Avilon-Modified',
    label: 'Avilon-Modified',
    number: '03',
    type: 'Source',
    description: 'A responsive window system with pages, sections, themes and configuration controls.',
    tags: ['Pages', 'Themes', 'Responsive'],
    files: {
      source: `${libraryBase}/Avilon-Modified/source.lua`,
      example: `${libraryBase}/Avilon-Modified/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Avilon-Modified/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'aztup',
    name: 'Aztup',
    label: 'Aztup',
    number: '04',
    type: 'Loadstring + source',
    description: 'A straightforward section-based interface with common Roblox controls.',
    tags: ['Sections', 'Dropdowns', 'Flags'],
    files: {
      source: `${libraryBase}/Aztup/source.lua`,
      example: `${libraryBase}/Aztup/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Aztup/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'bacon',
    name: 'BaconLib',
    label: 'BaconLib',
    number: '05',
    type: 'Source',
    description: 'A compact control panel with text input, dropdown actions, sliders and keybinds.',
    tags: ['Callbacks', 'Dropdowns', 'Keybinds'],
    files: {
      source: `${libraryBase}/Bacon/source.lua`,
      example: `${libraryBase}/Bacon/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Bacon/showcase.mp4`,
      size: '900 × 760'
    }
  },
  {
    id: 'blek',
    name: 'BlekLib',
    label: 'BlekLib',
    number: '06',
    type: 'Loadstring + source',
    description: 'A tabbed window library with character, interface and startup settings.',
    tags: ['Tabs', 'Character', 'Startup'],
    files: {
      source: `${libraryBase}/Blek/source.lua`,
      example: `${libraryBase}/Blek/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Blek/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'criminality_lib',
    name: 'Criminality UI Lib',
    label: 'Criminality UI Lib',
    number: '07',
    type: 'Loadstring + source',
    description: 'A sector-based layout with buttons, toggles, sliders, dropdowns and color controls.',
    tags: ['Sectors', 'Callbacks', 'Colors'],
    files: {
      source: `${libraryBase}/Criminality-Lib/source.lua`,
      example: `${libraryBase}/Criminality-Lib/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Criminality-Lib/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'daino',
    name: 'Daino',
    label: 'Daino',
    number: '08',
    type: 'Loadstring',
    description: 'A tap-based interface with buttons, labels, toggles, sliders and dropdowns.',
    tags: ['Taps', 'Sliders', 'Dropdowns'],
    files: {
      example: `${libraryBase}/Daino/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Daino/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'darkraix',
    name: 'Darkrai X',
    label: 'Darkrai X',
    number: '09',
    type: 'Source',
    description: 'A classic tabbed interface with buttons, toggles, sliders, dropdowns and textboxes.',
    tags: ['Tabs', 'Controls', 'Textboxes'],
    files: {
      source: `${libraryBase}/DarkraiX/source.lua`,
      example: `${libraryBase}/DarkraiX/example.lua`
    },
    showcase: {
      url: `${libraryBase}/DarkraiX/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'dirt',
    name: 'Dirt',
    label: 'Dirt',
    number: '10',
    type: 'Loadstring + source',
    description: 'A flag-driven window library with search, player lists and numeric inputs.',
    tags: ['Flags', 'Search', 'Player list'],
    files: {
      source: `${libraryBase}/Dirt/source.lua`,
      example: `${libraryBase}/Dirt/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Dirt/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'discord_lib',
    name: 'Discord Lib',
    label: 'Discord Lib',
    number: '11',
    type: 'Loadstring',
    description: 'A server and channel layout covering actions, toggles, sliders, dropdowns and binds.',
    tags: ['Servers', 'Channels', 'Binds'],
    files: {
      source: `${libraryBase}/Discord-Lib/source.lua`,
      example: `${libraryBase}/Discord-Lib/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Discord-Lib/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'flux',
    name: 'Flux UI',
    label: 'Flux UI',
    number: '12',
    type: 'Loadstring + source',
    description: 'A tabbed utility window with notifications and a broad set of input controls.',
    tags: ['Tabs', 'Notifications', 'Inputs'],
    files: {
      source: `${libraryBase}/Flux/source.lua`,
      example: `${libraryBase}/Flux/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Flux/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'frisex',
    name: 'FriseX',
    label: 'FriseX',
    number: '13',
    type: 'Loadstring + source',
    description: 'A configurable page and section system with toggles, actions and themed notifications.',
    tags: ['Pages', 'Sections', 'Themes'],
    files: {
      source: `${libraryBase}/FriseX/source.lua`,
      example: `${libraryBase}/FriseX/example.lua`
    },
    showcase: {
      url: `${libraryBase}/FriseX/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'fuzki',
    name: 'Fuzki',
    label: 'Fuzki',
    number: '14',
    type: 'Loadstring + source',
    description: 'A section-oriented interface with labels, buttons, toggles, binds, textboxes and sliders.',
    tags: ['Sections', 'Keybinds', 'Sliders'],
    files: {
      source: `${libraryBase}/Fuzki/source.lua`,
      example: `${libraryBase}/Fuzki/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Fuzki/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'gostmi',
    name: 'Gostmi',
    label: 'Gostmi',
    number: '15',
    type: 'Source',
    description: 'A source-preserved Roblox interface library ready for custom control layouts.',
    tags: ['Source', 'Controls', 'Layout'],
    files: {
      source: `${libraryBase}/Gostmi/source.lua`,
      example: `${libraryBase}/Gostmi/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Gostmi/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'hook',
    name: 'Hook GUI',
    label: 'Hook GUI',
    number: '16',
    type: 'Loadstring',
    description: 'A compact control surface for buttons, toggles, sliders and common interaction patterns.',
    tags: ['Controls', 'Toggles', 'Sliders'],
    files: {
      example: `${libraryBase}/Hook/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Hook/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'nexuslib',
    name: 'NexusLib',
    label: 'NexusLib',
    number: '17',
    type: 'Source',
    description: 'A source-preserved library for arranging window modules and interface settings.',
    tags: ['Modules', 'Settings', 'Source'],
    files: {
      source: `${libraryBase}/NexusLib/source.lua`,
      example: `${libraryBase}/NexusLib/example.lua`
    },
    showcase: {
      url: `${libraryBase}/NexusLib/showcase.mp4`,
      size: '1280 × 800'
    }
  },
  {
    id: 'synergyui',
    name: 'SynergyUI',
    label: 'SynergyUI',
    number: '18',
    type: 'Source',
    description: 'A dark Roblox UI library with tabs, overlays and animated controls.',
    tags: ['Dark theme', 'Tabs', 'Overlays'],
    files: {
      source: `${libraryBase}/SynergyUI/source.lua`,
      example: `${libraryBase}/SynergyUI/example.lua`
    },
    showcase: {
      url: `${libraryBase}/SynergyUI/showcase.mp4`,
      size: '1280 × 820'
    }
  },
  {
    id: 'armenta_lib',
    name: 'Armenta-Lib',
    label: 'Armenta-Lib',
    number: '19',
    type: 'Source',
    description: 'A responsive FyyUI menu with tab factories, themes and callback-driven controls.',
    tags: ['FyyUI.Menu', 'Themes', 'Callbacks'],
    files: {
      source: `${libraryBase}/Armenta-Lib/source.lua`,
      example: `${libraryBase}/Armenta-Lib/example.lua`
    },
    showcase: {
      url: `${libraryBase}/Armenta-Lib/showcase.mp4`,
      size: '1280 × 820'
    }
  },
  {
    id: 'windui_shiny',
    name: 'WindUI-Shiny',
    label: 'WindUI-Shiny',
    number: '20',
    type: 'Source',
    description: 'A source-grounded WindUI window with tabs, themes, modern elements and callback states.',
    tags: ['WindUI', 'Themes', 'Elements'],
    files: {
      source: `${libraryBase}/WindUI-Shiny/source.lua`,
      example: `${libraryBase}/WindUI-Shiny/example.lua`
    },
    showcase: {
      url: `${libraryBase}/WindUI-Shiny/showcase.mp4`,
      size: '1280 × 900'
    }
  }
];

const state = {
  library: libraries[0],
  file: 'source',
  text: '',
  cache: new Map(),
  requestId: 0,
  showcaseZoom: 1
};

const $ = (selector) => document.querySelector(selector);
const $$ = (selector) => [...document.querySelectorAll(selector)];

const elements = {
  drawer: $('#libraryDrawer'),
  drawerBackdrop: $('#drawerBackdrop'),
  menuButton: $('#menuButton'),
  drawerClose: $('#drawerClose'),
  libraryList: $('#libraryList'),
  currentCrumb: $('#currentCrumb'),
  libraryEyebrow: $('#libraryEyebrow'),
  libraryName: $('#libraryName'),
  libraryDescription: $('#libraryDescription'),
  libraryTags: $('#libraryTags'),
  sourceLink: $('#sourceLink'),
  openShowcaseButton: $('#openShowcaseButton'),
  showcaseCard: $('#showcaseCard'),
  expandShowcaseButton: $('#expandShowcaseButton'),
  openShowcaseLink: $('#openShowcaseLink'),
  showcaseVideo: $('#showcaseVideo'),
  showcaseCanvas: $('#showcaseCanvas'),
  zoomOutButton: $('#zoomOutButton'),
  zoomInButton: $('#zoomInButton'),
  zoomResetButton: $('#zoomResetButton'),
  zoomLabel: $('#zoomLabel'),
  showcaseEmpty: $('#showcaseEmpty'),
  showcaseEmptyMessage: $('#showcaseEmptyMessage'),
  showcaseMode: $('#showcaseMode'),
  canvasSize: $('#canvasSize'),
  exampleTab: $('#exampleTab'),
  codeCard: $('#codeCard'),
  codeContent: $('#codeContent'),
  codePre: $('#codePre'),
  lineNumbers: $('#lineNumbers'),
  fileStatus: $('#fileStatus'),
  filePath: $('#filePath'),
  expandCodeButton: $('#expandCodeButton'),
  minimizeCodeButton: $('#minimizeCodeButton'),
  copyActiveButton: $('#copyActiveButton'),
  downloadActiveButton: $('#downloadActiveButton'),
  copyFileButton: $('#copyFileButton'),
  downloadFileButton: $('#downloadFileButton'),
  toast: $('#toast')
};

function showToast(message) {
  elements.toast.textContent = message;
  elements.toast.classList.add('show');
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => elements.toast.classList.remove('show'), 2200);
}

function fileLabel() {
  return `${state.library.name} / ${state.file}.lua`;
}

function closeDrawer() {
  elements.drawer.classList.remove('open');
  elements.drawerBackdrop.classList.remove('open');
  elements.menuButton.setAttribute('aria-expanded', 'false');
}

function toggleDrawer() {
  const open = elements.drawer.classList.toggle('open');
  elements.drawerBackdrop.classList.toggle('open', open);
  elements.menuButton.setAttribute('aria-expanded', String(open));
}

function renderLibraryList() {
  elements.libraryList.innerHTML = libraries.map((library) => `
    <button class="library-item ${library.id === state.library.id ? 'active' : ''}" type="button" data-library="${library.id}">
      <span class="library-number">${library.number}</span>
      <span>
        <span class="library-name">${library.label}</span>
        <span class="library-type">${library.type}</span>
      </span>
      <span class="library-badge">MP4</span>
    </button>
  `).join('');

  $$('.library-item').forEach((item) => {
    item.addEventListener('click', () => selectLibrary(item.dataset.library));
  });
}

function renderHeader() {
  const library = state.library;
  elements.currentCrumb.textContent = library.name;
  elements.libraryEyebrow.textContent = `LIBRARY / ${library.name.toUpperCase()}`;
  elements.libraryName.textContent = library.name;
  elements.libraryDescription.textContent = library.description;
  elements.libraryTags.innerHTML = library.tags.map((tag) => `<span class="tag">${tag}</span>`).join('');
  if (library.files.source) {
    elements.sourceLink.href = library.files.source;
    elements.sourceLink.classList.remove('disabled');
    elements.sourceLink.removeAttribute('aria-disabled');
    elements.sourceLink.textContent = 'Open source';
  } else {
    elements.sourceLink.removeAttribute('href');
    elements.sourceLink.classList.add('disabled');
    elements.sourceLink.setAttribute('aria-disabled', 'true');
    elements.sourceLink.textContent = 'Source unavailable';
  }
  elements.exampleTab.hidden = !library.files.example;
  elements.openShowcaseLink.href = library.showcase.url;
  elements.canvasSize.textContent = library.showcase.size;
  document.title = `VaultUI — ${library.name}`;
}

function showShowcaseUnavailable(message = 'There is no MP4 showcase for this library.') {
  elements.showcaseVideo.hidden = true;
  elements.showcaseEmptyMessage.textContent = message;
  elements.showcaseEmpty.hidden = false;
  elements.showcaseMode.textContent = 'UNAVAILABLE';
}

function renderShowcase() {
  const showcase = state.library.showcase;
  elements.showcaseVideo.pause();
  elements.showcaseVideo.removeAttribute('src');
  elements.showcaseVideo.load();
  elements.showcaseVideo.hidden = true;
  elements.showcaseEmpty.hidden = true;

  if (showcase && showcase.url && /\.mp4$/i.test(showcase.url)) {
    elements.showcaseMode.textContent = 'MP4 VIDEO';
    elements.showcaseVideo.setAttribute('aria-label', `${state.library.name} MP4 showcase video`);
    elements.showcaseVideo.src = showcase.url;
    elements.showcaseVideo.hidden = false;
    return;
  }

  showShowcaseUnavailable();
}

function handleShowcaseVideoError() {
  if (!elements.showcaseVideo.hidden) {
    showShowcaseUnavailable('The MP4 showcase could not be loaded. Add showcase.mp4 to this library folder.');
  }
}

function renderShowcaseZoom() {
  const percentage = Math.round(state.showcaseZoom * 100);
  elements.showcaseCanvas.style.setProperty('--showcase-zoom', state.showcaseZoom);
  elements.zoomLabel.textContent = `${percentage}%`;
  elements.zoomOutButton.disabled = state.showcaseZoom <= 0.7;
  elements.zoomInButton.disabled = state.showcaseZoom >= 1.5;
}

function setShowcaseZoom(value) {
  state.showcaseZoom = Math.min(1.5, Math.max(0.7, Math.round(value * 10) / 10));
  renderShowcaseZoom();
}

function renderLineNumbers(text) {
  const lines = Math.max(1, text.split('\\n').length);
  elements.lineNumbers.textContent = Array.from({ length: lines }, (_, index) => index + 1).join('\\n');
}

function filePathFor(kind = state.file) {
  const folder = state.library.showcase.url.split('/').slice(-2, -1)[0];
  return `Libraries/${folder}/${kind}.lua`;
}

function renderCode(text) {
  elements.codeContent.textContent = text;
  renderLineNumbers(text);
  elements.codePre.scrollTop = 0;
  elements.codePre.scrollLeft = 0;
  elements.filePath.textContent = filePathFor();
  elements.fileStatus.textContent = `${text.split('\n').length.toLocaleString()} lines`;
}

async function loadFile(kind = state.file) {
  state.file = kind;
  $$('.code-tab').forEach((tab) => {
    const active = tab.dataset.file === kind;
    tab.classList.toggle('active', active);
    tab.setAttribute('aria-selected', String(active));
  });

  const url = state.library.files[kind];
  const requestId = ++state.requestId;
  elements.fileStatus.textContent = 'Loading';
  elements.codeContent.textContent = `Loading ${kind}.lua…`;
  elements.lineNumbers.textContent = '';
  elements.filePath.textContent = filePathFor(kind);

  if (!url) {
    state.text = '';
    elements.fileStatus.textContent = 'Not available';
    elements.codeContent.textContent = 'This library does not include an example.lua file.';
    return;
  }

  const cacheKey = `${state.library.id}:${kind}`;
  try {
    let text = state.cache.get(cacheKey);
    if (!text) {
      const response = await fetch(url, { cache: 'no-cache' });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      text = await response.text();
      state.cache.set(cacheKey, text);
    }
    if (requestId !== state.requestId) return;
    state.text = text;
    renderCode(text);
  } catch (error) {
    if (requestId !== state.requestId) return;
    state.text = '';
    elements.fileStatus.textContent = 'Unavailable';
    elements.codeContent.textContent = `Could not load ${kind}.lua. Open the source file directly from the repository.`;
    elements.lineNumbers.textContent = '×';
  }
}

async function selectLibrary(id) {
  const library = libraries.find((item) => item.id === id);
  if (!library || library.id === state.library.id) {
    closeDrawer();
    return;
  }
  state.library = library;
  state.file = 'source';
  setShowcaseZoom(1);
  renderLibraryList();
  renderHeader();
  renderShowcase();
  await loadFile('source');
  closeDrawer();
  window.history.replaceState(null, '', `#${library.id}`);
  if (window.innerWidth <= 700) window.scrollTo({ top: 0, behavior: 'smooth' });
}

async function copyText(text, successMessage) {
  if (!text) {
    showToast('There is no file to copy.');
    return;
  }
  try {
    await navigator.clipboard.writeText(text);
  } catch {
    const area = document.createElement('textarea');
    area.value = text;
    area.style.position = 'fixed';
    area.style.opacity = '0';
    document.body.appendChild(area);
    area.select();
    document.execCommand('copy');
    area.remove();
  }
  showToast(successMessage);
}

function downloadText(text, filename) {
  if (!text) {
    showToast('There is no file to download.');
    return;
  }
  const blob = new Blob([text], { type: 'text/plain;charset=utf-8' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(link.href);
  showToast(`${filename} downloaded.`);
}

function toggleShowcaseExpanded(force) {
  const expanded = typeof force === 'boolean' ? force : !elements.showcaseCard.classList.contains('focused');
  elements.showcaseCard.classList.toggle('focused', expanded);
  document.body.classList.toggle('overlay-open', expanded || elements.codeCard.classList.contains('expanded'));
  elements.expandShowcaseButton.textContent = expanded ? 'Minimize' : 'Expand';
  elements.openShowcaseButton.innerHTML = expanded ? 'Minimize showcase <span>↙</span>' : 'Open showcase <span>↗</span>';
}

function toggleCodeExpanded(force) {
  const expanded = typeof force === 'boolean' ? force : !elements.codeCard.classList.contains('expanded');
  elements.codeCard.classList.toggle('expanded', expanded);
  document.body.classList.toggle('overlay-open', expanded || elements.showcaseCard.classList.contains('focused'));
  elements.expandCodeButton.textContent = expanded ? 'Minimize' : 'Expand';
}

function toggleCodeMinimized() {
  const minimized = elements.codeCard.classList.toggle('minimized');
  elements.minimizeCodeButton.textContent = minimized ? 'Restore' : 'Minimize';
  if (minimized && elements.codeCard.classList.contains('expanded')) toggleCodeExpanded(false);
}

function initEvents() {
  elements.menuButton.addEventListener('click', toggleDrawer);
  elements.drawerClose.addEventListener('click', closeDrawer);
  elements.drawerBackdrop.addEventListener('click', closeDrawer);

  elements.openShowcaseButton.addEventListener('click', () => toggleShowcaseExpanded());
  elements.expandShowcaseButton.addEventListener('click', () => toggleShowcaseExpanded());
  elements.zoomOutButton.addEventListener('click', () => setShowcaseZoom(state.showcaseZoom - 0.1));
  elements.zoomInButton.addEventListener('click', () => setShowcaseZoom(state.showcaseZoom + 0.1));
  elements.zoomResetButton.addEventListener('click', () => setShowcaseZoom(1));
  elements.showcaseVideo.addEventListener('error', handleShowcaseVideoError);
  elements.expandCodeButton.addEventListener('click', () => toggleCodeExpanded());
  elements.minimizeCodeButton.addEventListener('click', toggleCodeMinimized);

  $$('.code-tab').forEach((tab) => tab.addEventListener('click', () => loadFile(tab.dataset.file)));
  elements.copyActiveButton.addEventListener('click', () => copyText(state.text, `${fileLabel()} copied.`));
  elements.copyFileButton.addEventListener('click', () => copyText(state.text, `${fileLabel()} copied.`));
  elements.downloadActiveButton.addEventListener('click', () => downloadText(state.text, `${state.library.name}-${state.file}.lua`));
  elements.downloadFileButton.addEventListener('click', () => downloadText(state.text, `${state.library.name}-${state.file}.lua`));

  document.addEventListener('keydown', (event) => {
    if (event.key !== 'Escape') return;
    closeDrawer();
    toggleShowcaseExpanded(false);
    toggleCodeExpanded(false);
  });

  window.addEventListener('hashchange', () => {
    const id = window.location.hash.slice(1);
    if (libraries.some((library) => library.id === id)) selectLibrary(id);
  });
}

function init() {
  const hashLibrary = libraries.find((library) => library.id === window.location.hash.slice(1));
  if (hashLibrary) state.library = hashLibrary;
  renderLibraryList();
  renderHeader();
  renderShowcase();
  renderShowcaseZoom();
  initEvents();
  loadFile('source');
}

init();
