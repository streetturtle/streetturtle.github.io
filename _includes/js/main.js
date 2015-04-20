jQuery(document).ready(function($){
  // todo: jquery stuff should need to put here.
  $(window).scroll(function(e){
    $el = $('.inner'); 
    if ($(this).scrollTop() > 200 && $el.css('position') != 'fixed'){ 
      $('.inner').css({'position': 'fixed', 'top': '0px'}); 
    }
    if ($(this).scrollTop() < 200 && $el.css('position') == 'fixed')
    {
      $('.inner').css({'position': 'static', 'top': '0px'}); 
    } 
  });
});
