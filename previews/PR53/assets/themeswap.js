// Overrides Documenter's built-in themeswap.js (which selects a theme based on
// localStorage / prefers-color-scheme) to always force the light theme, so the
// published site never auto-switches to dark or any of the Catppuccin variants.
function set_theme_from_local_storage() {
  document.getElementsByTagName("html")[0].className = "";
  for (var i = 0; i < document.styleSheets.length; i++) {
    var ss = document.styleSheets[i];
    var themename = ss.ownerNode.getAttribute("data-theme-name");
    if (themename === null) continue;
    ss.disabled = themename !== "documenter-light";
  }
}
set_theme_from_local_storage();
