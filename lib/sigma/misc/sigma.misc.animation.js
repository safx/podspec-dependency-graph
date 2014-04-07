(function(n){"use strict";if("undefined"==typeof sigma)throw"sigma is not declared";sigma.utils.pkg("sigma.misc.animation.running");var i=function(){var n=0;return function(){return""+ ++n}}();sigma.misc.animation.camera=function(a,t,e){if(!(a instanceof sigma.classes.camera&&"object"==typeof t&&t))throw"animation.camera: Wrong arguments.";if("number"!=typeof t.x&&"number"!=typeof t.y&&"number"!=typeof t.ratio&&"number"!=typeof t.angle)throw"There must be at least one valid coordinate in the given val.";var o,r,m,s,g,u,l=e||{},c=sigma.utils.dateNow();return u={x:a.x,y:a.y,ratio:a.ratio,angle:a.angle},g=l.duration,s="function"!=typeof l.easing?sigma.utils.easings[l.easing||"quadraticInOut"]:l.easing,o=function(){var i,e=l.duration?(sigma.utils.dateNow()-c)/l.duration:1;e>=1?(a.isAnimated=!1,a.goTo({x:t.x!==n?t.x:u.x,y:t.y!==n?t.y:u.y,ratio:t.ratio!==n?t.ratio:u.ratio,angle:t.angle!==n?t.angle:u.angle}),cancelAnimationFrame(r),delete sigma.misc.animation.running[r],"function"==typeof l.onComplete&&l.onComplete()):(i=s(e),a.isAnimated=!0,a.goTo({x:t.x!==n?u.x+(t.x-u.x)*i:u.x,y:t.y!==n?u.y+(t.y-u.y)*i:u.y,ratio:t.ratio!==n?u.ratio+(t.ratio-u.ratio)*i:u.ratio,angle:t.angle!==n?u.angle+(t.angle-u.angle)*i:u.angle}),"function"==typeof l.onNewFrame&&l.onNewFrame(),m.frameId=requestAnimationFrame(o))},r=i(),m={frameId:requestAnimationFrame(o),target:a,type:"camera",options:l,fn:o},sigma.misc.animation.running[r]=m,r},sigma.misc.animation.kill=function(n){if(1!==arguments.length||"number"!=typeof n)throw"animation.kill: Wrong arguments.";var i=sigma.misc.animation.running[n];return i&&(cancelAnimationFrame(n),delete sigma.misc.animation.running[i.frameId],"camera"===i.type&&(i.target.isAnimated=!1),"function"==typeof(i.options||{}).onComplete&&i.options.onComplete()),this},sigma.misc.animation.killAll=function(n){var i,a,t=0,e="string"==typeof n?n:null,o="object"==typeof n?n:null,r=sigma.misc.animation.running;for(a in r)e&&r[a].type!==e||o&&r[a].target!==o||(i=sigma.misc.animation.running[a],cancelAnimationFrame(i.frameId),delete sigma.misc.animation.running[a],"camera"===i.type&&(i.target.isAnimated=!1),t++,"function"==typeof(i.options||{}).onComplete&&i.options.onComplete());return t},sigma.misc.animation.has=function(n){var i,a="string"==typeof n?n:null,t="object"==typeof n?n:null,e=sigma.misc.animation.running;for(i in e)if(!(a&&e[i].type!==a||t&&e[i].target!==t))return!0;return!1}}).call(this);