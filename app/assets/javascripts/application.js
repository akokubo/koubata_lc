// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

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
