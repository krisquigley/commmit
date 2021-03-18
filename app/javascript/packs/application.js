import '../application/stylesheets/index.js';
import '../application/javascripts/index.js';
import '../controllers/index.js';

function importAll(r) {
  r.keys().forEach(r);
}

// Add relevant file extensions as needed below.
// I'm sure there is a better way :shrug:
importAll(require.context('../images/', true, /\.(svg|jpg)$/));
