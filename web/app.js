const libraryBase = window.location.pathname.includes('/web/') ? '../Libraries' : 'Libraries';
const catalogUrl = window.location.pathname.includes('/web/') ? '../catalog.json' : 'catalog.json';
const repositoryApiBase = 'https://api.github.com/repos/Xyraniz/VaultUI';
const librariesTreeUrl = `${repositoryApiBase}/git/trees/main?recursive=1`;

let libraries = [];

const state = {
  library: null,
  file: 'source',
  text: '',
  cache: new Map(),
  requestId: 0,
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
  showcaseFrame: $('#showcaseFrame'),
  showcaseCanvas: $('#showcaseCanvas'),
  showcaseEmpty: $('#showcaseEmpty'),
  showcaseEmptyMessage: $('#showcaseEmptyMessage'),
  showcaseMode: $('#showcaseMode'),
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

function slugify(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '');
}

function displayName(folderName) {
  return folderName.replace(/[-_]+/g, ' ').replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function libraryUrl(folderName, fileName) {
  return `${libraryBase}/${encodeURIComponent(folderName)}/${fileName}`;
}

function libraryFromDirectoryEntry(entry, fileNames, number) {
  const hasSource = fileNames.has('source.lua');
  const hasExample = fileNames.has('example.lua');
  const name = displayName(entry.name);
  const files = {};

  if (hasSource) files.source = libraryUrl(entry.name, 'source.lua');
  if (hasExample) files.example = libraryUrl(entry.name, 'example.lua');

  return {
    id: slugify(entry.name),
    folder: entry.name,
    name,
    label: name,
    number: String(number).padStart(2, '0'),
    type: hasSource && hasExample ? 'Source + example' : hasSource ? 'Source' : 'Example',
    description: `Preserved ${name} library with its available source and runnable example files.`,
    tags: [hasSource ? 'Source' : 'Loadstring', hasExample ? 'Example' : 'Archive'],
    files,
  };
}

async function fetchJson(url) {
  const response = await fetch(url, {
    cache: 'no-cache',
    headers: { Accept: 'application/vnd.github+json' },
  });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return response.json();
}

async function discoverLibraries() {
  try {
    const response = await fetch(catalogUrl, { cache: 'no-cache' });
    if (response.ok) {
      const catalog = await response.json();
      if (Array.isArray(catalog) && catalog.length) return catalog;
    }
  } catch (error) {}

  const tree = await fetchJson(librariesTreeUrl);
  const folders = new Map();

  tree.tree
    .filter((entry) => entry.type === 'blob' && entry.path.startsWith('Libraries/'))
    .forEach((entry) => {
      const parts = entry.path.split('/');
      const [, folderName, fileName] = parts;
      if (parts.length !== 3 || !folderName || !fileName) return;
      if (!folders.has(folderName)) folders.set(folderName, new Set());
      folders.get(folderName).add(fileName.toLowerCase());
    });

  return [...folders.entries()]
    .filter(([, fileNames]) => fileNames.has('source.lua') || fileNames.has('example.lua'))
    .sort(([left], [right]) => left.localeCompare(right, undefined, { numeric: true }))
    .map(([folderName, fileNames], index) => libraryFromDirectoryEntry({ name: folderName }, fileNames, index + 1));
}

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
  if (!libraries.length) {
    elements.libraryList.innerHTML = '<p class="library-empty">No libraries available.</p>';
    return;
  }

  elements.libraryList.innerHTML = libraries.map((library) => `
    <button class="library-item ${library.id === state.library.id ? 'active' : ''}" type="button" data-library="${library.id}">
      <span class="library-number">${library.number}</span>
      <span>
        <span class="library-name">${library.label}</span>
        <span class="library-type">${library.type}</span>
      </span>
      <span class="library-badge">${getShowcase(library.id) ? 'MEGA' : 'NO'}</span>
    </button>
  `).join('');

  $$('.library-item').forEach((item) => {
    item.addEventListener('click', () => selectLibrary(item.dataset.library));
  });
}

