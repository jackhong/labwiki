module LW::Template
  class Signin < Layout
    def main
      div(class: "small-12 large-6 small-centered large-centered columns signin") {
        form(action: "/signin", method: "post") {
          img src: "/img/logo_geni.jpg"
          br

          input type: 'hidden', name: 'openid_identifier', value:  "https://portal.geni.net/server/server.php"
          input type: 'submit', value: "Connect", class: "geni-button"

          ul(class: "small-block-grid-4 large-block-grid-4 associations") {
            li {
              a(href: "http://www.nicta.com.au", target: "blank") {
                img src: "/img/logo_nicta.jpg"
              }
            }

            li {
              a(href: "http://gimi.ecs.umass.edu", target: "blank") {
                img src: "/img/logo_gimi.jpg"
              }
            }

            li {
              a(href: "http://www.fed4fire.eu", target: "blank") {
                img src: "/img/logo_f4f.jpg"
              }
            }

            li {
              a(href: "http://www.ict-openlab.eu", target: "blank") {
                img src: "/img/logo_openlab.jpg"
              }
            }
          }
        }
      }
    end
  end
end
