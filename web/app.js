const libraryBase = window.location.pathname.includes('/web/') ? '../Libraries' : 'Libraries';

const libraries = [
  {
    id: 'synergy',
    name: 'SynergyUI',
    label: 'SynergyUI',
    number: '01',
    type: 'Source',
    description: 'A dark Roblox UI library with tabs, overlays and animated controls.',
    tags: ['Dark theme', 'Tabs', 'Overlays'],
    files: {
      source: `${libraryBase}/SynergyUI/source.lua`,
      example: `${libraryBase}/SynergyUI/example.lua`
    },
    preview: {
      kind: 'iframe',
      url: `${libraryBase}/SynergyUI/preview.html`,
      size: '560 × 380'
    }
  },
  {
    id: 'bacon',
    name: 'BaconLib',
    label: 'BaconLib',
    number: '02',
    type: 'Source',
    description: 'A faithful browser recreation of BaconLib v1.2 running the repository example script.',
    tags: ['Example script', 'Callbacks', 'Touch'],
    files: {
      source: `${libraryBase}/Bacon/source.lua`,
      example: `${libraryBase}/Bacon/example.lua`
    },
    preview: {
      kind: 'iframe',
      url: `${libraryBase}/Bacon/preview.html`,
      size: '240 × 329'
    }
  },
  {
    id: 'armenta',
    name: 'Armenta-Lib',
    label: 'Armenta-Lib',
    number: '03',
    type: 'Source',
    description: 'A live FyyUI.Menu recreation using Armenta-Lib\'s public tab and component factories.',
    tags: ['FyyUI.Menu', 'Themes', 'Callbacks'],
    files: {
      source: `${libraryBase}/Armenta-Lib/source.lua`
    },
    preview: {
      kind: 'iframe',
      url: `${libraryBase}/Armenta-Lib/preview.html`,
      size: '601 × 344'
    }
  },
  {
    id: 'windui-shiny',
    name: 'WindUI-Shiny',
    label: 'WindUI-Shiny',
    number: '04',
    type: 'Source',
    description: 'A source-grounded WindUI-Shiny recreation with its real window defaults, official themes, element families and callback states.',
    tags: ['WindUI', '16 themes', '22 elements', 'Interactive'],
    files: {
      source: `${libraryBase}/WindUI-Shiny/source.lua`
    },
    preview: {
      kind: 'iframe',
      url: `${libraryBase}/WindUI-Shiny/preview.html`,
      size: '580 × 460'
    }
  }
];

const state = {
  library: libraries[0],
  file: 'source',
  text: '',
  cache: new Map(),
  requestId: 0,
  previewZoom: 1
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
  openPreviewButton: $('#openPreviewButton'),
  previewCard: $('#previewCard'),
  expandPreviewButton: $('#expandPreviewButton'),
  openPreviewLink: $('#openPreviewLink'),
  interactivePreview: $('#interactivePreview'),
  previewCanvas: $('#previewCanvas'),
  zoomOutButton: $('#zoomOutButton'),
  zoomInButton: $('#zoomInButton'),
  zoomResetButton: $('#zoomResetButton'),
  zoomLabel: $('#zoomLabel'),
  previewEmpty: $('#previewEmpty'),
  previewMode: $('#previewMode'),
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
      <span class="library-badge">HTML</span>
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
  elements.sourceLink.href = library.files.source;
  elements.exampleTab.hidden = !library.files.example;
  elements.openPreviewLink.href = library.preview.url;
  elements.canvasSize.textContent = library.preview.size;
  document.title = `VaultUI — ${library.name}`;
}

function renderPreview() {
  const preview = state.library.preview;
  elements.interactivePreview.hidden = true;
  elements.previewEmpty.hidden = true;

  if (preview.kind === 'iframe') {
    elements.previewMode.textContent = 'INTERACTIVE';
    elements.interactivePreview.title = `${state.library.name} interactive preview`;
    elements.interactivePreview.src = preview.url;
    elements.interactivePreview.hidden = false;
  } else {
    elements.previewMode.textContent = 'EMPTY';
    elements.previewEmpty.hidden = false;
  }
}

function renderPreviewZoom() {
  const percentage = Math.round(state.previewZoom * 100);
  elements.previewCanvas.style.setProperty('--preview-zoom', state.previewZoom);
  elements.zoomLabel.textContent = `${percentage}%`;
  elements.zoomOutButton.disabled = state.previewZoom <= 0.7;
  elements.zoomInButton.disabled = state.previewZoom >= 1.5;
}

function setPreviewZoom(value) {
  state.previewZoom = Math.min(1.5, Math.max(0.7, Math.round(value * 10) / 10));
  renderPreviewZoom();
}

function renderLineNumbers(text) {
  const lines = Math.max(1, text.split('\n').length);
  elements.lineNumbers.textContent = Array.from({ length: lines }, (_, index) => index + 1).join('\n');
}

function renderCode(text) {
  elements.codeContent.textContent = text;
  renderLineNumbers(text);
  elements.codePre.scrollTop = 0;
  elements.codePre.scrollLeft = 0;
  elements.filePath.textContent = `Libraries/${state.library.name}/${state.file}.lua`;
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
  elements.filePath.textContent = `Libraries/${state.library.name}/${kind}.lua`;

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
  setPreviewZoom(1);
  renderLibraryList();
  renderHeader();
  renderPreview();
  await loadFile('source');
  closeDrawer();
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

function togglePreviewExpanded(force) {
  const expanded = typeof force === 'boolean' ? force : !elements.previewCard.classList.contains('focused');
  elements.previewCard.classList.toggle('focused', expanded);
  document.body.classList.toggle('overlay-open', expanded || elements.codeCard.classList.contains('expanded'));
  elements.expandPreviewButton.textContent = expanded ? 'Minimize' : 'Expand';
  elements.openPreviewButton.innerHTML = expanded ? 'Minimize preview <span>↙</span>' : 'Use preview <span>↗</span>';
}

function toggleCodeExpanded(force) {
  const expanded = typeof force === 'boolean' ? force : !elements.codeCard.classList.contains('expanded');
  elements.codeCard.classList.toggle('expanded', expanded);
  document.body.classList.toggle('overlay-open', expanded || elements.previewCard.classList.contains('focused'));
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

  elements.openPreviewButton.addEventListener('click', () => togglePreviewExpanded());
  elements.expandPreviewButton.addEventListener('click', () => togglePreviewExpanded());
  elements.zoomOutButton.addEventListener('click', () => setPreviewZoom(state.previewZoom - 0.1));
  elements.zoomInButton.addEventListener('click', () => setPreviewZoom(state.previewZoom + 0.1));
  elements.zoomResetButton.addEventListener('click', () => setPreviewZoom(1));
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
    togglePreviewExpanded(false);
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
  renderPreview();
  renderPreviewZoom();
  initEvents();
  loadFile('source');
}

init();
