import $ from 'jquery';
import 'bootstrap';
import particlesJS from 'particlesjs';

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

window.onload = function () {
    // https://github.com/marcbruederlin/particles.js
    particlesJS.init({
        selector: '#particles-js',
        color: '#868686',
        connectParticles: true,
        sizeVariations: 1,
        maxParticles: 80,
        speed: 0.35,
        responsive: [
            {
                breakpoint: 768,
                options: {
                    maxParticles: 35,
                }
            }, {
                breakpoint: 425,
                options: {
                    maxParticles: 0,
                }
            }
        ]

    });
};