// app/javascript/sushi_zoom_blocker.js
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.sushi-card').forEach(function (card) {
    let lastTouch = 0;

    card.addEventListener('touchstart', function (e) {
      const now = new Date().getTime();
      if (now - lastTouch <= 300) {
        e.preventDefault();
      }
      lastTouch = now;
    }, { passive: false });
  });
});
