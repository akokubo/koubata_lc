// Handles "data-method" on links such as:
// <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
// jQuery Mobileのdata-ajax="false"がget以外のメソッドでも有効になるように上書き
jQuery.rails.handleMethod = function(link) {
  var href = jQuery.rails.href(link),
    method = link.data('method'),
    target = link.attr('target'),
    csrf_token = $('meta[name=csrf-token]').attr('content'),
    csrf_param = $('meta[name=csrf-param]').attr('content'),
    form = $('<form method="post" action="' + href + '"></form>'),
    metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

  if (csrf_param !== undefined && csrf_token !== undefined) {
    metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
  }

  if (target) { form.attr('target', target); }

  // 追加部分
  var ajax = link.data('ajax');
  if (ajax !== undefined) {
    form.attr('data-ajax', ajax);
  }

  form.hide().append(metadata_input).appendTo('body');
  form.submit();
};

jQuery(document).bind('mobileinit', function () {
  // console.log('mobileinit');
  jQuery.extend(jQuery.mobile, {
    loadingMessage: 'ロード中',
    pageLoadErrorMessage: 'ページの読み込みに失敗しました',
    ajaxEnabled: false
  });
});

jQuery(document).on('pageshow', function () {
  var change_want_expired_at = function () {
    if (jQuery('#want_no_expiration').is(':checked')) {
      jQuery('#want_expired_at_div').hide();
    } else {
      jQuery('#want_expired_at_div').show();
    }
  };

  var change_offering_expired_at = function () {
    if (jQuery('#offering_no_expiration').is(':checked')) {
      jQuery('#offering_expired_at_div').hide();
    } else {
      jQuery('#offering_expired_at_div').show();
    }
  };

  jQuery('#want_no_expiration').click(function () {
    change_want_expired_at();
  });

  jQuery('#offering_no_expiration').click(function () {
    change_offering_expired_at();
  });

  change_offering_expired_at();
  change_want_expired_at();
});
