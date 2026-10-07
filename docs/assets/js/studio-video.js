(function () {
  "use strict";

  function bindStudioVideo() {
    document.querySelectorAll("[data-studio-time]").forEach(function (button) {
      var videoId = button.getAttribute("data-studio-video") || "studio-authoring-video";
      var video = document.getElementById(videoId);
      if (!video || button.dataset.studioVideoBound === videoId) return;
      button.dataset.studioVideoBound = videoId;
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
