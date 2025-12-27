$(window).scroll(function() {
  if ($(document).scrollTop() > 50) {
    $('nav').addClass('shrink');
  } else {
    $('nav').removeClass('shrink');
  }
});

function slugify(text) {
  return String(text)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-');
}

function buildToc() {
  var $tocSidebar = $('#js-toc-sidebar');
  var $toc = $('#js-toc');
  if ($tocSidebar.length === 0 || $toc.length === 0) {
    return;
  }

  $toc.empty();

  var $content = $('.post-content');
  if ($content.length === 0) {
    $content = $('.well');
  }

  var $headings = $content.find('h2, h3');
  if ($headings.length === 0) {
    $tocSidebar.hide();
    return;
  }

  var usedIds = {};
  $('[id]').each(function() {
    usedIds[$(this).attr('id')] = true;
  });

  $headings.each(function() {
    var $h = $(this);
    var text = $h.text().trim();
    if (!text) {
      return;
    }

    var id = $h.attr('id');
    if (!id) {
      id = slugify(text);
      if (!id) {
        return;
      }
      var base = id;
      var i = 2;
      while (usedIds[id]) {
        id = base + '-' + i;
        i += 1;
      }
      $h.attr('id', id);
      usedIds[id] = true;
    }

    var level = this.tagName.toLowerCase();
    var cls = level === 'h3' ? 'toc-item toc-item-h3' : 'toc-item toc-item-h2';
    var $li = $('<li>').addClass(cls);
    var $a = $('<a>').attr('href', '#' + id).text(text);
    $li.append($a);
    $toc.append($li);
  });

  if ($toc.children().length === 0) {
    $tocSidebar.hide();
  } else {
    $tocSidebar.show();
  }
}

$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();
  buildToc();
});