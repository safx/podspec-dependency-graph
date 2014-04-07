!function(){"use strict";sigma.utils.pkg("sigma.webgl.edges"),sigma.webgl.edges.fast={POINTS:2,ATTRIBUTES:3,addEdge:function(o,r,t,i,a,e,l){var c=((o[e+"size"]||1)/2,r[e+"x"]),n=r[e+"y"],u=t[e+"x"],s=t[e+"y"],f=o.color;if(!f)switch(l("edgeColor")){case"source":f=r.color||l("defaultNodeColor");break;case"target":f=t.color||l("defaultNodeColor");break;default:f=l("defaultEdgeColor")}f=sigma.utils.floatColor(f),i[a++]=c,i[a++]=n,i[a++]=f,i[a++]=u,i[a++]=s,i[a++]=f},render:function(o,r,t,i){var a,e=o.getAttribLocation(r,"a_color"),l=o.getAttribLocation(r,"a_position"),c=o.getUniformLocation(r,"u_resolution"),n=o.getUniformLocation(r,"u_matrix");a=o.createBuffer(),o.bindBuffer(o.ARRAY_BUFFER,a),o.bufferData(o.ARRAY_BUFFER,t,o.DYNAMIC_DRAW),o.uniform2f(c,i.width,i.height),o.uniformMatrix3fv(n,!1,i.matrix),o.enableVertexAttribArray(l),o.enableVertexAttribArray(e),o.vertexAttribPointer(l,2,o.FLOAT,!1,this.ATTRIBUTES*Float32Array.BYTES_PER_ELEMENT,0),o.vertexAttribPointer(e,1,o.FLOAT,!1,this.ATTRIBUTES*Float32Array.BYTES_PER_ELEMENT,8),o.lineWidth(3),o.drawArrays(o.LINES,i.start||0,i.count||t.length/this.ATTRIBUTES)},initProgram:function(o){var r,t,i;return r=sigma.utils.loadShader(o,["attribute vec2 a_position;","attribute float a_color;","uniform vec2 u_resolution;","uniform mat3 u_matrix;","varying vec4 color;","void main() {","gl_Position = vec4(","((u_matrix * vec3(a_position, 1)).xy /","u_resolution * 2.0 - 1.0) * vec2(1, -1),","0,","1",");","float c = a_color;","color.b = mod(c, 256.0); c = floor(c / 256.0);","color.g = mod(c, 256.0); c = floor(c / 256.0);","color.r = mod(c, 256.0); c = floor(c / 256.0); color /= 255.0;","color.a = 1.0;","}"].join("\n"),o.VERTEX_SHADER),t=sigma.utils.loadShader(o,["precision mediump float;","varying vec4 color;","void main(void) {","gl_FragColor = color;","}"].join("\n"),o.FRAGMENT_SHADER),i=sigma.utils.loadProgram(o,[r,t])}}}();