const juice = require('juice')
const cheerio = require('cheerio')
const sass = require('node-sass')
const pug = require('pug')
const fs = require('fs')
const path = require('path')

// const $ = cheerio.load('<style>#cake {background-color: red;}</style><div id="cake"><a>Cool Stuff</a></div>');
// const result = juice.juiceDocument($);
// console.log(result.html())

class BootstrapEmail {
  constructor(htmlString) {
    this.doc = cheerio.load(htmlString)
  }

  performFullCompile() {
    this.compileHTML()
    this.inlineCSS()
    console.log(this.doc.html())
  }
  // def perform_full_compile
  //   add_layout!
  //   compile_html!
  //   @adapter.inline_css!
  //   inject_head!
  //   @adapter.finalize_document!
  // end

  compileHTML() {
    this.button()
  }

  inlineCSS() {
    this.doc = juice.juiceDocument(this.doc)
  }

  eachElement(selector, func) {
    this.doc(selector).toArray().sort((a, b) => b.parents().length - a.parents().length).forEach(func)
  }
  // def each_node(css_lookup, &blk)
  //   # sort by youngest child and traverse backwards up the tree
  //   @adapter.doc.css(css_lookup).sort_by { |n| n.ancestors.size }.reverse!.each(&blk)
  // end

  template(file, locals = {}) {
    return pug.renderFile(path.resolve(`core/templates/${file}.pug`), {
      cache: true,
      ...locals
    })
  }
  // def template(file, locals_hash = {})
  //   namespace = OpenStruct.new(locals_hash)
  //   template_html = File.read(File.expand_path("../../core/templates/#{file}.html.erb", __dir__))
  //   ERB.new(template_html).result(namespace.instance_eval { binding })
  // end

  button() {
    var classes = null
    var markup = null
    this.eachElement('.btn', el => {
      classes = el.attribs['class']
      this.doc(el).removeAttr('class')
      markup = this.template('table', {classes: classes, contents: this.doc.html(el)})
      this.doc(el).replaceWith(this.doc(markup))
    })
  }
  // def button
  //   each_node('.btn') do |node| # move all classes up and remove all classes from the element
  //     node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
  //   end
  // end
}

const compiler = new BootstrapEmail('<style>#cake {background-color: red;} .btn {color: blue;}</style><div id="cake"><a href="#" class="btn">Cool Stuff</a></div>')
compiler.performFullCompile()
