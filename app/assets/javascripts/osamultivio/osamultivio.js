$('a.repository-viewer').enableMultivio({
    method: 'overlay',
    previewWidth: 140,
    previewHeight: 190,
	thumbnailAlign: 'auto',
    supportedDocuments: 'hdl.handle.net|storage.osaarchivum.org',
	multivioClientInstance: 'http://multivio.osaarchivum.org/client',
	multivioServerInstance: 'http://multivio.osaarchivum.org/server',
});
