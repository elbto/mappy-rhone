import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";

window.Stimulus = Application.start();
const context = require.context("./", true, /\.js$/);
// eslint-disable-next-line no-undef
Stimulus.load(definitionsFromContext(context));
