// app/javascript/poppers/my-get-base-placement.js

console.log("Carregando meu getBasePlacement customizado");

const auto = "auto";

function getBasePlacement(placement) {
  console.log("getBasePlacement received placement:", placement);

  if (placement === auto) {
    return auto;
  }

  if (typeof placement !== 'string') {
    console.error("Invalid placement value (não string):", placement);
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

// Expondo a função para o escopo global
window.getBasePlacement = getBasePlacement;