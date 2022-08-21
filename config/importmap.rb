# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "jquery"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@materializecss/materialize", to: "https://ga.jspm.io/npm:@materializecss/materialize@1.1.0/dist/js/materialize.js"
