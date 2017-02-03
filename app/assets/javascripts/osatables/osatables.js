// FA //

if ( $( "#faTable" ).length ) {
  var table = $('#faTable').dataTable({
     "dom":   "<'row header-row'<'col-sm-7'l<'fullscreen'>><'col-sm-5'f>>" +
              "<'row table-data'<'col-sm-12'tr>>" +
              "<'row'<'col-sm-5'i><'col-sm-7'p>>",
     "bPaginate": true,
     "pagingType": "full_numbers",
     "lengthMenu": [[25, 50, -1], [25, 50, "All"]],
     "language": {
       "info": "Showing _START_ to _END_ of _TOTAL_ results",
     },
     "processing": true,
     "columnDefs": [
       { className: "td-center", "targets": [ 1, 3, 4 ] },
       { visible: false, "targets": [ 3, 5 ]}
     ],
     "ordering": false,
     "drawCallback": function(settings){
       $('#faTable tbody tr.group-item').on('click', 'button.fa-show', function () {
            var data = table.api().row( $(this).parents('.group-item') ).data();
            var id = data[3];
            window.location.href = id;
       });
     }
     })
     .rowGrouping({
       bExpandableGrouping: true
     });

  $("div.fullscreen").html('<div class="btn-group" role="group"><a href="#" id="panel-fullscreen" class="btn btn-sm btn-default"><i class="fa fa-arrows-alt"></i> Full Screen</a><a id="scrollToActive" class="btn btn-sm btn-default">Show active</a><a id="expandCollapseFa" class="btn btn-sm btn-default expanded">Collapse All Group</a></div>');

  if (table) {
      table.api().page.jumpToData( "Active", 5 );
  }

  $("#scrollToActive").click(function() {
      var info = table.api().page.info();
      if (info.pages > 1) {
        table.api().page.jumpToData( "Active", 5 );
      }
      $('html, body').animate({
          scrollTop: $("#active-row").offset().top - 160
      }, 500);
  });

  $('#expandCollapseFa').on('click', function () {
      if ($(this).hasClass('collapsed')) {
          $(this).addClass('expanded').removeClass('collapsed').text('Collapse All Group');
          $('#faTable').find('.collapsed-group').trigger('click');
      }
      else {
          $(this).addClass('collapsed').removeClass('expanded').text('Expand All Group');
          $('#faTable').find('.expanded-group').trigger('click');
      }
  });
}

// ISAD //

if ( $( ".faTable_isad" ).length ) {
  var table = $('.faTable_isad').dataTable({
     "dom":   "<'row header-row'<'col-sm-5'l<'fullscreen'>><'col-sm-7'f>>" +
              "<'row table-data'<'col-sm-12'tr>>" +
              "<'row'<'col-sm-5'i><'col-sm-7'p>>",
     "stateSave": true,
     "bPaginate": true,
     "pagingType": "full_numbers",
     "lengthMenu": [[25, 50, 100], [25, 50, 100]],
     "language": {
       "info": "Showing _START_ to _END_ of _TOTAL_ results",
     },
     "processing": true,
     "columnDefs": [
       { className: "td-center", "targets": [ 2, 3 ] },
       { visible: false, "targets": [ 2, 4 ]}
     ],
     "ordering": false,
     "drawCallback": function(settings){
       $('.faTable_isad tbody tr.group-item').on('click', 'button.fa-show', function () {
            var data = table.api().row( $(this).parents('.group-item') ).data();
            var id = data[2];
            window.location.href = id;
       });
     }
     })
     .rowGrouping({
       bExpandableGrouping: true
     });

  $("div.fullscreen").html('<a href="#" id="panel-fullscreen" class="btn btn-sm btn-default"><i class="fa fa-arrows-alt"></i> Full Screen</a>');

  if (table) {
      table.api().page.jumpToData( "Active", 5 );
  }
}

