$('a.repository-viewer').enableMultivio({
    method: 'overlay',
    previewWidth: 140,
    previewHeight: 190,
	thumbnailAlign: 'auto',
    supportedDocuments: 'hdl.handle.net|storage.osaarchivum.org',
	multivioClientInstance: 'https://multivio.osaarchivum.org/client',
	multivioServerInstance: 'https://multivio.osaarchivum.org/server',
});
