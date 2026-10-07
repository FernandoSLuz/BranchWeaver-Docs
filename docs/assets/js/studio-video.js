(function () {
  "use strict";

  function bindStudioVideo() {
    var video = document.getElementById("studio-authoring-video");
    if (!video) return;

    document.querySelectorAll("[data-studio-time]").forEach(function (button) {
      if (button.dataset.studioVideoBound === "true") return;
      button.dataset.studioVideoBound = "true";
      button.addEventListener("click", function () {
        video.currentTime = Number(button.getAttribute("data-studio-time"));
        video.scrollIntoView({ block: "center", behavior: "auto" });
        var playback = video.play();
        if (playback && typeof playback.catch === "function") playback.catch(function () {});
      });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", bindStudioVideo, { once: true });
  } else {
    bindStudioVideo();
  }
  if (typeof document$ !== "undefined") document$.subscribe(bindStudioVideo);
}());
