import { application } from "./application";

// Importa manualmente os controllers necessários
import HelloController from "./hello_controller.js";
import ToggleController from "./toggle_controller.js";

// Registra controllers
application.register("hello", HelloController);
application.register("toggle", ToggleController);

console.log("✅ Todos os controllers foram carregados corretamente!");