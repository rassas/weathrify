# Pin npm packages by running ./bin/importmap

pin "application"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"

pin_all_from 'app/javascript/src', under: 'src', to: 'src'
