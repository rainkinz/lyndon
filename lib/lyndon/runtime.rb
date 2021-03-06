# http://developer.apple.com/documentation/Cocoa/Reference/WebKit/ObjC_classic/index.html

module Lyndon
  class Runtime
    def initialize(dom = nil)
      @webView = WebView.new
      @webView.setFrameLoadDelegate(Delegate.new)

      @scripter = @webView.windowScriptObject
      @scripter.setValue(Ruby.new, forKey:"Ruby")

      load_dom(dom) if dom
      eval_file File.dirname(__FILE__) + '/../js/lyndon'
    end

    def eval(js)
      @scripter.evaluateWebScript(js)
    end

    def eval_file(file)
      if File.exists? file = File.expand_path(file.to_s)
        eval File.read(file)
      elsif File.exists? file + '.js'
        eval File.read(file + '.js')
      end
    end

    def load_dom(dom, base_url = nil)
      @dom = File.exists?(dom) ? File.read(dom) : dom
      @webView.mainFrame.loadHTMLString(@dom, baseURL:base_url)
      NSApplication.sharedApplication.run
    end

    def to_s
      @dom ? html_source : super
    end

    def html_source
      '<html>'+eval("document.documentElement.innerHTML")+'</html>'
    end
  end
end
