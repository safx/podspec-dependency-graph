sigma.parsers.gexf 'data/podspecs.gexf',
 { container: 'graph-container' }, (s) !->
    s.bind 'clickNode', (e) !->
        console.log e.type, e.data.node.label