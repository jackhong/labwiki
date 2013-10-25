module LW::Template
  class Layout < Erector::Widgets::Page
    depends_on :js, "/js/lib/require.js", "data-main" => "js/app"

    depends_on :css, "/css/screen.css", media: "screen, projection"
    depends_on :css, "/css/print.css", media: "print"

    def body_content
      navigation
      div.notification.row { notification }
      div.main.row { main }
      div.footer.row { footer }
    end

    def navigation
      nav(class: "top-bar") {
        ul(class: "title-area") {
          li.name {
            h1 { a("LabWiki", href: "#") }
          }
        }
        section(class: "top-bar-section") {
          ul.right { menu }
        }
      }
    end

    def menu
    end

    def notification
      div(class: "alert-box success") { text @flash[:success] }
      div(class: "alert-box alert") { text @flash[:alert] }
    end

    def main
    end

    def footer
      div(class: "large-12 columns") {
        rawtext "&copy; #{Time.now.year} NICTA"
      }
    end
  end
end
