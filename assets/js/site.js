import $ from 'jquery';
import 'bootstrap';

// console.log('hello from webpack');
//
// $('#exampleModal').on('show.bs.modal', function (e) {
//   console.log('opened');
// });


$(function () {
    $('[data-toggle="tooltip"]').tooltip()
});


$('#storyboard-carousel').carousel({
    interval: false
});
