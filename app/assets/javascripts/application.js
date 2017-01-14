// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

function reveal(id) {
  var e = document.getElementById(id);
  if (e.style.display == 'inline') {
    e.style.display = 'none';
  } else {
    var allTexts = document.querySelectorAll(".myHiddenText");
    for (var i = 0, len = allTexts.length; i < len; i++) {
      allTexts[i].style.display = 'none';
    }
    e.style.display = 'inline';
  }
}
