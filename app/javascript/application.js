// Entry point for the build script in your package.json

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// Disable Turbo by default, and let us instead enable it on a per-element basis.
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
import "./controllers/index.js"
