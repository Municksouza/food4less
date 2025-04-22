// app/javascript/poppers/my-get-base-placement.js

console.log("Loading my custom getBasePlacement");

const auto = "auto";

function getBasePlacement(placement) {
  console.log("getBasePlacement received placement:", placement);

  if (placement === auto) {
    return auto;
  }

  if (typeof placement !== 'string') {
    console.error("Invalid placement value (not a string):", placement);
    placement = String(placement || "bottom");
  }
  
  if (placement === "[object Object]" || placement.trim() === "") {
    placement = "bottom";
  }
  
  if (!placement.includes("-")) {
    return placement;
  }
  
  return placement.split('-')[0];
}

// Exposing the function to the global scope
window.getBasePlacement = getBasePlacement;