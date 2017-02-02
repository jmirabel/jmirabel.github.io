class YouTube < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s*)?/
  Width    = /width=(\d+)\s/i
  Height   = /height=(\d+)\s/i
  Class    = /class=(([^"\s]+)|"([^"]+)")\s/i
  Poster   = /poster=(([^"\s]+)|"([^"]+)")\s/i

  def initialize(tagName, markup, tokens)
    super

    @markup = markup
    id = markup.sub(Width, '').gsub(Height, '').sub(Class, '').sub(Poster, '').strip
    if !id.empty? then
      @id = id
      @w = height
      @h = width
      @c = _class
      @p = poster
    else
      raise "No YouTube ID provided in the \"youtube\" tag #{markup}"
    end
  end

  def _class
    c = @markup.scan(Class)

    if !c.empty?
      if c[0][1]
        "class='#{c[0][1]}'"
      elsif c[0][2]
        "class='#{c[0][2]}'"
      end
    end
  end

  def height
    h = @markup.scan(Height)

    if h.empty? then
      @h_val=315
      "height=\"315\""
    else
      @h_val=h[0][0]
      "height=\"#{h[0][0]}\""
    end
  end

  def poster
    p = @markup.scan(Poster)

    if p.empty? then
      ""
    else
      "#{p[0][0]}"
    end
  end


  def width
    w = @markup.scan(Width)

    if w.empty? then
      @w_val=560
      "width=\"560\""
    else
      @w_val=w[0][0]
      "width=\"#{w[0][0]}\""
    end
  end

  def render(context)
    if @p.empty? then
      "<iframe #{@w} #{@h} #{@c} src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\" allowfullscreen></iframe>"
    else
      if @id.include? "?"
        @id << "&autoplay=1"
      else
        @id << "?autoplay=1"
      end
      "
<div #{@c} style=\"display: table;\">
<div class=\"play-button\" style=\"height: #{@h_val}px; width: #{@w_val}px; background-image: url('#{@p}');\">
<button type=\"button\" class=\"btn btn-default btn-play btn-lg\" onclick=\"removePosterAndPlayVideo($(this), $(this).parent().children('iframe'), 'http://www.youtube.com/embed/#{@id}');\">
<span class=\"glyphicon glyphicon-play-circle\" ></span>
</button>
<iframe style=\"display:none;\" #{@w} #{@h} src=\"\" frameborder=\"0\" allowfullscreen></iframe>
</div>
</div>"
    end
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
