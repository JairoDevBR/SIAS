# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "mapbox-gl" # @3.1.2
pin "process" # @2.0.1
pin "@mapbox/mapbox-gl-geocoder", to: "@mapbox--mapbox-gl-geocoder.js" # @5.0.0
pin "#lib/client.js", to: "#lib--client.js.js" # @0.13.7
pin "@mapbox/fusspot", to: "@mapbox--fusspot.js" # @0.4.0
pin "@mapbox/mapbox-sdk", to: "@mapbox--mapbox-sdk.js" # @0.13.7
pin "@mapbox/mapbox-sdk/services/geocoding", to: "@mapbox--mapbox-sdk--services--geocoding.js" # @0.13.7
pin "@mapbox/parse-mapbox-token", to: "@mapbox--parse-mapbox-token.js" # @0.2.0
pin "base-64" # @0.1.0
pin "eventemitter3" # @3.1.2
pin "events" # @3.3.0
pin "fuzzy" # @0.1.3
pin "is-plain-obj" # @1.1.0
pin "lodash.debounce" # @4.0.8
pin "nanoid" # @3.3.7
pin "subtag" # @0.5.0
pin "suggestions" # @1.7.1
pin "xtend" # @4.0.2
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.1.3