function renderCatalogError(message) {
  elements.libraryList.innerHTML = '<p class="library-empty">Library catalog unavailable.</p>';
  elements.currentCrumb.textContent = 'Unavailable';
  elements.libraryEyebrow.textContent = 'LIBRARY / UNAVAILABLE';
  elements.libraryName.textContent = 'Library catalog unavailable';
  elements.libraryDescription.textContent = message;
  elements.libraryTags.innerHTML = '';
  elements.sourceLink.removeAttribute('href');
  elements.sourceLink.classList.add('disabled');
  elements.sourceLink.setAttribute('aria-disabled', 'true');
  elements.openShowcaseButton.disabled = true;
  elements.openShowcaseButton.textContent = 'No Showcase';
  elements.exampleTab.hidden = true;
  showShowcaseUnavailable('The library catalog could not be loaded.');
  elements.fileStatus.textContent = 'Unavailable';
  elements.codeContent.textContent = message;
  elements.lineNumbers.textContent = '×';
  elements.filePath.textContent = 'Libraries/';
}

function renderHeader() {
  const library = state.library;
  if (!library) return;

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
  const showcase = getShowcase(library.id);
  elements.openShowcaseButton.disabled = !showcase;
  elements.openShowcaseButton.innerHTML = showcase ? 'Open showcase <span>↗</span>' : 'No Showcase';
  elements.openShowcaseLink.hidden = !showcase;
  if (showcase) {
    elements.openShowcaseLink.href = showcase.embedUrl;
  } else {
    elements.openShowcaseLink.removeAttribute('href');
  }
  document.title = `VaultUI — ${library.name}`;
}

function showShowcaseUnavailable(message = 'No Showcase') {
  elements.showcaseFrame.hidden = true;
  elements.showcaseFrame.removeAttribute('src');
  elements.showcaseEmptyMessage.textContent = message;
  elements.showcaseEmpty.hidden = false;
  elements.showcaseMode.textContent = 'UNAVAILABLE';
}

function renderShowcase() {
  const showcase = getShowcase(state.library.id);
  elements.showcaseFrame.hidden = true;
  elements.showcaseFrame.removeAttribute('src');
  elements.showcaseEmpty.hidden = true;

  if (showcase && showcase.embedUrl) {
    elements.showcaseMode.textContent = 'MEGA EMBED';
    elements.showcaseFrame.title = `${state.library.name} Mega showcase`;
    elements.showcaseFrame.src = showcase.embedUrl;
    elements.showcaseFrame.hidden = false;
    return;
  }

  showShowcaseUnavailable();
}

function handleShowcaseFrameError() {
  if (!elements.showcaseFrame.hidden) {
    showShowcaseUnavailable('The Mega showcase could not be loaded.');
  }
}

function renderLineNumbers(text) {
  const lines = Math.max(1, text.split('\n').length);
  elements.lineNumbers.textContent = Array.from({ length: lines }, (_, index) => index + 1).join('\n');
}

function filePathFor(kind = state.file) {
  const fileUrl = state.library.files[kind] || state.library.files.example || state.library.files.source;
  const fileName = fileUrl ? fileUrl.split('/').pop() : `${kind}.lua`;
  return `Libraries/${state.library.folder}/${fileName}`;
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
  if (!state.library) return;

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
    elements.codeContent.textContent = `This library does not include a ${kind}.lua file.`;
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
  state.file = library.files.source ? 'source' : 'example';
  renderLibraryList();
  renderHeader();
  renderShowcase();
  await loadFile(state.file);
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
  const hasShowcase = Boolean(state.library && getShowcase(state.library.id));
  elements.openShowcaseButton.innerHTML = !hasShowcase ? 'No Showcase' : expanded ? 'Minimize showcase <span>↙</span>' : 'Open showcase <span>↗</span>';
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
  elements.showcaseFrame.addEventListener('error', handleShowcaseFrameError);
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

async function init() {
  initEvents();
  try {
    libraries = await discoverLibraries();
    if (!libraries.length) throw new Error('No library folders with source.lua or example.lua were found.');
    const hashLibrary = libraries.find((library) => library.id === window.location.hash.slice(1));
    state.library = hashLibrary || libraries[0];
    renderLibraryList();
    renderHeader();
    renderShowcase();
    await loadFile(state.library.files.source ? 'source' : 'example');
  } catch (error) {
    renderCatalogError('The catalog is generated from the repository folders and could not be reached right now.');
  }
}

init();
