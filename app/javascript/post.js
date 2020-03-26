import Quill from "quill";
import "quill/dist/quill.snow.css";

window.onload = function () {
  const form = document.querySelector("#form");

  if (form) {
    const quill = new Quill("#editor", {
      theme: "snow",
    });

    form.onsubmit = function (e) {
      const postContentInput = document.querySelector("#post_content");
      postContentInput.value = quill.root.innerHTML;
    };
  }
};
