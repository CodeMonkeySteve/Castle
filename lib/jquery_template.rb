require 'tilt/template'

class Tilt::JqueryTemplate < Tilt::Template
  self.default_mime_type = 'text/x-jquery-tmpl'

  def prepare; end

  include ActionView::Helpers::JavaScriptHelper

  JSTStart, JSTEnd = "(function(){", "}).call(this);\n"
  def evaluate(scope, locals, &block)
    "#{JSTStart}jQuery.template(\"#{name}\",\"#{escape_javascript(data)}\");#{JSTEnd}"
  end
end

