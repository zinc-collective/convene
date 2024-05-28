// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application.js";
import MenuController from "./menu_controller.js";
import Sortable from "@stimulus-components/sortable";

application.register("menu", MenuController);
application.register("sortable", Sortable);
