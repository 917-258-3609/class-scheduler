# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@materializecss/materialize", to: "https://cdn.jsdelivr.net/npm/@materializecss/materialize@1.1.0/dist/js/materialize.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "application", preload: true
