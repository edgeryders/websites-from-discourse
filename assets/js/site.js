import $ from 'jquery';
import 'bootstrap';

console.log('hello from webpack');

$('#exampleModal').on('show.bs.modal', function (e) {
  console.log('opened');
});
