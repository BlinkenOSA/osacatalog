# To navbar add the info panel
<% if current_page?(controller: 'browse', action: 'fondslist') ||
      current_page?(controller: 'browse', action: 'authors') ||
      current_page?(controller: 'browse', action: 'directors') ||
      current_page?(controller: 'browse', action: 'languages') ||
      current_page?(controller: 'bookmarks', action: 'index') ||
      current_page?(controller: 'search_history', action: 'index') %>
      <div class="pull-right">
          <a href="javascript:void(0);" class="sb-icon-navbar sb-toggle-right"><i class="fa fa-info-circle"></i></a>
      </div>
<% else %>
  <% if has_search_parameters? %>
    <div class="pull-right">
        <a href="javascript:void(0);" class="sb-icon-navbar sb-toggle-right"><i class="fa fa-info-circle"></i></a>
    </div>
  <% end %>
<% end %>
