# Pin npm packages by running ./bin/importmap

pin "application"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"

pin_all_from "app/javascript/src", under: "src"
pin "htm", to: "https://esm.run/htm@3.1.1"
pin "react", to: "https://esm.run/react@19"
pin "react-dom-client", to: "https://esm.run/react-dom@19/client"
pin_all_from "app/javascript/components", under: "components"
