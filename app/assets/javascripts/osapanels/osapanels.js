$("#panel-fullscreen").click(function (e) {
    if($('#sb-site').is(":visible")) {
      $('#panel-fullscreen').html('<i class="fa fa-times"></i> Close')
      $('.item-title').clone().appendTo("#full-screen-placeholder");
      $('#faTableWrapper').appendTo( "#full-screen-placeholder" );
      $('#sb-site').hide();
    } else {
      $('#panel-fullscreen').html('<i class="fa fa-arrows-alt"></i> Full Screen')
      $('#full-screen-placeholder .item-title').remove();
      $('#faTableWrapper').appendTo( "#fa_detailed" );
      $('#sb-site').show();
    }

    e.preventDefault();
});

if (table) {
    table.api().draw();
}
