import $ from 'jquery';
import 'bootstrap';
import particlesJS from 'particlesjs';

// console.log('hello from webpack');
//
// $('#exampleModal').on('show.bs.modal', function (e) {
//   console.log('opened');
// });


window.onload = function () {
    // https://github.com/marcbruederlin/particles.js
    particlesJS.init({
        selector: '#particles-js',
        color: '#868686',
        connectParticles: true,
        sizeVariations: 2,
        maxParticles: 70,
        speed: 0.4,
        responsive: [
            {
                breakpoint: 768,
                options: {
                    maxParticles: 30,
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