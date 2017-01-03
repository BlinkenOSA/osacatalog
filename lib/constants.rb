module Constants

  SITE_URL = ''
  FEDORA_URL = ''
  FEDORA_GETFOXML = ''
  FEDORA_RISEARCH_URL = FEDORA_URL + '/risearch'

  TYPE_ICONS = {
      'Book' => 'book',
      'Moving Image' => 'film',
      'Continuing Resource' => 'newspaper-o',
      'Textual' => 'file-text-o',
      'Archival Item (Moving Image)' => 'file-video-o',
      'Archival Unit' => 'archive',
      'Still Image' => 'photo',
      'Audio' => 'file-audio-o',
      'Electronic Record' => 'floppy-o'
  }

  ORIGIN_ICONS = {
      'Archives' => 'A',
      'Finding Aids' => 'FA',
      'Library' => 'L',
      'Film Library' => 'FL',
      'Digital Repository' => 'DR'
  }

  DESCRIPTION_LEVEL_SORT = ['Fonds', 'Subfonds', 'Series', 'Folder', 'Item']

  NIELSEN_TAGS = { '505' => '905', '586' => '986' }

  EXCLUDE_FIELDS = ['w', '0', '5', '6', '8', '?', '=']

  HIDE_1ST_IND = %W(760 762 765 767 770 772 773 774 775 776 777 780 785 786 787)

  HIDE_1ST_IND0 = %W(541 542 561 583 590)

  KOHA_ITEM_TYPES = {
    'BK' => 'Book',
    'BETA-SP' => 'Beta-SP',
    'CD-ROM' => 'CD-ROM',
    'CR' => 'Continuing resources',
    'EPHEMERA' => 'Digitized ephemera',
    'DIA' => 'Digitized filmstrips',
    'DVD-ROM' => 'DVD-ROM',
    'VHS' => 'VHS'
  }

  KOHA_LOCATIONS = {
    'OSA' => 'OSA Archivum Library',
    'OFF' => 'OSA Archivum Off-Site Storage',
    'DIG' => 'OSA Digital Repository',
    'FL' => 'OSA Film Library'
  }

  KOHA_COLLECTIONS = {
    'ARC' => 'Archival, library and information sciences collection',
    'GEN' => 'General collection',
    'Text' => 'History textbook collection',
    'REG' => 'HU OSA 300-85-18 Regional Press',
    'INF' => 'HU OSA 300-85-19 Informal Press',
    'HR' => 'Human Rights (IHF) Collection',
    'SOR' => 'Hungarian Numbered Books',
    'FL' => 'OSA Film Library',
    'REF' => 'Reference collection',
    'SAM' => 'Samizdat and Emigré Publications'
  }

  KOHA_NOT_FOR_LOAN = {
    '0' => 'Not for loan',
    '1' => 'Available'
  }

end
