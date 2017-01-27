class YouTube < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s*)?/
  Width    = /width=(\d+)\s/i
  Height   = /height=(\d+)\s/i
  Class    = /class=(([^\s]+)|("[^"]+"))\s/i

  def initialize(tagName, markup, tokens)
    super

    id = markup.sub(Width, '').gsub(Height, '').sub(Class, '').strip
    if !id.empty? then
      @id = id
      @w = height
      @h = width
    else
      raise "No YouTube ID provided in the \"youtube\" tag #{markup}"
    end
  end

  def class
    c = @markup.sub(Preload, '').gsub(Videos, '').sub(Poster, '').gsub(Sizes,'').strip

    if !c.empty?
      "class='#{c}'"
    end
  end

  def height
    h = @markup.scan(Height)

    if h.empty? then
      "height=\"315\""
    else
      "height=\"#{h[0][0]}\""
    end
  end

  def width
    w = @markup.scan(Width)

    if w.empty? then
      "width=\"560\""
    else
      "width=\"#{w[0][0]}\""
    end
  end

  def render(context)
    "<iframe #{@w} #{@h} src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\" allowfullscreen></iframe>"
    # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light\"></iframe>"
  end

  Liquid::Template.register_tag "youtube", self
end


# See https://github.com/octopress/video-tag
class HTMLVideoTag < Liquid::Tag
  @video   = nil
  @poster  = ''
  @height  = ''
  @width   = ''
  Preload  = /(:?preload: *(:?\S+))/i
  Sizes    = /\s(auto|\d\S+)/i
  Poster   = /((https?:\/\/|\/)\S+\.(png|gif|jpe?g)\S*)/i
  Videos   = /((https?:\/\/|\/)\S+\.(webm|ogv|mp4)\S*)/i
  Types    = {
    '.mp4' => "type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'",
    '.ogv' => "type='video/ogg; codecs=\"theora, vorbis\"'",
    '.webm' => "type='video/webm; codecs=\"vp8, vorbis\"'"
  }

  def initialize(tag_name, tag_markup, tokens)
    @markup = tag_markup
    super
  end

  def render(context)
    @markup = process_liquid(context)

    if sources.size > 0
      video =  "<video #{classes} controls #{poster} #{sizes} #{preload} #{click_to_play(context)}>"
      video << sources
      video << "</video>"
    else
      raise "No video mp4, ogv, or webm urls found in {% video #{@markup} %}"
    end
  end

  def click_to_play(context)
    if context.environments.first['site']['click_to_play_video'] != false
      "onclick='(function(el){ if(el.paused) el.play(); else el.pause() })(this)'"
    end
  end

  def sources
    @markup.scan(Videos).map(&:first).compact.map do |v|
      "<source src='#{v}' #{Types[File.extname(v)]}>"
    end.join('')
  end

  def poster
    p = @markup.scan(Poster).map(&:first).compact.first
    "poster='#{p}'" if p
  end

  def sizes
    s = @markup.scan(Sizes).map(&:first).compact
    attrs = "width='#{s[0]}'" if s[0]
    attrs += " height='#{s[1]}'" if s[1]
    attrs
  end

  def preload
    if p = @markup.scan(Preload).flatten.last || "metadata"
      "preload='#{p}'"
    end
  end

  def classes
    classes = @markup.sub(Preload, '').gsub(Videos, '').sub(Poster, '').gsub(Sizes,'').strip

    if !classes.empty?
      "class='#{classes}'"
    end
  end

  def process_liquid(context)
    Liquid::Template.parse(@markup).render!(context.environments.first)
  end

  Liquid::Template.register_tag('video', self)
end
