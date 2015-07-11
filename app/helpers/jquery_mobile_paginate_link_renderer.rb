# Usage:
#
#     = will_paginate @entries,
#       renderer: WillPaginate::ActionView::JqueryMobilePaginateLinkRenderer,
#       previous_label: 'Prev',
#       next_label: 'Next'
#
# Screenshot: http://i.imgur.com/xyFgL.png
#
module WillPaginate
  module ActionView
    class JqueryMobilePaginateLinkRenderer < LinkRenderer
      def pagination
        items = [] # NOTE: ignore the :page_links option
        items.unshift :previous_page
        items.push :next_page
      end

      protected

      def html_container(html)
        tag :div, html, class: 'ui-grid-a'
      end

      def previous_or_next_page(page, text, classname)
        div_attr = {}
        link_attr = {:'data-role' => 'button'}

        unless page
          link_attr[:class] = 'ui-disabled'
        end

        case classname
        when 'previous_page'
          link_attr[:'data-icon'] = 'arrow-l'
          div_attr[:class] = 'ui-block-a'
        when 'next_page'
          link_attr[:'data-icon'] = 'arrow-r'
          link_attr[:'data-iconpos'] = 'right'
          div_attr[:class] = 'ui-block-b'
        end
        tag :div, link(text, page || '#', link_attr), div_attr
      end
    end
  end
end
