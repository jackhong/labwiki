require 'erector'

module LW::Template
  class Layout < Erector::Widgets::Page
    depends_on :js, "/js/lib/require.js", "data-main" => "js/app"
    depends_on :css, "/css/screen.css", media: "screen, projection"
    depends_on :css, "/css/print.css", media: "print"

    def body_content
      form(action: "/login", method: "post") {
        h1 "Sign in with OpenID"

        img src: "/login/img/geni.png"

        url "Login with GENI ID", id: "geni", "data-toggle" => "button"

        a(href: "http://www.nicta.com.au", target: "blank") {
          img src: "/login/img/Logo-Nicta-S.jpg"
        }

        a(href: "http://gimi.ecs.umass.edu", target: "blank") {
          img src: "/login/img/logo-gimi.png"
        }
      }
    end
  end
end
