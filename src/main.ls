
_ = require 'prelude-ls'


package_data = {}

$ .ajax {
  url: 'data/podspecs.json'
  success: (d) !->
      package_data := d
      console.log package_data
}


sigma.parsers.gexf 'data/podspecs.gexf',
 { container: 'graph-container' }, (s) !->
    s.bind 'clickNode', (e) !->
        return unless package_data?

        package_name = e.data.node.label
        info = package_data[package_name]

        authors = if Array.isArray info.authors then (info.authors.join ', ') else (_.Obj.keys info.authors)

        console.log info
        $.magnificPopup.open {
          items: {
            src: """
<div class="popup">
  <div><a href="#{info.homepage}">#{info.name}</a></div>
  <div>#{info.summary}</div>
  <div><span>Author:</span> #{authors}</div>
</div>'"""
            type: 'inline'
          }
        }
